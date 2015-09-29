package co.amis {    
    import feathers.controls.StackScreenNavigator;
    import feathers.controls.StackScreenNavigatorItem;
    import feathers.motion.Slide;
    
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
        private var _navigator:StackScreenNavigator;
        
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
        public function load(screens:Array, theme:Class=null):void {
            if(theme) var _theme:* = new theme();
            
            // initialize sound manager
            this.soundManager = SoundManager.getInstance();
//            soundManager.addSound("click", Assets.manager.getSound("click"));
            
            // create and add to stage the navigator
            this._navigator = new StackScreenNavigator();                                   
            this.addChild( this._navigator );
            
            //configure default transitions for push and pop
            this._navigator.pushTransition = Slide.createSlideLeftTransition();
            this._navigator.popTransition = Slide.createSlideRightTransition();
            
            // Loop screens and register it to the stack navigator so it can be called later
            var i:int = 0;
            var screensLength:int = screens.length;
            var screen:Object;
            var screenNavigatorItem:StackScreenNavigatorItem;
            for(; i < screensLength; i++) {
                screen = screens[i];
                screenNavigatorItem = new StackScreenNavigatorItem(screen.screenClass);
                this._navigator.addScreen(screen.id , screenNavigatorItem);
                
                // set root screen
                if(i == 0) { 
                    this._navigator.rootScreenID = screen.id;
                }
            }
        }
        
        /**
        * 
        * push screen with @id into the stack
        * 
        * @param String id
        * 
         */
        public static function gotoScreen(id:String, pushTransition:Function = null, popTransition:Function = null):void {
            

            if(pushTransition) Amis.getInstance()._navigator.pushTransition = pushTransition();
            else Amis.getInstance()._navigator.pushTransition = Slide.createSlideLeftTransition();
            if(popTransition) Amis.getInstance()._navigator.popTransition = popTransition();
            else Amis.getInstance()._navigator.popTransition = Slide.createSlideRightTransition();

            Amis.getInstance()._navigator.pushScreen(id);
        }
        
        /**
        * 
        * Pop current screen from stack
        * 
         */
        public static function popScreen():void {
            Amis.getInstance()._navigator.popScreen();
        }
        
    }
}