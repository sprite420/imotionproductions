package interfaces
{
    /**
     * @author Pieter van de Sluis
     */
    public interface IServerMessageHandler
    {
        function onServerMessage( type:String, data:* ):void
    }
}
