package co.amis {    
    import oSound.SoundManager;
    
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.utils.Color;
    
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
        
        /**
        * 
        * Loads the final stuff like sound manager, calculates the stage size,
        * databases, ...
        * 
         */
        public function load():void {                                                                                    
            // initialize sound manager
            this.soundManager = SoundManager.getInstance();
//            soundManager.addSound("click", Assets.manager.getSound("click"));            
            
            var quad:Quad = new Quad(Amis.FULL_STAGE_WIDTH, Amis.FULL_STAGE_HEIGHT, Color.AQUA);
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
            
            quad = new Quad(Amis.HALF_STAGE_WIDTH, Amis.HALF_STAGE_HEIGHT, Color.RED);
            quad.alpha = .4;
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
            
            quad = new Quad(Amis.FULL_STAGE_WIDTH + 100, Amis.HALF_STAGE_HEIGHT*.5, Color.YELLOW);
            quad.alpha = .6;
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
            
            this.stage.addEventListener(ResizeEvent.RESIZE, onResizeStage);            
        }
        
        private function onResizeStage(e:ResizeEvent):void
        {
            this.removeChildren();
            
            var quad:Quad = new Quad(Amis.FULL_STAGE_WIDTH, Amis.FULL_STAGE_HEIGHT, Color.AQUA);
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
            
            quad = new Quad(Amis.HALF_STAGE_WIDTH, Amis.HALF_STAGE_HEIGHT, Color.RED);
            quad.alpha = .4;
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
            
            quad = new Quad(Amis.FULL_STAGE_WIDTH + 100, Amis.HALF_STAGE_HEIGHT*.5, Color.YELLOW);
            quad.alpha = .6;
            quad.x = 0;
            quad.y = 0;
            addChild(quad);
        }        
        
        
    }
}