package oSound
{
	import flash.media.Sound;
	
	public class SoundObject
	{
		public var paused:Boolean = false;
		public var position:Number = 0;
		public var sound:Sound;
		
		public function SoundObject(sound:Sound)
		{
			this.sound = sound;
		}
	}
}