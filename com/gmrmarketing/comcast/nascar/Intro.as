package com.gmrmarketing.comcast.nascar
{
	import flash.display.*	
	import flash.events.*;
	import com.greensock.TweenMax;
	import com.gmrmarketing.utilities.Strings;
	
	
	public class Intro extends EventDispatcher
	{
		public static const RFID:String = "gotRFID";
		private var clip:MovieClip;
		private var container:DisplayObjectContainer;
		private var rfid:String = "dmenTest";
		
		
		public function Intro()
		{
			clip = new mcIntro();			
		}
		
		
		public function setContainer($container:DisplayObjectContainer):void
		{
			container = $container;
		}
		
		
		public function show():void
		{
			if (!container.contains(clip)) {
				container.addChild(clip);
			}
			clip.alpha = 0;
			clip.rfid.text = "";
			container.stage.focus = clip.rfid;
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN, checkRFID, false, 0, true);
			//clip.addEventListener(MouseEvent.MOUSE_DOWN, manual);
			TweenMax.to(clip, 1, { alpha:1 } );
		}
		
		
		private function checkRFID(e:KeyboardEvent):void
		{
			if (e.charCode == 13) {
				//got enter in field
				rfid = Strings.removeLineBreaks(clip.rfid.text);
				dispatchEvent(new Event(RFID));
			}
		}
		private function manual(e:MouseEvent):void
		{
			dispatchEvent(new Event(RFID));
		}
		
		public function getRFID():String
		{
			return rfid;
		}

		
		public function hide():void
		{
			container.stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkRFID);
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
		}		
		
	}	
	
}