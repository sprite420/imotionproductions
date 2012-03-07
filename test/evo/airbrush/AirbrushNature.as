package test.evo.airbrush
{
    import test.evo.scribbler.*;
    import flash.display.BitmapData;

    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.range.Range;

    import test.evo.nature.BitmapNature;


    /**
     * @author Pieter van de Sluis
     */
    public class AirbrushNature extends BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _currMinSize    :Number;
        private var _currMaxSize    :Number;

        private var _minSizeRange   :Range = new Range( 100, 10 );
        private var _maxSizeRange   :Range = new Range( 150, 15 );

        private var _numEvosRange   :Range = new Range( 50, 500 );

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AirbrushNature( sourceBitmapData:BitmapData )
        {
            super( sourceBitmapData );

            minEvoFitness = 0.8;
            maxNumPopulations = 3;
//            useMating = false;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override protected function createEvo():IBitmapEvolver
        {
            var evo:AirbrushEvolver = new AirbrushEvolver( sourceBitmapData.width, sourceBitmapData.height );
            evo.minSize = _currMinSize;
            evo.maxSize = _currMaxSize;

            return evo;
        }


        override protected function resetEvo( evo:IBitmapEvolver ):void
        {
            var s:AirbrushEvolver = evo as AirbrushEvolver;
            s.minSize = _currMinSize;
            s.maxSize = _currMaxSize;

            super.resetEvo( evo );
        }


        override protected function initializePopulation( useMating:Boolean = true ):void
        {
            var relPop:Number = ( status.populationNr - 1 ) / ( maxNumPopulations - 1 );
            numEvosPerPopulation = _numEvosRange.getValueFromRelativePos( relPop );

            _currMinSize = _minSizeRange.getValueFromRelativePos( relPop );
            _currMaxSize = _maxSizeRange.getValueFromRelativePos( relPop );

            super.initializePopulation( useMating );
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}