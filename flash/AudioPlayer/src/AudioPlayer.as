/***************************************************************
 * Author      : Jack Zhang
 * Date        : 2014-10-15 下午5:10:30
 * Version     : 1.0
 * Copyright (c) 2013 the SEWISE inc. All rights reserved.
 ---------------------------------------------------------------
 * File        : AudioPlayer.as
 * Description : AudioPlayer.as
 ***************************************************************/

package
{
	import com.sewise.Music;
	import com.sewise.Params;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	public class AudioPlayer extends Sprite
	{
		private var music:Music;
		public function AudioPlayer()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			var params:Params = new Params(this.root.loaderInfo.parameters);
			music = new Music(params.soundURL, params.defVolume, params.autoStart);
			
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.CLICK, switchPlayHandler);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, seekPlayHandler);
		}
		private function switchPlayHandler(e:MouseEvent):void
		{
			if(music.isPlaying){
				music.pause();
			}else{
				music.play();
			}
			
		}
		private function seekPlayHandler(e:MouseEvent):void
		{
			music.seek(20);
		}
		
	}
}