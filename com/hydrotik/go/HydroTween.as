﻿/**
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	import org.goasap.GoEngine;
	import org.goasap.events.GoEvent;
	import org.goasap.interfaces.IPlayable;
	import org.goasap.items.LinearGo;
	import org.goasap.managers.LinearGoRepeater;
	import org.goasap.managers.OverlapMonitor;
	import org.goasap.utils.PlayableGroup;		
	public class HydroTween extends LinearGo implements IRenderable {
		
		private var _propsTo : Object;