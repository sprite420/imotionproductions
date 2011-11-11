package modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class SkeletonData
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var joints:Vector.<Joint>;
        public var position:KinectVector;
        public var skeletonQuality:uint;
        public var trackingID:int;
        public var trackingState:uint;
        public var userIndex:int;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SkeletonData()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            joints = new Vector.<Joint>();
            for each ( var jointObject:Object in object.Joints )
            {
                var joint:Joint = new Joint();
                joint.fromObject( jointObject );
                joints[ joints.length ] = joint;
            }

            position = new KinectVector();
            position.fromObject( object.Position );

            skeletonQuality = object.SkeletonQuality;

            trackingID = object.TrackingID;

            trackingState = object.TrackingState;

            userIndex = object.UserIndex;
        }


        public function getJointByID( jointID:uint ):Joint
        {
            return joints[ jointID ];
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