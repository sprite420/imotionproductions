package modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class SkeletonFrame
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var floorClipPlane:KinectVector;
        public var frameNumber:int;
        public var normalToGravity:KinectVector;
        public var skeletonFrameQuality:uint;
        public var skeletons:Vector.<SkeletonData>;
        public var timeStamp:uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SkeletonFrame()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            floorClipPlane = new KinectVector();
            floorClipPlane.fromObject( object.FloorClipPlane );

            frameNumber = object.FrameNumber;

            normalToGravity = new KinectVector();
            normalToGravity.fromObject( object.NormalToGravity );

            skeletonFrameQuality = uint( object.SkeletonFrameQuality );

            skeletons = new Vector.<SkeletonData>();
            for each ( var skeletonObject:Object in object.Skeletons )
            {
                var skeletonData:SkeletonData = new SkeletonData();
                skeletonData.fromObject( skeletonObject );
                skeletons[ skeletons.length ] = skeletonData;
            }

            timeStamp = object.TimeStamp;
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