package co.amis {
    
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import co.amis.events.AssetsEvent;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
    
    /**
    * 
    * Initial class responsable for initializing the 
    * Starling enviroment. 
    * 
    */
	public class AmisMain extends Sprite {		                       
        // ---
        
        private var _debug:TextField;
        private var _startupImage:Sprite;
        private var _starling:Starling;
        private var _amis:Amis;
        private var _assets:Assets;
        
        /**
        * It's tottaly needed to call supper in the class
        * extending this one. 
        *         
        * @param args arguments for the AmisMain
        *               bool multitouchEnabled
        *               array splashes array    
        * 
        */
        public function AmisMain(args:Object=null) {
			if(!args) args = {};
            
            // call flash.display.Sprite 
            super();     
            
            
            // sets the scaleMode and align for the air stage
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            // setting up the debug stuff
            if(args.debug){                
                _debug = new TextField();
                _debug.width = screenWidth;
                _debug.height = screenHeight;
                _debug.multiline = true;
                this.addDebug("");this.addDebug("");this.addDebug(""); // just for space ;)                
            }
            
            if(args.multitouchEnabled)
                Starling.multitouchEnabled = true;
            //Starling.handleLostContext = false;
            
            Assets.splashes = args.splashes;
            
            // setting up the content scale factor to get the correct assets
            var screenWidth:int  = stage.fullScreenWidth;
            var screenHeight:int = stage.fullScreenHeight;
            var viewPort:Rectangle = new Rectangle();
            
            // set the content scale factor
            Assets.contentScaleFactor = Math.min((screenWidth / Amis.STAGE_WIDTH), (screenHeight / Amis.STAGE_HEIGHT));            

            viewPort = RectangleUtil.fit (
                new Rectangle(0, 0, screenWidth/Assets.normalizedScaleFactor, screenHeight/Assets.normalizedScaleFactor),
                new Rectangle(0, 0, screenWidth, screenHeight),
                ScaleMode.NO_BORDER
            );
            
            this.setupSplashImage(viewPort);
            
            
            this._starling = new Starling(Amis, stage, viewPort);
            this._starling.stage3D.addEventListener(flash.events.Event.CONTEXT3D_CREATE, onStarlingStage3dContext3dCreate)            
            
            // Sets native aplication events
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, this.onActivate);
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, this.onDeactivate);
		}
        
        /**
        * 
        * has created the context3d in stage3d
        * This method is responsable for calling Assets to preload assets
        * 
        * @param flash.events.Event 
        * 
         */
        protected function onStarlingStage3dContext3dCreate(e:flash.events.Event):void
        {
            // load assets
            _assets = new Assets();
            _assets.addEventListener(AssetsEvent.ASSETS_LOADED, onAssetsLoaded);
            _assets.load();
        }
        
        /**
        * 
        * Start starling and initialize stuff
        * 
        * @param flash.events.Event
        * 
         */
        protected function onAssetsLoaded(e:flash.events.Event):void
        {        
            _assets.removeEventListener(AssetsEvent.ASSETS_LOADED, onAssetsLoaded);
        }        
        
        
        /**
        * 
        * Adds the same image as the splash untils the assets are all loaded 
        * 
         */
        private function setupSplashImage(viewPort:Rectangle):void {
            this._startupImage = new Sprite();
            this._startupImage.addChild( Assets.getSplashScreen(stage.fullScreenHeight) as Bitmap );
            
            this._startupImage.x = stage.fullScreenWidth * 0.5 - this._startupImage.width * 0.5;
            this._startupImage.y = stage.fullScreenHeight * 0.5 - this._startupImage.height * 0.5;
            
//            addChild(_startupImage);            
        }
        
        /**
        * 
        * Just a debug function never use it!
        *  
        */
        private function addDebug(str:String):void {
            _debug.text += str+'\n';
        }
        
        
        /**
        * 
        * App Lauched event
        * 
         */
        private function onActivate(e:flash.events.Event):void {
            _starling.start();
            if(_amis) {
                _amis.soundManager.muteAll(false);
            }
        }
        
        /**
         * 
         * App Deactive event
         * 
         */
        private function onDeactivate(e:flash.events.Event):void {
            _starling.stop(true);
            if(_amis) {
                _amis.soundManager.muteAll();
            }			
        }
        
	}
    
}