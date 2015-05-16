package co.amis {
    import oSound.SoundManager;
    
    import starling.display.Sprite;
    
    public class Amis extends Sprite {
        
        /**
         * 
         * Some constants and static vars for use across the app
         * 
         */
        public static const STAGE_WIDTH:int  = 320;
        public static const STAGE_HEIGHT:int = 480;
        public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
        
        public static var FULL_STAGE_WIDTH:int = 0;
        public static var FULL_STAGE_HEIGHT:int = 0;
        
        public static var HALF_STAGE_WIDTH:int = 0;
        public static var HALF_STAGE_HEIGHT:int = 0;
        
        // ---
        private static var _instance:Amis;
        
        public var soundManager:SoundManager;
        
        /**
        * 
        * Constructor throwing a error if trying to create a new instance
        * 
         */
        public function Amis() {
            if(_instance){
                throw new Error("Singleton... use getInstance()");
            } 
            _instance = this;
        }
        
        /**
        * 
        * Static function to get the singleton instance from Amis
        * 
        * @return Amis instance
        * 
         */
        public static function getInstance():Amis {
            if(!_instance){
                new Amis();                               
            } 
            return _instance;
        }
        
    }
}