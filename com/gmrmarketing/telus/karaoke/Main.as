package com.gmrmarketing.telus.karaoke
{
	import flash.display.MovieClip;
	import flash.events.*;
	import com.greensock.TweenMax;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.ui.Mouse;
	import com.gmrmarketing.telus.karaoke.Form;
	import com.gmrmarketing.utilities.CornerQuit;
	import flash.desktop.NativeApplication;
	
	public class Main extends MovieClip
	{
		private var intro:Intro;
		private var form:Form;
		private var privacy:Privacy;
		private var dialog:Dialog;
		private var video:Video;		
		private var thanks:Thanks;
		private var admin:Admin;
		private var queue:Queue;
		private var cq:CornerQuit;
		private var adminButton:CornerQuit;
		
		
		public function Main()
		{
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			Mouse.hide();

			intro = new Intro();
			intro.setContainer(this);
			
			form = new Form();
			form.setContainer(this);
			
			privacy = new Privacy();
			privacy.setContainer(this);
			
			video = new Video();
			video.setContainer(this);
			
			thanks = new Thanks();
			thanks.setContainer(this);
			
			dialog = new Dialog();
			dialog.setContainer(this);
			
			admin = new Admin();
			admin.setContainer(this);
			
			cq = new CornerQuit();
			cq.init(this, "ur");
			cq.addEventListener(CornerQuit.CORNER_QUIT, quitApplication, false, 0, true);
			
			adminButton = new CornerQuit();
			adminButton.init(this, "ul");
			adminButton.addEventListener(CornerQuit.CORNER_QUIT, showAdmin, false, 0, true);
			
			queue = new Queue();
			queue.addEventListener(Queue.DEBUG_MESSAGE, newDebugMessage, false, 0, true);
			
			init();
		}
		
		private function init():void
		{
			intro.show();
			adminMoveToTop();			
			intro.addEventListener(Intro.GET_STARTED, showForm, false, 0, true);
		}
		
		private function showForm(e:Event):void
		{			
			intro.removeEventListener(Intro.GET_STARTED, showForm);
			form.addEventListener(Form.SHOWING, removeIntro, false, 0, true);
			form.addEventListener(Form.SHOW_PRIVACY, showPrivacy, false, 0, true);
			form.addEventListener(Form.RESTART, doRestart, false, 0, true);
			form.addEventListener(Form.NO_PRIVACY, noPrivacy, false, 0, true);
			form.addEventListener(Form.BLANK_FIELDS, blankFields, false, 0, true);
			form.addEventListener(Form.BAD_EMAIL, badEmail, false, 0, true);
			form.addEventListener(Form.FORM_GOOD, formGood, false, 0, true);
			
			form.show();
			adminMoveToTop();
		}
		
		private function removeIntro(e:Event):void
		{			
			intro.hide();			
		}
		
		private function showPrivacy(e:Event):void
		{			
			privacy.addEventListener(Privacy.CLOSE_PRIVACY, hidePrivacy, false, 0, true);
			privacy.show();
			adminMoveToTop();
		}
		
		private function hidePrivacy(e:Event):void
		{			
			privacy.hide();
		}
		
		private function noPrivacy(e:Event):void
		{
			dialog.show("YOU MUST ACCEPT THE PRIVACY POLICY");
		}
		
		private function blankFields(e:Event):void
		{
			dialog.show("ALL FIELDS ARE REQUIRED");
		}
		
		private function badEmail(e:Event):void
		{
			dialog.show("INVALID EMAIL ADDRESS");
		}
		
		private function formGood(e:Event):void
		{
			form.removeEventListener(Form.SHOWING, removeIntro);
			form.removeEventListener(Form.SHOW_PRIVACY, showPrivacy);
			form.removeEventListener(Form.RESTART, doRestart);
			form.removeEventListener(Form.NO_PRIVACY, noPrivacy);
			form.removeEventListener(Form.BLANK_FIELDS, blankFields);
			form.removeEventListener(Form.BAD_EMAIL, badEmail);
			form.removeEventListener(Form.FORM_GOOD, formGood);			
			
			video.addEventListener(Video.VID_SHOWING, vidShowing, false, 0, true);
			video.addEventListener(Video.VID_RESET, doRestart, false, 0, true);
			video.addEventListener(Video.DONE_RECORDING, videoDone, false, 0, true);
			
			video.show(form.getData().guid);
			adminMoveToTop();
		}
		
		private function vidShowing(e:Event):void
		{
			form.hide();
		}
		
		private function videoDone(e:Event):void
		{
			video.removeEventListener(Video.VID_SHOWING, vidShowing);
			video.removeEventListener(Video.VID_RESET, doRestart);
			video.removeEventListener(Video.DONE_RECORDING, videoDone);
			
			thanks.addEventListener(Thanks.THANKS_SHOWING, killVideo, false, 0, true);
			thanks.addEventListener(Thanks.THANKS_DONE, doRestart, false, 0, true);
			thanks.show();
			adminMoveToTop();
			
			//send data and vid to bb
			queue.addToQueue(form.getData());
		}
		
		private function killVideo(e:Event):void
		{
			thanks.removeEventListener(Thanks.THANKS_SHOWING, killVideo);
			video.hide();
		}
		
		
		/**
		 * called by form, video, or thanks restart press
		 * @param	e
		 */
		private function doRestart(e:Event):void
		{
			form.removeEventListener(Form.SHOWING, removeIntro);
			form.removeEventListener(Form.SHOW_PRIVACY, showPrivacy);
			form.removeEventListener(Form.RESTART, doRestart);
			form.removeEventListener(Form.NO_PRIVACY, noPrivacy);
			form.removeEventListener(Form.BLANK_FIELDS, blankFields);
			form.removeEventListener(Form.BAD_EMAIL, badEmail);
			form.removeEventListener(Form.FORM_GOOD, formGood);
			
			video.removeEventListener(Video.VID_SHOWING, vidShowing);
			video.removeEventListener(Video.VID_RESET, doRestart);
			video.removeEventListener(Video.DONE_RECORDING, videoDone);
			
			thanks.removeEventListener(Thanks.THANKS_DONE, doRestart);
			
			form.hide();
			video.hide();
			thanks.hide();
			
			init();
		}
		
		
		private function newDebugMessage(e:Event):void
		{
			var mess:String = queue.getDebugMessage();
			trace(mess);
			if(admin.isShowing()){
				admin.displayDebug(mess);
			}
		}
		
		private function debug(mess:String):void
		{
			trace(mess);
			if(admin.isShowing()){
				admin.displayDebug(mess);
			}
		}
				
		
		private function quitApplication(e:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		
		private function showAdmin(e:Event):void
		{
			admin.show();
		}
		
		private function adminMoveToTop():void
		{
			cq.moveToTop();
			adminButton.moveToTop();
			if (admin.isShowing()) {
				admin.moveToTop();
			}
		}
	}
	
}