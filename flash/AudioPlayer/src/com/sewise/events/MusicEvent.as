package com.sewise.events{
	import flash.events.Event;
	public class MusicEvent extends Event {
		public static  const LOAD_OPEN:String = "loadOpen";
		public static  const LOAD_PROGRESS:String = "loadProgress";
		public static  const LOAD_COMPLETE:String = "loadComplete";
		public static  const LOAD_ERROR:String = "loadError";
		public static  const PLAY_COMPLETE:String = "playComplete";
		
		public var bytesLoaded:Number = -1;
		public var bytesTotal:Number = -1;
		
		public function MusicEvent(type:String, bytesLoaded:Number=-1, bytesTotal:Number=-1, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type,bubbles,cancelable);
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
		}
		public override function clone():Event{
			return new MusicEvent(type, bytesLoaded, bytesTotal, bubbles, cancelable);
		}
		
	}
}