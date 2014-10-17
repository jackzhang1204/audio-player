/***************************************************************
 * Author      : Jack Zhang
 * Date        : 2014-10-16 下午2:32:33
 * Version     : 1.0
 * Copyright (c) 2013 the SEWISE inc. All rights reserved.
 ---------------------------------------------------------------
 * File        : ParamsParser.as
 * Description : ParamsParser.as
 ***************************************************************/

package com.sewise
{
	public class Params
	{
		public var soundURL:String = "../../bak/test.mp3";
		public var defVolume:Number = 0.6;
		public var autoStart:Boolean = true;
		
		public function Params(params:Object)
		{
			if(!params["videoUrl"]) return;
			
			parseVideoUrl(params["videoUrl"]);
			parseVolume(params["volume"]);
			parseAutoStart(params["autoStart"]);
		}
		
		/*public function parseParams(params:Object):void
		{
			
		}*/
		
		private function parseVideoUrl(url:String):void
		{
			if(url) soundURL = url;
		}
		private function parseVolume(volume:Number):void
		{
			if(volume >= 0) defVolume = volume;
		}
		private function parseAutoStart(auto:String):void
		{
			if(auto != "true") autoStart = false;
		}
		
		
	}
}