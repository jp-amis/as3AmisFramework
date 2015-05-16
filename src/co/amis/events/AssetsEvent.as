package co.amis.events {
    import starling.errors.AbstractClassError;

    public class AssetsEvent {
        
        public static const ASSETS_LOADED:String = 'assets_loaded';
        
        
        public function AssetsEvent() { throw new AbstractClassError(); }        
    }
}