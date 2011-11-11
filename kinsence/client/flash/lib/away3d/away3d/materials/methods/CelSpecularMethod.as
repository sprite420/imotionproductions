package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.utils.ShaderRegisterCache;
	import away3d.materials.utils.ShaderRegisterElement;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;

	use namespace arcane;

	/**
	 * CelSpecularMethod provides a shading method to add diffuse cel (cartoon) shading.
	 */
	public class CelSpecularMethod extends WrapSpecularMethod
	{
		private var _dataReg : ShaderRegisterElement;
		private var _dataIndex : int;
		private var _data : Vector.<Number>;

		/**
		 * Creates a new CelSpecularMethod object.
		 * @param specularCutOff The threshold at which the specular highlight should be shown.
		 * @param baseSpecularMethod An optional specular method on which the cartoon shading is based. If ommitted, BasicSpecularMethod is used.
		 */
		public function CelSpecularMethod(specularCutOff : Number = .5, baseSpecularMethod : BasicSpecularMethod = null)
		{
			super(clampSpecular, baseSpecularMethod);
			_data = new Vector.<Number>(4, true);
			_data[0] = .1;
			_data[1] = specularCutOff;
		}

		/**
		 * The smoothness of the highlight edge.
		 */
		public function get smoothness() : Number
		{
			return _data[0];
		}

		public function set smoothness(value : Number) : void
		{
			_data[0] = value;
		}

		/**
		 * The threshold at which the specular highlight should be shown.
		 */
		public function get specularCutOff() : Number
		{
			return _data[1];
		}

		public function set specularCutOff(value : Number) : void
		{
			_data[1] = value;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(stage3DProxy : Stage3DProxy) : void
		{
			super.activate(stage3DProxy);
			stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _dataIndex, _data, 1);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function cleanCompilationData() : void
		{
			super.cleanCompilationData();
			_dataReg = null;
		}

		/**
		 * Snaps the specular shading strength of the wrapped method to zero or one, depending on whether or not it exceeds the specularCutOff
		 * @param t The register containing the specular strength in the "w" component, and either the half-vector or the reflection vector in "xyz".
		 * @param regCache The register cache used for the shader compilation.
		 * @return The AGAL fragment code for the method.
		 */
		private function clampSpecular(target : ShaderRegisterElement, regCache : ShaderRegisterCache) : String
		{
			return 	"sub " + target+".y, " + target+".w, " + _dataReg+".y\n" + // x - cutoff
					"div " + target+".y, " + target+".y, " + _dataReg+".x\n" + // (x - cutoff)/epsilon
					"sat " + target+".y, " + target+".y\n" +
					"sge " + target+".w, " + target+".w, " + _dataReg+".y\n" +
					"mul " + target+".w, " + target+".w, " + target+".y\n";
		}

		/**
		 * @inheritDoc
		 */
		override arcane function getFragmentAGALPreLightingCode(regCache : ShaderRegisterCache) : String
		{
			_dataReg = regCache.getFreeFragmentConstant();
			_dataIndex = _dataReg.index;
			return super.getFragmentAGALPreLightingCode(regCache);
		}
	}
}
