package nl.imotion.burst.components 
{

	import flash.display.Sprite;
	import nl.imotion.burst.components.events.BurstComponentEvent;

	[Event("burstComponentEvent")]

	public class BurstSprite extends Sprite implements IBurstComponent 
	{

		public function BurstSprite() 
		{
			
		}
		

		override public function set width( value:Number ):void 
		{
			if ( value != super.width )
			{
				super.width = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.WIDTH_CHANGED ) );
			}
			
		}

		override public function set height( value:Number ):void 
		{
			if ( value != super.height )
			{
				super.height = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.HEIGHT_CHANGED ) );
			}
			
		}

		override public function set scaleX( value:Number ):void 
		{
			if ( value != super.scaleX )
			{
				super.scaleX = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.WIDTH_CHANGED ) );
			}
			
		}

		override public function set scaleY( value:Number ):void 
		{
			if ( value != super.scaleY )
			{
				super.scaleY = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.HEIGHT_CHANGED ) );
			}
			
		}
		
		
		public function get explicitWidth():Number 
		{
			return this.width;
		}
		
		
		public function set explicitWidth( value:Number ):void 
		{
			this.width = value;
		}
		
		
		public function get explicitHeight():Number 
		{
			return this.height;
		}
		
		
		public function set explicitHeight( value:Number ):void 
		{
			this.height = value;
		}

	}
}