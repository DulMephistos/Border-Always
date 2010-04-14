/**********************************************************
   Code by: pixel4 | hello@pixel4.biz | Fabio Teles 
   Class BorderAlways

   Released under MIT License
 **********************************************************/
package biz.pixel4.display {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class BorderAlways {
		/** Specifies that the target should be aligned always at the bottom */
		public static const BOTTOM:String = "B";
		/** Specifies that the target should be aligned always at the bottom and the left */
		public static const BOTTOM_LEFT:String = "BL";
		/** Specifies that the target should be aligned always at the bottom and the right*/
		public static const BOTTOM_RIGHT:String = "BR";
		/** Specifies that the target should be aligned always at the left */
		public static const LEFT:String = "L";
		/** Specifies that the target should be aligned always at the right */
		public static const RIGHT:String = "R";
		/** Specifies that the target should be aligned always at the top */
		public static const TOP:String = "T";
		/** Specifies that the target should be aligned always at the top and the left */
		public static const TOP_LEFT:String = "TL";
		/** Specifies that the target should be aligned always at the top and the right */
		public static const TOP_RIGHT:String = "TR";
		/** Specifies that the target should be aligned always at the center */
		public static const CENTER:String = "C";
		/** Specifies that the target should be aligned always at the center by height only */
		public static const CENTER_WIDTH:String = "CW";
		/** Specifies that the target should be aligned always at the center by width only */
		public static const CENTER_HEIGHT:String = "CH";
		/** Specifies that the target should be aligned always according to the coeficients passeds */
		public static const CUSTOM:String = "N";
		
		/** @private */
		private var stage:Stage;
		/** @private */
		private var stageWidth:Number;
		/** @private */
		private var stageHeight:Number;
		
		/** @private */
		private var round:Boolean;
		/** @private */
		private var mcs:Array;
		/** @private */
		private var props:Array;
		/** @private */
		private var dict:Dictionary = new Dictionary(false);
		
		public function get width():Number {
			return stageWidth;
		}
		
		public function get height():Number {
			return stageHeight;
		}
		
		public function get roundValues():Boolean {
			return round;
		}
		
		public function set roundValues(value:Boolean):void {
			round = value;
		}
		
		/**
		 * CONSTRUCTOS
		 * @param stageRef A reference to the Stage object
		 * @param sw The initial stage width configured in export settings
		 * @param sh The initial stage height configured in export settings
		 */
		public function BorderAlways(stageRef:Stage, sw:Number, sh:Number) {
			mcs = new Array();
			props = new Array();
			round = false;
			
			stageWidth = sw;
			stageHeight = sh;
			stage = stageRef;
			stage.addEventListener(Event.RESIZE, handleResize);
		}
		
		/**
		 * Adds a DisplayObject that must obey the alignment informed while the stage is resized.
		 * @param target The DisplayObject to be aligned.
		 * @param align The string that specifies of type of alignment to be used. BorderAlways constants.
		 * @param limits An optional BorderAlwaysLimits object to limit the bounds of values that will be set.
		 * @param coefX A Coeficient for axis X that should be passed when the align is CUSTOM. 
		 * @param coefY A Coeficient for axis Y that should be passed when the align is CUSTOM.
		 */
		public function add(target:DisplayObject, align:String, limits:BorderAlwaysLimits=null, coefX:Number=1, coefY:Number=1):void {
			dict[target] = {"startX":target.x, "startY":target.y, "i":mcs.length};
			round = round;
			mcs.push(target);
			props.push({"align":align, "limits":limits, "coefX":coefX, "coefY":coefY});
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Removes the rules of alignments that have been set for the DisplayObject and set the initial properties of X and Y. 
		 * @param target The display Object to remove from alingment.
		 */
		public function remove(target:DisplayObject):void {
			if (dict[target] != null) {
				target.x = dict[target].startX;
				target.y = dict[target].startY;
				mcs.splice(dict[target]["i"]);
				props.splice(dict[target]["i"]);
				dict[target] = null;
			}
		}
		
		/** @private */
		private function handleResize(ev:Event):void {
			var m:DisplayObject;
			var p:Object;
			var v:Point;
			for (var i:Number = 0; i < mcs.length; i++) {
				m = mcs[i];
				p = props[i];
				v = getTargetRatio(p);
				
				if (!isNaN(v.x)) {
					v.x += dict[m].startX;
					if (p.limits) {
						if (v.x < p.limits.left)
							v.x = p.limits.left;
						if (v.x > p.limits.right)
							v.x = p.limits.right;
					}
					if (round)
						v.x = Math.round(v.x);
					m.x = v.x;
				}
				if (!isNaN(v.y)) {
					v.y += dict[m].startY;
					if (p.limits) {
						if (v.y < p.limits.top)
							v.y = p.limits.top;
						if (v.y > p.limits.bottom)
							v.y = p.limits.bottom;
					}
					if (round)
						v.y = Math.round(v.y);
					m.y = v.y;
				}
			}
		}
		
		/** @private */
		private function getTargetRatio(p:Object):Point {
			var point:Point = new Point(NaN, NaN);
			if (p.align == CUSTOM) {
				if (!isNaN(p.coefX))
					point.x = (stage.stageWidth - stageWidth) * p.coefX;
				if (!isNaN(p.coefY))
					point.y = (stage.stageHeight - stageHeight) * p.coefY;
			} else {
				switch (stage.align) {
					case StageAlign.TOP:
						if (p.align == CENTER)
							point.y = (stage.stageHeight - stageHeight) / 2;
						else if (p.align.indexOf("B") != -1)
							point.y = stage.stageHeight - stageHeight;
						if (p.align.indexOf("L") != -1)
							point.x = (stageWidth - stage.stageWidth) / 2;
						else if (p.align.indexOf("R") != -1)
							point.x = (stage.stageWidth - stageWidth) / 2;
						break;
					
					case StageAlign.BOTTOM:
						if (p.align == CENTER)
							point.y = (stageHeight - stage.stageHeight) / 2;
						if (p.align.indexOf("T") != -1)
							point.y = stageHeight - stage.stageHeight;
						if (p.align.indexOf("L") != -1)
							point.x = (stageWidth - stage.stageWidth) / 2;
						if (p.align.indexOf("R") != -1)
							point.x = (stage.stageWidth - stageWidth) / 2;
						break;
					
					case StageAlign.LEFT:
						if (p.align == CENTER)
							point.x = (stage.stageWidth - stageWidth) / 2;
						if (p.align.indexOf("T") != -1)
							point.y = (stageHeight - stage.stageHeight) / 2;
						if (p.align.indexOf("B") != -1)
							point.y = (stage.stageHeight - stageHeight) / 2;
						if (p.align.indexOf("R") != -1)
							point.x = stage.stageWidth - stageWidth;
						break;
					
					case StageAlign.RIGHT:
						if (p.align == CENTER)
							point.x = (stageWidth - stage.stageWidth) / 2;
						if (p.align.indexOf("T") != -1)
							point.y = (stageHeight - stage.stageHeight) / 2;
						if (p.align.indexOf("B") != -1)
							point.y = (stage.stageHeight - stageHeight) / 2;
						if (p.align.indexOf("L") != -1)
							point.x = stageWidth - stage.stageWidth;
						break;
					
					case StageAlign.TOP_LEFT:
						if (p.align == CENTER_WIDTH)
							point.x = (stage.stageWidth - stageWidth) / 2;
						else if (p.align == CENTER_HEIGHT)
							point.y = (stage.stageHeight - stageHeight) / 2;
						else if (p.align == CENTER) {
							point.x = (stage.stageWidth - stageWidth) / 2;
							point.y = (stage.stageHeight - stageHeight) / 2;
							break;
						}
						if (p.align.indexOf("B") != -1)
							point.y = stage.stageHeight - stageHeight;
						if (p.align.indexOf("R") != -1)
							point.x = stage.stageWidth - stageWidth;
						break;
					
					
					case StageAlign.TOP_RIGHT:
						if (p.align == CENTER_WIDTH)
							point.x = (stageWidth - stage.stageWidth) / 2;
						else if (p.align == CENTER_HEIGHT)
							point.y = (stage.stageHeight - stageHeight) / 2;
						else if (p.align == CENTER) {
							point.x = (stageWidth - stage.stageWidth) / 2;
							point.y = (stage.stageHeight - stageHeight) / 2;
							break;
						}
						if (p.align.indexOf("B") != -1)
							point.y = stage.stageHeight - stageHeight;
						if (p.align.indexOf("L") != -1)
							point.x = stageWidth - stage.stageWidth;
						break;
					
					case StageAlign.BOTTOM_LEFT:
						if (p.align == CENTER_WIDTH)
							point.x = (stage.stageWidth - stageWidth) / 2;
						else if (p.align == CENTER_HEIGHT)
							point.y = (stageHeight - stage.stageHeight) / 2;
						else if (p.align == CENTER) {
							point.x = (stage.stageWidth - stageWidth) / 2;
							point.y = (stageHeight - stage.stageHeight) / 2;
							break;
						}
						if (p.align.indexOf("T") != -1)
							point.y = stageHeight - stage.stageHeight;
						if (p.align.indexOf("R") != -1)
							point.x = stage.stageWidth - stageWidth;
						break;
					
					case StageAlign.BOTTOM_RIGHT:
						if (p.align == CENTER_WIDTH)
							point.x = (stageWidth - stage.stageWidth) / 2;
						else if (p.align == CENTER_HEIGHT)
							point.y = (stageHeight - stage.stageHeight) / 2;
						else if (p.align == CENTER) {
							point.x = (stageWidth - stage.stageWidth) / 2;
							point.y = (stageHeight - stage.stageHeight) / 2;
							break;
						}
						if (p.align.indexOf("T") != -1)
							point.y = stageHeight - stage.stageHeight;
						if (p.align.indexOf("L") != -1)
							point.x = stageWidth - stage.stageWidth;
						break;
					
					default:
						if (p.align.indexOf("T") != -1)
							point.y = (stageHeight - stage.stageHeight) / 2;
						else if (p.align.indexOf("B") != -1)
							point.y = (stage.stageHeight - stageHeight) / 2;
						if (p.align.indexOf("L") != -1)
							point.x = (stageWidth - stage.stageWidth) / 2;
						else if (p.align.indexOf("R") != -1)
							point.x = (stage.stageWidth - stageWidth) / 2;
						break;
				}
			}
			return point;
		}
	}
}