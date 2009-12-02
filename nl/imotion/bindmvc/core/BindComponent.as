package nl.imotion.bindmvc.core
{

	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	import nl.imotion.bindmvc.model.IBindModel;
	import nl.imotion.notes.Note;
	import nl.imotion.notes.NoteDispatcher;
	
	
	public class BindComponent implements IDestroyable
	{
		
		protected function retrieveModel( name:String ):IBindModel
		{
			return BindMVCCore.getInstance().retrieveModel( name );
		}
		
		
		private var _eventManager:EventManager;
		private function get eventManager():EventManager
		{
			if ( !_eventManager ) _eventManager = new EventManager();
			return _eventManager;
		}
		
		protected function startEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			switch( true )
			{
				case ( target is IEventDispatcher ):
					registerEventListener( target, type, listener, useCapture, priority, useWeakReference );
				break;
					
				case ( target is Array ):
					for each( var currTarget:* in target )
					{
						if ( currTarget is IEventDispatcher )
						{
							registerEventListener( IEventDispatcher( currTarget ), type, listener, useCapture, priority, useWeakReference );
						}
					}
				break;
				
			}
		}		
		
		
		private function registerEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			target.addEventListener( type, listener, useCapture, priority, useWeakReference );
			
			eventManager.registerListener( target, type, listener, useCapture );
		}
		
		
		protected function stopEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			switch( true )
			{
				case ( target is IEventDispatcher ):
					unregisterEventListener( target, type, listener, useCapture );
				break;
					
				case ( target is Array ):
					for each( var currTarget:* in target )
					{
						if ( currTarget is IEventDispatcher )
						{
							unregisterEventListener( IEventDispatcher( currTarget ), type, listener, useCapture );
						}
					}
				break;
			}
		}
		
		
		private function unregisterEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventManager.removeListener( target, type, listener, useCapture );
		}
		
		
		protected function dispatchNote( note:Note ):void
		{
			NoteDispatcher.getInstance().dispatchNote( note );
		}
		
		
		public function destroy():void
		{
			if ( _eventManager != null )
			{
				_eventManager.removeAllListeners();
				_eventManager = null;
			}
		}
		
	}
	
}