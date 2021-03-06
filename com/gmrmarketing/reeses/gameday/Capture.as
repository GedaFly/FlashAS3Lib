package com.gmrmarketing.reeses.gameday
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.media.*;
	import flash.utils.Timer;
	
	public class Capture extends EventDispatcher
	{
		public static const COMPLETE:String = "captureComplete";
		public static const CANCEL:String = "captureCanceled";
		public static const VID_READY:String = "videoReadyFromStitcher";
		
		private var clip:MovieClip;
		private var myContainter:DisplayObjectContainer;
		private var receInterview:Interview2;
		
		private var vid:Video;
		private var vidConnection:NetConnection;
		private var vidStream:NetStream;		
		private var cam:Camera;
		private var mic:Microphone;		
		
		private var timeToRespond:Number; //time allowed for user response - set in nextQuestion()
		private var questionNumber:int;
		
		private var stitcher:Stitcher;
		private var tim:Timer;
		private var outputFileName:String;
		
		
		public function Capture()
		{
			vid = new Video();//users video
			vid.width = 640
			vid.height = 360;
			
			stitcher = new Stitcher();			
			
			tim = new Timer(1000, 0);
			
			clip = new mcCapture();
			
			//USER
			cam = Camera.getCamera();
			cam.setQuality(750000, 0);//bandwidth, quality
			cam.setMode(640, 360, 24, false);//width, height, fps, favorArea
			
			mic = Microphone.getMicrophone();
			mic.setSilenceLevel(0);			
			mic.rate = 44; //KHz
			
			vidConnection = new NetConnection();
			vidConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);	
			vidConnection.connect("rtmp://localhost/reesesGameday");
			
			clip.userVid.addChildAt(vid, 0);//container with white border, etc.
			vid.x = 20; 
			vid.y = 20;
			
			receInterview = new Interview2();
			receInterview.container = clip.receVid;
		}
		
		
		public function set container(c:DisplayObjectContainer):void
		{
			myContainter = c;
		}
		
		
		public function show():void
		{
			//trace("capture.show");
			if (!myContainter.contains(clip)) {
				myContainter.addChild(clip);
			}			
			
			clip.waitForRece.alpha = 0;
			clip.title.alpha = 0;
			clip.receVid.y = 1100;
			clip.userVid.y = 1100;
			clip.userVid.timer.alpha = 0;
			clip.userVid.sil.alpha = .69;
			
			TweenMax.to(clip.userVid.redDot, 0, { colorMatrixFilter: { saturation:0 }} );
			TweenMax.to(clip.receVid, .5, { y:256, ease:Back.easeOut } );
			TweenMax.to(clip.userVid, .5, { y:325, delay:.1, ease:Back.easeOut } );
			TweenMax.to(clip.title, .5, { alpha:1, delay:.4, onComplete:initCams } );
			
			clip.btnBack.addEventListener(MouseEvent.MOUSE_DOWN, cancelPressed, false, 0, true);
		}
		
		
		private function initCams():void
		{/*
			//USER
			cam = Camera.getCamera();
			cam.setQuality(750000, 0);//bandwidth, quality
			cam.setMode(640, 360, 24, false);//width, height, fps, favorArea
			
			mic = Microphone.getMicrophone();
			mic.setSilenceLevel(0);			
			mic.rate = 44; //KHz
			
			vidConnection = new NetConnection();
			vidConnection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);	
			vidConnection.connect("rtmp://localhost/reesesGameday");
			
			clip.userVid.addChildAt(vid, 0);
			vid.x = 20; 
			vid.y = 20;
				*/	
			
			//RECE
			//receInterview = new Interview2();
			//receInterview.container = clip.receVid;
			receInterview.show();
			receInterview.addEventListener(Interview2.INTRO_COMPLETE, startQuestions);
			receInterview.playIntro();
		}
		
		
		public function hide():void
		{
			//trace("capture.hide");
			clip.btnBack.removeEventListener(MouseEvent.MOUSE_DOWN, cancelPressed);
			
			//if(clip.userVid.contains(vid)){
				//clip.userVid.removeChild(vid);
			//}
			if (myContainter.contains(clip)) {
				myContainter.removeChild(clip);
			}
			/*
			//attach null to vidstream first
			if(vidStream){
				vidStream.attachAudio(null);
				vidStream.attachCamera(null);
				vidStream.close();
			}
			
			vid.attachCamera(null);
			cam = null;
			mic = null;
			vidStream = null;
			*/
			if(receInterview){
				receInterview.stop();
			}
		}
		
		
		public function stitchVideo(guid:String):void
		{
			outputFileName = guid + ".mp4";
			stitcher.addEventListener(Stitcher.COMPLETE, videoReady, false, 0, true);
			stitcher.questions2(receInterview.questions, outputFileName);
		}
		
		
		//called from Main.videoDoneProcessing()
		public function get fileName():String
		{
			return outputFileName;
		}
		
		
		private function videoReady(e:Event):void
		{
			stitcher.removeEventListener(Stitcher.COMPLETE, videoReady);
			dispatchEvent(new Event(VID_READY));
		}
		
		
		private function cancelPressed(e:MouseEvent):void
		{
			dispatchEvent(new Event(CANCEL));
		}
		
		
		//callback for vidConnection object
		private function statusHandler(e:NetStatusEvent):void
		{			
			//trace("Capture.statusHandler:", e.info.code);
			if (e.info.code == "NetConnection.Connect.Success")
			{		
				vidStream = new NetStream(vidConnection);
				vidStream.client = { onMetaData:metaDataHandler, onCuePoint:cuePointHandler };			
				
				vidStream.attachCamera(cam);
				vidStream.attachAudio(mic);	
				
				vid.attachCamera(cam);
			}
		}
		
		
		/**
		 * called once intro is done playing - fades in wait for rece text
		 * and then plays the first question
		 * @param	e
		 */
		private function startQuestions(e:Event):void
		{
			questionNumber = 0;
			
			//reset circle indicators
			clip.waitForRece.q1.gotoAndStop(1);
			clip.waitForRece.q2.gotoAndStop(1);
			clip.waitForRece.q3.gotoAndStop(1);
			clip.waitForRece.q4.gotoAndStop(1);
			//clip.waitForRece.q5.gotoAndStop(1);
			
			receInterview.removeEventListener(Interview2.INTRO_COMPLETE, startQuestions);			
			receInterview.addEventListener(Interview2.OUTRO_COMPLETE, interviewComplete, false, 0, true);			
			
			TweenMax.to(clip.waitForRece, 1, { alpha:1, onComplete:nextQuestion } );
		}
		
		
		/**
		 * Rece asks a question
		 */
		private function nextQuestion():void
		{
			questionNumber++;			
			TweenMax.to(clip.userVid.timer, .4, { alpha: 0 } );
			
			TweenMax.to(clip.receVid, .5, { y:256, ease:Back.easeOut } );
			TweenMax.to(clip.userVid, .5, { y:325, ease:Back.easeOut } );
			TweenMax.to(clip.userVid.sil, .4, { alpha:.69 } );
			TweenMax.to(clip.whiteArrow, .5, { scaleX:1, x:997 } );			
			TweenMax.to(clip.waitForRece, .5, { y:708, ease:Back.easeOut, onComplete:doNextQuestion } );
		}		
		
		
		private function doNextQuestion():void		
		{	
			//advance circle indicator
			//total of four questions
			if(questionNumber <= 4){
				clip.waitForRece["q" + questionNumber].gotoAndStop(2);
			}
			
			receInterview.addEventListener(Interview2.QUESTION_COMPLETE, recordUser);
			timeToRespond = receInterview.nextQuestion();
		}
		
		
		private function recordUser(e:Event):void
		{
			TweenMax.to(clip.receVid, .5, { y:325, ease:Back.easeOut } );
			TweenMax.to(clip.userVid, .5, { y:256, ease:Back.easeOut } );
			TweenMax.to(clip.userVid.sil, .4, { alpha:0 } );
			TweenMax.to(clip.whiteArrow, .5, { scaleX: -1, x:907 } );
			clip.userVid.timer.theTime.text = timeToRespond.toString();
			TweenMax.to(clip.userVid.timer, .4, { alpha:1 } );
			TweenMax.to(clip.waitForRece, .5, { y:777, ease:Back.easeOut, onComplete:doRecordUser } );
		}
		
		
		private function doRecordUser():void
		{
			//show red dot
			//clip.userVid.redDot.gotoAndStop(2);								
			//TweenMax.to(clip.userVid.redDot, .5, { colorMatrixFilter: { saturation:1 }} );
			TweenMax.to(clip.userVid.redDot, .5, {glowFilter:{color:0xff0000, strength:2, alpha:1, blurX:44, blurY:44}, yoyo:true, repeat:-1, colorMatrixFilter: { saturation:1 }});
			
			//vidStream.attachCamera(cam);
			//vidStream.attachAudio(mic);	
			vidStream.soundTransform.volume = .7;
			vidStream.publish("user" + questionNumber.toString(), "record"); //flv
			
			myContainter.stage.addEventListener(KeyboardEvent.KEY_DOWN, checkForStopRecording, false, 0, true);
			
			tim.addEventListener(TimerEvent.TIMER, updateTimer, false, 0, true);
			tim.start();
		}
		
		
		/**
		 * Looks for PageUp or PageDown KeyCode from remote and cancel recording
		 * @param	e
		 */
		private function checkForStopRecording(e:KeyboardEvent):void
		{
			if (e.keyCode == 33 || e.keyCode == 34) {
				clip.userVid.timer.theTime.text = "0";
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, updateTimer);
				stopRecording();
			}
		}
		
		
		private function updateTimer(e:TimerEvent):void
		{
			timeToRespond--;
			clip.userVid.timer.theTime.text = timeToRespond.toString();
			if (timeToRespond <= 0) {
				clip.userVid.timer.theTime.text = "0";
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, updateTimer);
				stopRecording();
			}			
		}
		
		
		private function stopRecording():void
		{
			myContainter.stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkForStopRecording);			
			
			TweenMax.to(clip.userVid.redDot, .5, {glowFilter:{color:0xff0000, strength:0, alpha:0, blurX:0, blurY:0}, yoyo:false, colorMatrixFilter: { saturation:0 }});			
			
			//vidStream.attachCamera(null);
			//vidStream.attachAudio(null);	
			vidStream.close();
			
			nextQuestion();
		}
		
		
		/**
		 * called once rece outro video is finished playing
		 * @param	e
		 */
		private function interviewComplete(e:Event):void
		{
			receInterview.removeEventListener(Interview2.OUTRO_COMPLETE, interviewComplete);			
			
			//close the connection to FMS - fixes problem with 10 connection max
			//vidConnection.close();
			
			dispatchEvent(new Event(COMPLETE));
		}
		
		
		private function metaDataHandler(infoObject:Object):void
		{}

		
		private function cuePointHandler(infoObject:Object):void
		{}
	}
	
}