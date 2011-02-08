package com.pixelrevision.textureAtlas{
	
	import com.pixelrevision.textureAtlas.Settings;
	
	public class LUAGenerator{
		
		private var _settings:Settings;
		public function LUAGenerator(){
			_settings = Settings.sharedInstance;
		}
		
		public function generate(items:Array):String{
			var lua:String = "";
			lua += generateClips(items);
			lua += addFramesToSprites(items);
			lua += generateSpriteSheetData(items);
			return lua;
		}
		
		private function generateClips(items:Array):String{
			var i:int;
			var lua:String = "function getInstanceByName(name, fps)\n";
			lua += "\tsprite = require(\"sprite\")\n";
			lua += "\tspriteData = getSpriteSheetData(name)\n";
			lua += "\tspriteSheet = sprite.newSpriteSheetFromData(\"" + _settings.textureName + ".png\", spriteData)\n";
			lua += "\tspriteSet = registerSpriteSets(name, sprite, spriteSheet, fps)\n";
			lua += "\tinstance = sprite.newSprite(spriteSet)\n";
			lua += "\treturn instance\n";
			lua += "end\n";
			return lua;
		}
		
		private function addFramesToSprites(items:Array):String{
			var lastName:String = "";
			var lastFrame:String = "";
			var i:int;
			var startSpriteSetFrame:int;
			var startTaggedFrame:int;
			var lua:String = "function registerSpriteSets(name, sprite, spriteSheet, fps)\n";
			lua += "\tsecs = 1000/fps\n";
			var sprData:Object = {};
			lastName = "";
			lastFrame = "";
			var frameNumber:int = 1;
			var start:int = -1;
			var end:int;
			for(i=0; i<items.length; i++){
				if(items[i].clipName != lastName){
					if(start != -1){
						end = frameNumber - 1;
						sprData[lastName][lastFrame] = {};
						sprData[lastName][lastFrame].start = start;
						sprData[lastName][lastFrame].count = end - start + 1;
						trace("adding", lastName, lastFrame, end - start + 1);
					}
					sprData[items[i].clipName] = {};
					lastName = items[i].clipName;
					frameNumber = 1;
					start = -1;
					sprData[lastName] = {};
				}
				
				if(items[i].frameName != ""){
					if(start != -1){
						end = frameNumber - 1;
						sprData[lastName][lastFrame] = {};
						sprData[lastName][lastFrame].start = start;
						sprData[lastName][lastFrame].count = end - start + 1;
					}
					start = frameNumber;
					lastFrame = items[i].frameName;
					trace(lastFrame);
				}
				if(i+1 <items.length){
					if(items[i + 1].clipName != lastName){
						sprData[lastName]["end"] = frameNumber;
					}
				}else{
					sprData[lastName]["end"] = frameNumber;
				}
				
				frameNumber++;
			}
			var hasData:Boolean;
			for(var data:String in sprData){
				lua += "\tif(name == \"" + data + "\") then\n";
				lua += "\t\tspriteSet = sprite.newSpriteSet(spriteSheet, 1, " + sprData[data].end + ")\n";
				for(var frData:String in sprData[data]){
					if(frData != "end"){
						hasData = true;
						lua += "\t\tsprite.add(spriteSet, \"" + frData + "\", "+sprData[data][frData].start+", "+sprData[data][frData].count+", secs * "+sprData[data][frData].count+", 0)\n";
					}
				}
				if(!hasData){
					lua += "\t\tsprite.add(spriteSet, \"default\", 1, 1, 1, 0)\n";
				}
				lua += "\t\treturn spriteSet\n";
				lua += "\tend\n";
				hasData = false;
			}
			lua += "end\n";
			// trace(lua);
			return lua;
			
		}
		
		private function generateSpriteSheetData(items:Array):String{
			var i:int;
			
			var lua:String = "function getSpriteSheetData(name)\n\t";
			var lastName:String;
			
			for(i=0; i<items.length; i++){
				if(items[i].clipName != lastName){
					lua += openItem(items[i].clipName);
				}
				lastName = items[i].clipName;
				// add frames
				lua += "\t\t\t\t{name = \"" + items[i].textureName + "\",\n";
				lua += this.generateSizeNode(items[i]) + ",\n";
				lua += this.generateSpriteColorRect(items[i]) + ",\n";
				lua += "\t\t\t\tpriteTrimmed = true,\n";
				lua += "\t\t\t\ttextureRotated = false,\n";
				
				lua += "\t\t\t\tspriteSourceSize = {width=" + _settings.canvasWidth + ", height=" + _settings.canvasHeight+ "}}";
				if(i + 1 < items.length){
					if(items[i + 1].clipName != lastName){
						lua += "\n";
					}else{
						lua += ",\n";
					}
				}
				if(i + 1 < items.length){
					if(items[i + 1].clipName != lastName){
						lua += closeItem(items[i].clipName);
						if(i < items.length - 1){
							lua += "\telse";
						}
					}
				}else{
					lua += closeItem(items[i].clipName);
					lua += "\tend\n";
				}
			}
			
			lua += "\treturn sheet\n";
			lua += "end\n";
			return lua;
		}
		
		private function openItem(name:String):String{
			var node:String =  "if(name == \"" + name + "\") then\n";
			node += "\t\tsheet = {\n";
			node += "\t\t\tframes = {\n";
			return node;
		}
		private function closeItem(name:String):String{
			var node:String  = "\t\t\t}\n";
			node += "\t\t}\n";
			return node;
		}
		
		private function generateSizeNode(ti:TextureItem):String{
			var node:String = "\t\t\t\ttextureRect = {";
			node += "x=" + ti.x + ",";
			node += "y=" + ti.y + ",";
			node += "width=" + ti.width + ",";
			node += "height=" + ti.height;
			node += "}";
			return node;
		}
		private function generateSpriteColorRect(ti:TextureItem):String{
			var node:String = "\t\t\t\tspriteColorRect = {";
			node += "x=0,";
			node += "y=0,";
			node += "width=" + ti.width + ",";
			node += "height=" + ti.height;
			node += "}";
			return node;
		}
		
		
	}
}