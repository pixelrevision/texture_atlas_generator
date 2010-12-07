
package com.pixelrevision.textureAtlas{
	
	import com.pixelrevision.textureAtlas.events.TextureAtlasEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="0xEEEEEE", frameRate="60", width="800", height="600")]
	public class TextureAtlas extends Sprite{
		
		public var menu:TextureAtlasMenu;
		public var textureLayout:TextureLayout;
		public var scrollWindow:ScrollWindow;
		private var _swfLoader:SWFFileLoader;
		private var _settings:Settings;
		
		public function TextureAtlas(){
			super();
			setup();
		}
		
		private function setup():void{
			setupStage();
			
			_settings = Settings.sharedInstance;
		
			_swfLoader = SWFFileLoader.sharedInstance;
			_swfLoader.addEventListener(TextureAtlasEvent.SWF_LOADED, newSWFLoaded);
			
			
			menu = new TextureAtlasMenu();
			menu.saveSWFButton.addEventListener(MouseEvent.CLICK, saveFiles);
			addChild(menu);
			
			scrollWindow = new ScrollWindow(800, 600 - 40);
			scrollWindow.y = 40;
			addChild(scrollWindow);
			
			textureLayout = new TextureLayout();
			textureLayout.addEventListener(TextureAtlasEvent.CANVAS_SIZE_CHANGED, checkScroll)
			
		}
		
		private function checkScroll(e:TextureAtlasEvent):void{
			scrollWindow.checkLayout();
		}
		
		private function newSWFLoaded(e:Event):void{
			textureLayout.processSWF(_swfLoader.swf);
			scrollWindow.content = textureLayout;
		}
		
		private function saveFiles(e:MouseEvent):void{
			textureLayout.save();
		}
		
		private function setupStage():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
		}
	}
}