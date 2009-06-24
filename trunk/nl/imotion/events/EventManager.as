package nl.imotion.events
{
	import flash.events.IEventDispatcher;
	
	
	public class EventManager
	{
		private var listenerMap:/*EventListenerInfo*/Array = [];
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
		
		public function EventManager() { }
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                  P U B L I C     |
        //__________________________________________________________________________________________________________________|
		
        /**
         * Registers an event listener object.
         *
         * @param target            <IEventDispatcher> The target EventDispatcher that the event listener has been added to.
         * @param type              <String> The type of event.
		 * @param listener          <Function> The listener function that processes the event. This function must accept an event object
		 *                            as its only parameter and must return nothing, as this example shows:
		 *                            function(evt:Event):void
		 *                            The function can have any name.
		 * @param useCapture        <Boolean (default = false)> Determines whether the listener works in the capture phase or the target
		 *                            and bubbling phases. If useCapture is set to true, the
		 *                            listener processes the event only during the capture phase and not in the target or
		 *                            bubbling phase. If useCapture is false, the listener processes the event only
		 *                            during the target or bubbling phase. To listen for the event in all three phases, call
		 *                            addEventListener() twice, once with useCapture set to true,
		 *                            then again with useCapture set to false.
         */
		public function registerListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			for each( var l:EventListener in listenerMap )
			{
				if ( (target == l.target ) && ( type == l.type ) && ( listener == l.listener ) && ( useCapture == l.useCapture ) )
				{
					return;
				}
			}
			
			listenerMap.push( new EventListener( target, type, listener, useCapture ) );
		}
		
		
        /**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener
		 *  registered with the EventDispatcher object, a call to this method has no effect.
		 * 
		 * @param target            <IEventDispatcher> The target EventDispatcher that the event listener has been added to.
		 * @param type              <String> The type of event.
		 * @param listener          <Function> The listener object to remove.
		 * @param useCapture        <Boolean (default = false)> Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both: one call with useCapture set to true, and another call with useCapture set to false.
		 */
		public function removeListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
            for ( var i:int = 0; i < listenerMap.length; i++ )
            {
                var l:EventListener = listenerMap[ i ];

                if ( (target == l.target ) && ( type == l.type ) && ( listener == l.listener ) && ( useCapture == l.useCapture ) )
                {
                    removeListenerByIndex( i );
                }
            }
		}
		
        /**
		 * Removes a listener from multiple EventDispatcher objects. If there is no matching listener
		 *  registered with the EventDispatcher object, a call to this method has no effect.
		 *
		 * @param target            <Array> An Array of EventDispatchers that the event listener has been added to.
		 * @param type              <String> The type of event.
		 * @param listener          <Function> The listener object to remove.
		 * @param useCapture        <Boolean (default = false)> Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both: one call with useCapture set to true, and another call with useCapture set to false.
		 */
        public function removeMultipleListeners( targets:/*IEventDispatcher*/Array, type:String, listener:Function, useCapture:Boolean = false ):void
        {
            for each( var target:IEventDispatcher in targets )
            {
                this.removeListener( target, type, listener, useCapture );
            }
        }

		
        /**
         * Removes all registered event listenerMap
         */
		public function removeAllListeners():void
		{
            for ( var i:int = listenerMap.length - 1; i >= 0; i-- )
            {
                removeListenerByIndex( i );
            }
		}
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                P R I V A T E     |
        //__________________________________________________________________________________________________________________|
		
        private function removeListenerByIndex( index:uint ):void
        {
            var l:EventListener = listenerMap[ index ];
			
            if ( l )
            {
				if ( l.target )
				{
					l.target.removeEventListener( l.type, l.listener, l.useCapture );
				}
				
                listenerMap.splice( index, 1 );
            }
        }
	}
}