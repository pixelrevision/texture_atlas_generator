package com.pixelrevision.textureAtlas.events{
	
	import flash.events.Event;
	
	public class TextureAtlasEvent extends Event{
		
		public static const SWF_LOADED:String = "swfLoaded";
		public static const CANVAS_SIZE_CHANGED:String = "canvasSizeChanged";
		
		
		public function TextureAtlasEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
		
		
	}
}