package co.amis {
    
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.flash_proxy;
	
	import co.amis.events.AssetsEvent;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.ResizeEvent;
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
        private var _splashImage:Sprite;
        private var _starling:Starling;
        private var _amis:Amis;
        private var _assets:Assets;
        private var _screens:Array;
        private var _theme:Class;
        private var _useGestouch:Boolean;
        
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
            
            // save screens in local var
            _screens = args.screens;
            
            // sets the scaleMode and align for the air stage
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;      
			stage.displayState = StageDisplayState.NORMAL;
            
            if(args.theme) this._theme = args.theme;
            
            if(args.multitouchEnabled)
                Starling.multitouchEnabled = true;
            Starling.handleLostContext = false;
            
            Assets.splashes = args.splashes;
            
            // setting up the content scale factor to get the correct assets
            var screenWidth:int  = stage.fullScreenWidth;			
            var screenHeight:int = stage.fullScreenHeight;			
            var viewPort:Rectangle = new Rectangle();
            
            // set the content scale factor
            Assets.contentScaleFactor = Math.min((screenWidth / Amis.STAGE_WIDTH), (screenHeight / Amis.STAGE_HEIGHT));            
            
            // set view port of the screen
            viewPort = RectangleUtil.fit (
                new Rectangle(0, 0, screenWidth/Assets.normalizedScaleFactor, screenHeight/Assets.normalizedScaleFactor),
                new Rectangle(0, 0, screenWidth, screenHeight),
                ScaleMode.NO_BORDER
            );
            
/*
            var screenWidth:int  = stage.fullScreenWidth;
            var screenHeight:int = stage.fullScreenHeight;
            var viewPort:Rectangle = new Rectangle();

            Assets.contentScaleFactor = Math.min((screenWidth / Constants.STAGE_WIDTH), (screenHeight / Constants.STAGE_HEIGHT));

            viewPort = RectangleUtil.fit(
                    new Rectangle(0, 0, screenWidth/Assets.normalizedScaleFactor, screenHeight/Assets.normalizedScaleFactor),
                    new Rectangle(0, 0, screenWidth, screenHeight),
                    ScaleMode.NO_BORDER);
*/

            // initialize and add the splash image to the screen
            this.setupSplashImage(viewPort);
            
            // instantiate Starling and set some config like showstats
            this._starling = new Starling(Amis, stage, viewPort);

            _useGestouch = args.gestouch;
			
			
            this._starling.stage3D.addEventListener(flash.events.Event.CONTEXT3D_CREATE, onStarlingStage3dContext3dCreate);            
                
            if(args.showStats) Starling.current.showStats = true;            
            _starling.enableErrorChecking = false;
            
            // setting up the debug stuff
            if(args.debug){                
                this._debug = new TextField();
                this._debug.width = screenWidth;
                this._debug.height = screenHeight;
                this._debug.multiline = true;
                this.addChild(this._debug);
                this.addDebug("");this.addDebug("");this.addDebug(""); // just for space ;)
            }
                
            // Sets native aplication events
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, this.onActivate);
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, this.onDeactivate);
			
//			this.addEventListener(flash.events.Event.ENTER_FRAME, this.myFunction);
		}
		
//		private function myFunction(e:flash.events.Event){
//			trace(stage.stageWidth);
//			trace(stage.stageHeight);
//		}
        
		private function onResizeFlashStage(e:flash.events.Event):void {
			updateStageSizes();
		}
		
        /**
        * 
        * On resizing of the stage
        * This method is responsable for dispatching the event for the views so it can get reorganized
        * 
        * @param starling.events.ResizeEvent
        * 
         */        
        private function onResizeStarlingStage(e:ResizeEvent):void {			
            updateStageSizes();            
        }
        
        /**
        * 
        * Update stage sizes and their static vars
        * 
        * @param Number width
        * @param Number height
        * 
         */
        private function updateStageSizes(width:Number=0, height:Number=0):void {
            Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.stageHeight);
            
            // set size to stage
            Starling.current.stage.stageWidth  = Amis.FULL_STAGE_WIDTH = Starling.current.nativeStage.fullScreenWidth / Assets.contentScaleFactor;
            Starling.current.stage.stageHeight = Amis.FULL_STAGE_HEIGHT = Starling.current.nativeStage.stageHeight / Assets.contentScaleFactor;            
            
			// calc the half stage width and height
            Amis.HALF_STAGE_WIDTH = Starling.current.stage.stageWidth * 0.5;
            Amis.HALF_STAGE_HEIGHT = Starling.current.stage.stageHeight * 0.5;                                      
        }
        
        /**
        * 
        * has created the context3d in stage3d
        * This method is responsable for calling Assets to preload assets
        * 
        * @param flash.events.Event 
        * 
         */
        private function onStarlingStage3dContext3dCreate(e:flash.events.Event):void {

            if(_useGestouch) {

                Gestouch.inputAdapter = new NativeInputAdapter(stage);
                Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
                Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
            }


            // load assets
            this._assets = new Assets();
            this._assets.addEventListener(AssetsEvent.ASSETS_LOADED, onAssetsLoaded);
            this._assets.load();
        }
        
        /**
        * 
        * Start starling and initialize stuff
        * 
        * @param flash.events.Event
        * 
         */
        private function onAssetsLoaded(e:flash.events.Event):void {        
            // clean memory for the event listener
            this._assets.removeEventListener(AssetsEvent.ASSETS_LOADED, onAssetsLoaded);
            
            // start starling
            this._starling.start();
            
            // Sets the events for the scenario where the user re orients the device
            // or in adobe air application when it get resized
            Starling.current.stage.addEventListener(starling.events.ResizeEvent.RESIZE, onResizeStarlingStage);
			stage.addEventListener(flash.events.Event.RESIZE, this.onResizeFlashStage);
            
            this.updateStageSizes();
            
            // start the amis (master) class
            this._amis = Amis.getInstance();               
            this._amis.load(this._screens, this._theme);
            
            // remove the splash image
            this.removeChild(this._splashImage);
        }        
        
        
        /**
        * 
        * Adds the same image as the splash untils the assets are all loaded 
        * 
         */
        private function setupSplashImage(viewPort:Rectangle):void {
            this._splashImage = new Sprite();
            this._splashImage.addChild( Assets.getSplashScreen(stage.fullScreenHeight) as Bitmap );
            
            this._splashImage.x = stage.fullScreenWidth * 0.5 - this._splashImage.width * 0.5;
            this._splashImage.y = stage.fullScreenHeight * 0.5 - this._splashImage.height * 0.5;
            
            this.addChild(this._splashImage);            
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