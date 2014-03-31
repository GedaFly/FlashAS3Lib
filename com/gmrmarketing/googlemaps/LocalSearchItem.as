/** * Represents one item in the return of a Google maps local search */package com.gmrmarketing.googlemaps{		public class LocalSearchItem {			private var theTitle : String		private var titleNF : String		private var theUrl : String		private var lat : String		private var long : String				private var add : String		private var theCity : String		private var theRegion : String		private var theCountry : String		private var thePhoneNumbers : Array		private var drivingDirectionsUrl : String		private var drivingDirectionsUrlToHere : String		private var drivingDirectionsUrlFromHere : String		private var statMapURL : String		private var theListingType : String		private var theContent : String				public function LocalSearchItem() { }				public function get title():String 		{			return theTitle;		}		public function set title($theTitle:String):void 		{			theTitle = $theTitle;		}		public function get titleNoFormatting():String 		{			return titleNF;		}		public function set titleNoFormatting($titleNF:String):void 		{			titleNF = $titleNF;		}		public function get url():String 		{			return theUrl;		}		public function set url($theUrl:String):void 		{			theUrl = $theUrl;		}		public function get latitude():String 		{			return lat;		}		public function set latitude($lat:String):void		{			lat = $lat;		}		public function get longitude():String {			return long;		}		public function set longitude($long:String):void		{			long = $long;		}				public function get streetAddress():String		{			return add;		}		public function set streetAddress($add:String):void		{			add = $add;		}		public function get city():String		{			return theCity;		}		public function set city($theCity:String):void {			theCity = $theCity;		}		public function get region():String		{			return theRegion;		}		public function set region($theRegion:String):void		{			theRegion = $theRegion;		}		public function get country():String		{			return theCountry;		}		public function set country($theCountry:String):void		{			theCountry = $theCountry;		}				/**		 * returns an array of objects with type and number properties		 * type can be one of: "main", "fax", "mobile", "data", or ""		 */		public function get phoneNumbers():Array		{			return thePhoneNumbers;		}		public function set phoneNumbers($thePhoneNumbers:Array):void		{			thePhoneNumbers = $thePhoneNumbers;		}		public function get ddUrl():String		{			return drivingDirectionsUrl;		}		public function set ddUrl($drivingDirectionsUrl:String):void		{			drivingDirectionsUrl = $drivingDirectionsUrl;		}		public function get ddUrlToHere():String		{			return drivingDirectionsUrlToHere;		}		public function set ddUrlToHere($drivingDirectionsUrlToHere:String):void		{			drivingDirectionsUrlToHere = $drivingDirectionsUrlToHere;		}		public function get ddUrlFromHere():String		{			return drivingDirectionsUrlFromHere;		}		public function set ddUrlFromHere($drivingDirectionsUrlFromHere:String):void		{			drivingDirectionsUrlFromHere = $drivingDirectionsUrlFromHere;		}		public function get staticMapUrl():String		{			return statMapURL;		}		public function set staticMapUrl($statMapURL:String):void		{			statMapURL = $statMapURL;		}		public function get listingType():String		{			return theListingType;		}		public function set listingType($theListingType:String):void		{			theListingType = $theListingType;		}		public function get content():String		{			return theContent;		}		public function set content($theContent:String):void		{			theContent = $theContent;		}				public function toString():String		{			var delim:String = "\n";			var s:String = "Title: " + title + delim;			s += "Title no Formatting: " + titleNoFormatting + delim;			s += "URL: " + url + delim;			s += "Latitude: " + latitude + delim;			s += "Longitude: " + longitude + delim;			s += "Street Address: " + streetAddress + delim;			s += "City: " + city + delim + "Region: " + region + delim;			s += "Country: " + country + delim;						s += "Phone Numbers: " + delim;			var a:Array = phoneNumbers;			for (var i:int = 0; i < a.length; i++){				s += "   type: " + a[i].type + "   number: " + a[i].number + delim;			}						s += "Driving Directions URL: " + ddUrl + delim;			s += "Driving Directions to here: " + ddUrlToHere + delim;			s += "Driving directions from here: " + ddUrlFromHere + delim;			s += "Static map URL: " + staticMapUrl + delim;			s += "Listing type: " + listingType + delim;			s += "Content: " + content + delim;						s += "======================================================================" + delim + delim;						return s;		}	}}