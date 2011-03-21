package com.pixelrevision.textureAtlas{
	
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import com.pixelrevision.textureAtlas.events.TextureAtlasEvent;
	
	import deng.fzip.FZip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class TextureLayout extends Sprite{
		
		private var _settings:Settings;
		private var _currentLab:String = "";
		private var _items:Array = [];
		
		public function TextureLayout(){
			super();
			_settings = Settings.sharedInstance;
			_settings.addEventListener(TextureAtlasEvent.CANVAS_SIZE_CHANGED, drawBounds);
			drawBounds(null);
		}
		
		public function layoutChildren():void{
			var xPos:Number = 0;
			var yPos:Number = 0;
			var maxY:Number = 0;
			for(var i:uint=0; i<_items.length; i++){
				if( (xPos + _items[i].width) > _settings.canvasWidth){
					xPos = 0;
					yPos += maxY;
					maxY = 0;
				}
				if(_items[i].height + 1 > maxY){
					maxY = _items[i].height + 1;
				}
				_items[i].x = xPos;
				_items[i].y = yPos;
				xPos += _items[i].width + 1;
			}
		}
		
		private function drawBounds(e:TextureAtlasEvent):void{
			graphics.clear();
			graphics.lineStyle(1, 0x000000);
			graphics.drawRect(0, 0, _settings.canvasWidth-1, _settings.canvasHeight-1);
			layoutChildren();
			dispatchEvent(new TextureAtlasEvent(TextureAtlasEvent.CANVAS_SIZE_CHANGED) );
		}
		
		public function get withinBounds():Boolean{
			trace(this.width, _settings.canvasWidth, this.height, _settings.canvasHeight);
			return (this.width <= _settings.canvasWidth && this.height <= _settings.canvasHeight);
		}
		
		public function addItem(item:TextureItem):void{
			_items.push(item);
			addChild(item);
		}
		
		public function clear():void{
			for(var i:uint=0; i<_items.length; i++){
				removeChild(_items[i]);
			}
			_currentLab = "";
			_items = [];
		}
		
		public function processSWF(swf:MovieClip):void{
			clear();
			var parseFrame:Boolean = false;
			var selected:MovieClip;
			var itemW:Number;
			var itemH:Number;
			var bounds:Rectangle;
			
			for(var i:uint=0; i<swf.numChildren; i++){
				selected = MovieClip( swf.getChildAt(i) );
				
				// check for frames
				if(selected.totalFrames > 1){
					for(var m:uint=0; m<selected.totalFrames; m++){
						selected.gotoAndStop(m+1);
						drawItem(selected, selected.name + "_" + appendIntToString(m, 5), selected.name);
					}
				}else{
					drawItem(selected, selected.name, selected.name);
				}
			}
			layoutChildren();
		}
		
		private function appendIntToString(num:int, numOfPlaces:int):String{
			var numString:String = num.toString();
			var outString:String = "";
			for(var i:int=0; i<numOfPlaces - numString.length; i++){
				outString += "0";
			}
			return outString + numString;
		}
		
		private function drawItem(clip:MovieClip, name:String = "", baseName:String =""):TextureItem{
			var label:String = "";
			var bounds:Rectangle = clip.getBounds(clip);
			var itemW:Number = Math.ceil(bounds.x + bounds.width);
			var itemH:Number = Math.ceil(bounds.y + bounds.height);
			var bmd:BitmapData = new BitmapData(itemW, itemH, true, 0x00000000);
			bmd.draw(clip);
			if(clip.currentLabel != _currentLab && clip.currentLabel != null){
				_currentLab = clip.currentLabel;
				label = _currentLab;
			}
			var item:TextureItem = new TextureItem(bmd, name, label, baseName);
			addItem(item);
			return item;
		}
		
		public function save():void{
			graphics.clear();
			// prepare files
			var bmd:BitmapData = new BitmapData(_settings.canvasWidth, _settings.canvasHeight, true, 0x000000);
			var json:Object = new Object();
			json.textures = [];
			json.imagePath = _settings.textureName  + ".png";
			
			var xml:XML = new XML(<TextureAtlas></TextureAtlas>);
			xml.@imagePath = _settings.textureName  + ".png";
			
		
			for(var i:uint=0; i<_items.length; i++){
				var matrix:Matrix = new Matrix();
				matrix.tx = _items[i].x;
				matrix.ty = _items[i].y;
				bmd.draw(_items[i], matrix);
				// xml
				var subText:XML = new XML(<SubTexture />); 
				subText.@x = _items[i].x;
				subText.@y = _items[i].y;
				subText.@width = _items[i].width;
				subText.@height = _items[i].height;
				subText.@name = _items[i].textureName;
				if(_items[i].frameName != "") subText.@frameLabel = _items[i].frameName;
				xml.appendChild(subText);
				
				// json
				var textureData:Object = new Object();
				textureData.x = _items[i].x;
				textureData.y = _items[i].y;
				textureData.width = _items[i].width;
				textureData.height = _items[i].height;
				textureData.name = _items[i].textureName;
				if(_items[i].frameName != "") textureData.frameLabel = _items[i].frameName;
				json.textures.push(textureData);
			}
			
			var luaGenerator:LUAGenerator = new LUAGenerator();
			var lua:String = luaGenerator.generate(_items);
			// trace(lua);
			
			// now setup zip
			var img:ByteArray = PNGEncoder.encode(bmd);
			var xmlString:String = xml.toString();
			var jsonString:String = JSON.encode(json);
			var zip:FZip = new FZip();
			zip.addFile(_settings.textureName + ".png", img);
			zip.addFileFromString(_settings.textureName + ".xml", xmlString);
			zip.addFileFromString(_settings.textureName + ".json", jsonString);
			zip.addFileFromString(_settings.textureName + ".lua", lua);
			
			// save
			var zipArray:ByteArray = new ByteArray();
			zip.serialize(zipArray, true);
			var fr:FileReference = new FileReference();
			fr.save(zipArray, _settings.textureName + ".zip");
			
			
			
			drawBounds(null);
		}
		
		
	}
}