package com.pixelrevision.textureAtlas{
	
	import com.bit101.components.HScrollBar;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.VScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ScrollWindow extends Sprite{
		
		private var _content:Sprite;
		private var _mask:Sprite;
		
		private var _vScrollBar:VScrollBar;
		private var _hScrollBar:VScrollBar;
		
		private static const SCROLL_SPEED:Number = 10;
		
		public function ScrollWindow(w:Number, h:Number){
			super();
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, w, h);
			
			_vScrollBar = new VScrollBar(this, 0, 0, scrollVert);
			_hScrollBar = new VScrollBar(this, 0, 0, scrollHoiz);
			_hScrollBar.rotation = -90;
			
			_vScrollBar.height = h - _hScrollBar.width;
			_vScrollBar.x = w - _vScrollBar.width;
			
			_hScrollBar.height = w -_vScrollBar.width;
			_hScrollBar.y = h;
			
			_vScrollBar.visible = false;
			_hScrollBar.visible = false;
		}
		
		
		
		public function set content(cont:Sprite):void{
			_content = cont;
			_content.x = 0;
			_content.y = 0;
			
			addChild(_mask);
			addChildAt(_content, 0);
			_content.mask = _mask;
			
			checkLayout();
		}
		
		public function checkLayout():void{
			if(_content.width > _mask.width){
				_hScrollBar.visible = true;
			}else{
				_hScrollBar.visible = false;
			}
			if(_content.height > _mask.height){
				_vScrollBar.visible = true;
			}else{
				_vScrollBar.visible = false;
			}
			
			_vScrollBar.setThumbPercent(_mask.height/_content.height);
			_hScrollBar.setThumbPercent(_mask.width/_content.width);
			
			_vScrollBar.setSliderParams(0, -(_mask.height - _content.height)/SCROLL_SPEED, 0);
			_hScrollBar.setSliderParams(0, -(_mask.width - _content.width)/SCROLL_SPEED, 0);
		}
		
		
		private function scrollVert(e:Event):void{
			_content.y = -_vScrollBar.value * SCROLL_SPEED;
		}
		
		private function scrollHoiz(e:Event):void{
			_content.x = -_hScrollBar.value * SCROLL_SPEED;
		}
	}
	
}