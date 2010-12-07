package com.pixelrevision.textureAtlas{
	
	import com.pixelrevision.textureAtlas.events.TextureAtlasEvent;
	
	import flash.events.EventDispatcher;
	
	public class Settings extends EventDispatcher{
		
		
		private static var _sharedInstance:Settings;
		
		private var _canvasWidth:Number = 1024;
		private var _canvasHeight:Number = 1024;
		private var _textureName:String = "sprite_sheet";
		
		public static function get sharedInstance():Settings{
			if(!_sharedInstance) _sharedInstance = new Settings();
			return _sharedInstance;
		}
		
		public function Settings(){
			
		}
		
		public function get textureName():String{
			return _textureName;
		}
		public function set textureName(value:String):void{
			_textureName = value;
		}
		
		
		public function get canvasWidth():Number{
			return _canvasWidth;
		}
		public function set canvasWidth(value:Number):void{
			_canvasWidth = value;
			dispatchEvent(new TextureAtlasEvent(TextureAtlasEvent.CANVAS_SIZE_CHANGED) );
		}
		
		public function get canvasHeight():Number{
			return _canvasHeight;
		}
		public function set canvasHeight(value:Number):void{
			_canvasHeight = value;
			dispatchEvent(new TextureAtlasEvent(TextureAtlasEvent.CANVAS_SIZE_CHANGED) );
		}
		
		
	}
}