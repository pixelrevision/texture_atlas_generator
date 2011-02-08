package com.pixelrevision.textureAtlas{
	
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.pixelrevision.textureAtlas.events.TextureAtlasEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	public class TextureAtlasMenu extends Sprite{
		
		private var _swfLoader:SWFFileLoader;
		private var _settings:Settings;
		private var _xPos:Number = 0;
		private static const PADDING:Number = 5;
		private static const TEXT_FIELD_POS_Y:Number = 2;
		
		public var loadSWFButton:PushButton;
		public var saveSWFButton:Sprite;
		public var textureTitleInput:InputText;
		public var nameLabel:Label;
		public var wLabel:Label;
		public var wInput:InputText;
		public var hLabel:Label;
		public var hInput:InputText;
		
		public function TextureAtlasMenu(){
			super();
			
			_swfLoader = SWFFileLoader.sharedInstance;
			_swfLoader.addEventListener(TextureAtlasEvent.SWF_LOADED, activateSave)
			_settings = Settings.sharedInstance;
			
			loadSWFButton = new PushButton(this, 0, PADDING, "Load SWF", loadSWF);
			nameLabel = new Label(this, 0, PADDING + TEXT_FIELD_POS_Y, "name:");
			textureTitleInput = new InputText(this, 0, PADDING + TEXT_FIELD_POS_Y, _settings.textureName, textChange);
			wLabel = new Label(this, 0, PADDING + TEXT_FIELD_POS_Y, "width:");
			wInput = new InputText(this, 0, PADDING + TEXT_FIELD_POS_Y, _settings.canvasWidth.toString(), sizeChange);
			wInput.width = 50;
			hLabel = new Label(this, 0, PADDING + TEXT_FIELD_POS_Y, "height:");
			hInput = new InputText(this, 0, PADDING + TEXT_FIELD_POS_Y, _settings.canvasHeight.toString(), sizeChange);
			hInput.width = 50;
			
			saveSWFButton = new PushButton(this, 0, PADDING, "Save");
			saveSWFButton.visible = false;
			layout();
			
			// _settings.addEventListener(TextureAtlasEvent.CANVAS_SIZE_CHANGED, canvasChanged);
		}
		
		private function canvasChanged(e:TextureAtlasEvent):void{
			wInput.text = _settings.canvasWidth.toString();
			hInput.text = _settings.canvasHeight.toString();
		}
		
		public function activateSave(e:TextureAtlasEvent):void{
			saveSWFButton.visible = true;
			layout();
		}
		
		public function layout():void{
			var xPos:Number = 0;
			for(var i:uint=0; i<numChildren; i++){
				var item:DisplayObject = getChildAt(i);
				if(item.visible){
					item.x = xPos;
					xPos += item.width + PADDING;
				}
			}
		}
		
		private function sizeChange(e:Event):void{
			_settings.canvasWidth = Number(wInput.text);
			_settings.canvasHeight = Number(hInput.text);
		}
		
		private function loadSWF(e:MouseEvent):void{
			_swfLoader.loadData();
		}
		
		
		private function textChange(e:Event):void{
			if(textureTitleInput.text != ""){
				_settings.textureName = textureTitleInput.text;
			}
		}
		
		
	}
}