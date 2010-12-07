package com.pixelrevision.textureAtlas{
	
	import com.pixelrevision.textureAtlas.events.TextureAtlasEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	public class SWFFileLoader extends EventDispatcher{
		
		private static var _sharedInstance:SWFFileLoader;
		
		private var _fr:FileReference;
		private var _loader:Loader;
		private var _swf:MovieClip;
		
		
		public static function get sharedInstance():SWFFileLoader{
			if(!_sharedInstance) _sharedInstance = new SWFFileLoader();
			return _sharedInstance;
		}
		
		public function SWFFileLoader(){
			if(_sharedInstance){
				throw new Error("SWFFileLoader is a singleton.  Please use sharedInstance.");
			}
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, clipLoaded);
		}
		
		public function loadData():void{
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, onSelected);
			var arr:Array = [];
			arr.push(new FileFilter("SWF Files", "*.swf"));
			_fr.browse(arr);
		}
		
		private function onSelected(evt:Event):void{
			_fr.addEventListener(Event.COMPLETE, onLoaded);
			_fr.removeEventListener(Event.SELECT, onSelected);
			_fr.load();
		}
		
		private function onLoaded(evt:Event):void{
			_fr.removeEventListener(Event.COMPLETE, onLoaded);
			processData();
		}
		
		private function processData():void{
			_loader.loadBytes(_fr.data);
		}
		
		private function clipLoaded(e:Event):void{
			_swf = MovieClip(_loader.content);
			_swf.gotoAndStop(1);
			for(var i:uint=0; i<_swf.numChildren; i++){
				MovieClip(_swf.getChildAt(i)).gotoAndStop(1);
			}
			this.dispatchEvent(new TextureAtlasEvent(TextureAtlasEvent.SWF_LOADED) );
		}
		
		public function get swf():MovieClip{
			return _swf;
		}
		
	}
}