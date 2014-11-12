package com.sewise{
	import com.sewise.events.MusicEvent;
	
	import flash.errors.IOError;
	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class Music extends EventDispatcher
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var transforms:SoundTransform;
		private var soundPosition:int;
		
		public var isPlaying:Boolean = false;
		private var soundDuration:Number = 1;
		private var playTimer:Timer;
		
		private var autoStart:Boolean;
		private var soundURL:String
		private var defVolume:Number;
		public function Music($soundURL:String, $defVolume:Number, $autoStart:Boolean)
		{
			soundURL = $soundURL;
			defVolume = $defVolume;
			autoStart = $autoStart;
			/////////////////////////
			initialization();
		}
		private function initialization():void
		{
			var request:URLRequest;
			request = new URLRequest(soundURL);
			sound = new Sound();
			sound.addEventListener(Event.OPEN, loadOpenHandler);
			sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			sound.addEventListener(Event.COMPLETE, loadCompletedHandler);
			sound.addEventListener(Event.ID3, id3InfoHandler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			sound.load(request);
			if(autoStart)
			{
				play();
			}
			addCallBacks();
		}
		private function addCallBacks():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("doPlay", play);
				ExternalInterface.addCallback("doPause", pause);
				ExternalInterface.addCallback("doSeek", seek);
				ExternalInterface.addCallback("setVolume", setVolume);
				ExternalInterface.addCallback("duration", duration);
				ExternalInterface.addCallback("playTime", playTime);
				
				ExternalInterface.call("playerReady", ExternalInterface.objectID);
			}
		}
		private function loadOpenHandler(e:Event):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onLoadOpen", ExternalInterface.objectID);
			}
			
			//trace("load open.");
		}
		private function loadProgressHandler(e:ProgressEvent):void
		{
			if(ExternalInterface.available)
			{
				var loadPt:Number = e.bytesLoaded / e.bytesTotal;
				ExternalInterface.call("onLoadProgress", loadPt, ExternalInterface.objectID);
			}
			
			//trace("load progress.");
		}
		private function loadCompletedHandler(e:Event):void
		{
			soundDuration = sound.length;
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onLoadCompleted", ExternalInterface.objectID);
			}
			
			//trace("load completed.");
		}
		private function id3InfoHandler(e:Event):void
		{
			try{
				var info:ID3Info = e.target.id3;
				var metaData:Object = new Object();
				metaData.name = info.songName;
				metaData.artist = info.artist;
				
				if(ExternalInterface.available)
				{
					ExternalInterface.call("onMetadata", JSON.stringify(metaData), ExternalInterface.objectID);
				}
			}catch(e:Error){
				
			}
			//trace(name + " : " + artist);
		}
		private function loadErrorHandler(event:Event):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onLoadError", ExternalInterface.objectID);
			}
			
			//trace("ioErrorHandler");
		}
		private function playCompleteHandler(event:Event):void
		{
			soundPosition = 0;
			isPlaying = false;
			playTimer.reset();
			
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onPlayEnd", ExternalInterface.objectID);
			}
			//trace("sound play end!");
		}
		private function playTimeHandler(e:TimerEvent):void{
			if(ExternalInterface.available){
				ExternalInterface.call("onPlayTime", playTime(), ExternalInterface.objectID);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////
		public function play():void
		{
			if(isPlaying) return;
			if(!soundChannel){
				soundChannel = new SoundChannel();
				soundChannel = sound.play(0, 0, new SoundTransform(defVolume));
				soundChannel.addEventListener(Event.SOUND_COMPLETE, playCompleteHandler);
				
				playTimer = new Timer(100);
				playTimer.addEventListener(TimerEvent.TIMER, playTimeHandler);
				
				trace("init timer.");
			}else{
				soundChannel = sound.play(soundPosition, 0, new SoundTransform(defVolume));
				soundChannel.addEventListener(Event.SOUND_COMPLETE, playCompleteHandler);
			}
			isPlaying = true;
			
			playTimer.start();
			
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onStart", ExternalInterface.objectID);
			}
		}
		public function pause():void
		{
			if(!isPlaying) return;
			soundPosition = soundChannel.position;
			soundChannel.stop();
			isPlaying = false;
			
			playTimer.reset();
			
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onPause", ExternalInterface.objectID);
			}
		}
		public function seek(time:Number):void
		{
			soundPosition = time * 1000;
			if(isPlaying){
				soundChannel.stop();
				soundChannel = sound.play(soundPosition, 0, new SoundTransform(defVolume));
				soundChannel.addEventListener(Event.SOUND_COMPLETE, playCompleteHandler);
			}
			
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onSeek", soundPosition / 1000, ExternalInterface.objectID);
			}
		}
		public function setVolume(volume:Number):void
		{
			if(soundChannel){
				soundChannel.soundTransform = new SoundTransform(volume);
			}
			defVolume = volume;
		}
		public function duration():Number {
			return soundDuration / 1000;
		}
		public function playTime():Number {
			return soundChannel.position / 1000;
		}
		
		
	}
}