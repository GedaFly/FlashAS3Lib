﻿package com.gmrmarketing.holiday2013{	import com.gmrmarketing.holiday2013.ShapeMaskViewer;	import com.tastenkunst.as3.brf.simpleapps.*;	import com.tastenkunst.as3.brf.examples.*;	import com.tastenkunst.as3.brf.shapemasks.*;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.events.MouseEvent;		import flash.display.*;	import flash.events.*;		/**	 * @author Marcel Klammer, 2013	 */	public class ExampleDocumentClass extends MovieClip {				public var example : Sprite;				public function ExampleDocumentClass() 		{			if(stage == null) {				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			} else {				onAddedToStage();			}		}				public function onAddedToStage(e:Event = null) : void 		{			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			init();		}				public function init() : void 		{			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.quality = StageQuality.HIGH;			stage.frameRate = 36;						// This is the document class of the BRF_FLA_LAUNCHER.fla			// You can use that FLA to compile the examples, if you don't			// have FDT, Flash Builder, IntelliJ or FlashDevelop or 			// another code driven IDE.			//			// Choose ONE of the examples you want to compile.			//			// When you compile, please use						// !!! SHIFT + STRG + ENTER (instead of STRG + ENTER) to compile !!!						// and view the SWF file. Sometimes the Flash IDE needs to			// compile the SWF several times to view something, I'm not			// sure how to workaround that bug.			//			// You can also view the SWF by opening the bin/index.html file			// in your browser.			// 			// If you try one of the 2D examples the Flash IDE may ask you			// to specify a FLEX SDK PATH.			// You can download the latest FLEX SDK here:			// http://www.adobe.com/devnet/flex/flex-sdk-download.html			//			example = new ExampleImage2D();//			example = new ExampleImage3D();//			example = new ExampleWebcam2D();//			example = new ExampleWebcam3D();//			example = new ExampleWebcamFaceDetection();//			example = new ExampleWebcamFaceDetectionMultipleFaces();			//example = new ExampleWebcamFaceEstimation();//			example = new ExamplePointTracking();		//example = new ShapeMaskExporter();			example = new com.gmrmarketing.holiday2013.ShapeMaskViewer();//			example = new SimpleAppMasks();//			example = new SimpleAppPointTracking();//			example = new SimpleAppWebcam();			if (example != null) {				trace("add");				addChild(example);							}								}					}}