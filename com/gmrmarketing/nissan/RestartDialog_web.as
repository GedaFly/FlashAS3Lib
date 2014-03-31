﻿package com.gmrmarketing.nissan
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class RestartDialog_web extends MovieClip
	{
		public static const OK_CLICK:String = "restartDialogOkClicked";
		public static const CANCEL_CLICK:String = "restartDialogCancelClicked";
		
		private var container:DisplayObjectContainer;
		
		
		
		
		public function RestartDialog_web($container:DisplayObjectContainer)
		{
			container = $container;			
			btnOK.addEventListener(MouseEvent.CLICK, ok, false, 0, true);
			btnCancel.addEventListener(MouseEvent.CLICK, cancel, false, 0, true);
			btnOK.buttonMode = true;
			btnCancel.buttonMode = true;
		}
		
		
		
		public function show(message:String = null, buttons:String = "okCancel"):void
		{			
			this.x = 521;
			this.y = 119;
			this.alpha = 0;
			if(message != null){
				this.theText.text = message;			
			}
			
			switch(buttons) {
				case "ok":
					btnOK.x = 221;
					btnOK.visible = true;
					btnCancel.visible = false;
					break;
				case "okCancel":
					btnOK.x = 176;
					btnOK.visible = true;
					btnCancel.visible = true;
					break;				
			}
			
			container.addChild(this);
			TweenMax.to(this, .5, { alpha:1 } );
		}
		
		
		
		public function hide():void
		{
			container.removeChild(this);
		}
		
		
		
		private function ok(e:MouseEvent):void
		{
			dispatchEvent(new Event(OK_CLICK));
			hide();
		}
		
		
		
		private function cancel(e:MouseEvent):void
		{
			dispatchEvent(new Event(CANCEL_CLICK));
			hide();
		}
		
	}
	
}