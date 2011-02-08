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
			lua += generateSpriteSheetData(items);
			
			return lua;
		}
		
		private function generateClips(items:Array):String{
			var lastName:String = "";
			var lastFrame:String = "";
			var i:int;
			
			var lua:String = "function getInstanceByName(name)\n";
			lua += "\tsprite = require(\"sprite\")\n";
			lua += "\tspriteData = getSpriteSheetData(name)\n";
			lua += "\tspriteSheet = sprite.newSpriteSheetFromData(\"" + _settings.textureName + ".png\", spriteData)\n";
			/*
			for(i=0; i<items.length; i++){
				if(items[i].clipName != lastName){
					lua += "\tif(name==\"" + items[i].clipName  + "\"\n";
					lua += "\tend\n";
					lastName = items[i].clipName;
				}
			}
			*/
			lua += "\tinstance = sprite.newSprite(spriteSet)\n";
			lua += "\treturn instance\n";
			lua += "end\n";
			
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
				
				
				// data here
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