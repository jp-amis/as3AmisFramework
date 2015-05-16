package co.amis {
    import flash.display.Bitmap;
    import flash.events.EventDispatcher;
    import flash.filesystem.File;
    import flash.system.Capabilities;
    
    import co.amis.events.AssetsEvent;
    
    import starling.utils.AssetManager;
    import starling.utils.formatString;
    
    // TODO Support iPhone 6 screen size and @3x
    
    public class Assets extends flash.events.EventDispatcher {
        
        // Assets manager
        public static var manager:AssetManager;
        
        private var _appDir:File = File.applicationDirectory;
        
        // Splash stuff
        private static var _currentSplash:Bitmap = null;
        private static var _acceptedSplashes:Array = [480, 960, 1024, 1136, 2048];
        private static var _splashes:Array;
        
        // Scale factor
        private static var _contentScaleFactor:Number = 1;
        private static var _acceptedScaleFactors:Array = [1, 2, 3];
        private static var _normalizedScaleFactor:Number = 1;
        
        /**
        * 
        * Constructor
        * Initializes the Asset Manager
        * 
         */
        public function Assets() {
            
            manager = new AssetManager();
            manager.scaleFactor = normalizedScaleFactor;
            manager.verbose = Capabilities.isDebugger;
            manager.useMipMaps = false;			
                        
            super();
            
        }
        
        /**
        * 
        * Load all assets textures, fonts and audio from the
        * respective folders.
        * 
        * After loading everything dispatch a events defined as co.amis.events.AssetsEvent.ASSETS_LOADED
        * 
         */
        public function load():void {
            
            manager.enqueue(_appDir.resolvePath(formatString("textures/{0}x", normalizedScaleFactor)));
            manager.enqueue(_appDir.resolvePath(formatString("fonts/{0}x", normalizedScaleFactor)));
            manager.enqueue(_appDir.resolvePath("audio"));
            
            manager.loadQueue(function(ratio:Number):void {
                if (ratio == 1.0)
                {
                    dispatchEvent(new flash.events.Event(AssetsEvent.ASSETS_LOADED, true));
                }
            });
        }
        
        /**
        * 
        * Getter for normalizedScaleFactor
        * 
        * @return Number normalized scale factor
        * 
         */
        public static function get normalizedScaleFactor():Number { return _normalizedScaleFactor; }
        
        /**
        * 
        * Getter for contentScaleFactor
        * 
        * @return Number content scale factor
        * 
         */
        public static function get contentScaleFactor():Number { return _contentScaleFactor; }
        
        /**
        * 
        * Setter for content scale factor
        * It sets the content scale factor and calculate the normalized one
        * 
        * @param Number the content scale factor that you whant to use
        * 
         */
        public static function set contentScaleFactor(value:Number):void 
        {
            // sets the content scale factor
            _contentScaleFactor = value;
            
            // calculates the normalized scale factor based on your scale factor
            var currScaleFactor:Number = Math.abs(value - _acceptedScaleFactors[0]);
            
            for(var i:int = 0; i < _acceptedScaleFactors.length; i++){
                var abs:Number = Math.abs(value - _acceptedScaleFactors[i]);
                if(abs <= currScaleFactor)
                {
                    currScaleFactor = abs;
                    _normalizedScaleFactor = _acceptedScaleFactors[i];
                }
            }
            
        }
        
        /**
        * 
        * Getter for the current splash Bitmap
        * 
        * @return Bitmap current splash 
        * 
         */
        public static function get currentSplash():Bitmap { return _currentSplash; }
        
        /**
         * 
         * Getter for the splashes array
         * 
         * @return Array splashes array 
         * 
         */
        public static function get splashes():Array { return _splashes; }
        
        /**
        * 
        * Setter for the splashes array
        * 
        * @param Array splashes array 
        * 
         */
        public static function set splashes(value:Array):void { _splashes = value; }
        
        /**
        * 
        * Get the Splash image given the height and returns the bitmap
        * if the image is not found it will return the greatest one
        * 
        * @param Number height of the screen
        * 
        * @return Bitmap the bitmap for the splash
        * 
         */
        public static function getSplashScreen (h:Number):Bitmap {
            for(var i:int = 0; i < _acceptedSplashes.length; i++){
                
                if(h <= _acceptedSplashes[i])
                {
                    _currentSplash = new _splashes[i]();
                    return _currentSplash;
                }
            }
            
            return new _splashes[_acceptedSplashes.length-1]();
        }
    }
    
}

