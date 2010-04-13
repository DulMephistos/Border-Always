/**********************************************************
Code by: Fábio Teles | pixel4@gmail.com | +55(21)9769-4520
Class BorderAlways

///// CONSTRUCTOR:
function(stageRef:Stage,stageInitialWidth:Number,stageInitialHeight:Number);

///// PUBLIC PROPERTIES:
width:Number [read-only];
height:Number [read-only];

///// PUBLIC METHODS:
addMC(mc:MovieClip,align:String,ease:Object=null,limits:Object,round:Boolean=false,coefWidth:Number=NaN,coefHeight:Number=NaN);
	ease{type:Func, time:Number};
		type = fl.transitions.easing;
		time = inMilliseconds;
	limits{left:Number, right:Number,. top:Number, bottom:Number};
	coefWidth = custom coeficient for position x;
	coefHeight = custom coeficient for position y;
-----------------------------------		
removeMC(mc:MovieClip);
**********************************************************/
package biz.pixel4.display{
	import com.gskinner.motion.GTween;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class BorderAlways{		
		private var stage:Stage;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		private var _round:Boolean;		
		private var _mcs:Array = new Array();
		private var _props:Array = new Array();
		
		private var dict:Dictionary = new Dictionary(false);
		
		public function BorderAlways(stageRef:Stage,sw:Number,sh:Number){
			stageWidth=sw;
			stageHeight=sh;
			stage = stageRef;
			stage.addEventListener(Event.RESIZE, rearrange);
		}
		public function addMC(mc:DisplayObject,align:String,ease:Object=null,lim:Object=null,round:Boolean=false,coefWidth:Number=1,coefHeight:Number=1):void{
			dict[mc] = {startX:mc.x, startY:mc.y};
//			mc.startX = mc.x;
//			mc.startY = mc.y;
			_round = round;
			_mcs.push(mc);
			_props.push({align:align,easing:ease,limits:lim,coefWidth:coefWidth,coefHeight:coefHeight});
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
		public function removeMC(mc:DisplayObject):void{
			for(var i:Number=0;i<_mcs.length;i++) {
				if(_mcs[i]==mc){
					_mcs.splice(i);
					_props.splice(i);
					dict[mc] = null;
				}
			}
		}
		private function rearrange(ev:Event):void{
			for(var i:Number=0;i<_mcs.length;i++){
				var m:DisplayObject = _mcs[i];
				var props:Object = _props[i];
				var nx:Number = new Number();
				var ny:Number = new Number();
				if(props.align.toUpperCase()=="N"){
					if(!isNaN(props.coefWidth)) nx = (stage.stageWidth-stageWidth)*props.coefWidth;
					if(!isNaN(props.coefHeight)) ny = (stage.stageHeight-stageHeight)*props.coefHeight;
				}else{
					switch (stage.align){
					case StageAlign.TOP:
						if(props.align.toUpperCase().indexOf("C")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = stage.stageHeight-stageHeight;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = (stage.stageWidth-stageWidth)/2;			
					break;	
					
					case StageAlign.BOTTOM:
						if(props.align.toUpperCase().indexOf("C")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = stageHeight-stage.stageHeight;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = (stage.stageWidth-stageWidth)/2;
					break;
					
					case StageAlign.LEFT:
						if(props.align.toUpperCase().indexOf("C")!=-1) nx = (stage.stageWidth-stageWidth)/2;
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = stage.stageWidth-stageWidth;
					break;
					
					case StageAlign.RIGHT:
						if(props.align.toUpperCase().indexOf("C")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = stageWidth-stage.stageWidth;
					break;
					
					case StageAlign.TOP_LEFT: 
						if(props.align.toUpperCase().indexOf("CW")!=-1) nx = (stage.stageWidth-stageWidth)/2;
						else if(props.align.toUpperCase().indexOf("CH")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						else if(props.align.toUpperCase().indexOf("C")!=-1) {nx = (stage.stageWidth-stageWidth)/2;ny = (stage.stageHeight-stageHeight)/2;break;}
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = stage.stageHeight-stageHeight;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = stage.stageWidth-stageWidth;
					break;
					
					
					case StageAlign.TOP_RIGHT:
						if(props.align.toUpperCase().indexOf("CW")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						else if(props.align.toUpperCase().indexOf("CH")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						else if(props.align.toUpperCase().indexOf("C")!=-1) {nx = (stageWidth-stage.stageWidth)/2;ny = (stage.stageHeight-stageHeight)/2;break;}
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = stage.stageHeight-stageHeight;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = stageWidth-stage.stageWidth;
					break;
					
					case StageAlign.BOTTOM_LEFT:
						if(props.align.toUpperCase().indexOf("CW")!=-1) nx = (stage.stageWidth-stageWidth)/2;
						else if(props.align.toUpperCase().indexOf("CH")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						else if(props.align.toUpperCase().indexOf("C")!=-1) {nx = (stage.stageWidth-stageWidth)/2;ny = (stageHeight-stage.stageHeight)/2;break;}
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = stageHeight-stage.stageHeight;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = stage.stageWidth-stageWidth;
					break;
					
					case StageAlign.BOTTOM_RIGHT:
						if(props.align.toUpperCase().indexOf("CW")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						else if(props.align.toUpperCase().indexOf("CH")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						else if(props.align.toUpperCase().indexOf("C")!=-1) {nx = (stageWidth-stage.stageWidth)/2;ny = (stageHeight-stage.stageHeight)/2;break;}
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = stageHeight-stage.stageHeight;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = stageWidth-stage.stageWidth;
					break;
					
					default:						
						if(props.align.toUpperCase().indexOf("T")!=-1) ny = (stageHeight-stage.stageHeight)/2;
						if(props.align.toUpperCase().indexOf("B")!=-1) ny = (stage.stageHeight-stageHeight)/2;
						if(props.align.toUpperCase().indexOf("L")!=-1) nx = (stageWidth-stage.stageWidth)/2;
						if(props.align.toUpperCase().indexOf("R")!=-1) nx = (stage.stageWidth-stageWidth)/2;
					break;
					}		
				}				
				if(!isNaN(nx)){
					nx += dict[m].startX;
					if(props.limits){
						if(nx<props.limits.left) nx = props.limits.left;
						if(nx>props.limits.right) nx = props.limits.right;
					}
					if(_round) nx = Math.round(nx);
					if(props.easing) new GTween(m, props.easing.time/1000, {x:nx, ease:props.easing.type});
					else m.x = nx;
				}
				if(!isNaN(ny)){
					ny += dict[m].startY;
					if(props.limits){
						if(ny<props.limits.top) ny = props.limits.top;
						if(ny>props.limits.bottom) ny = props.limits.bottom;
					}					
					if(_round) ny = Math.round(ny);
					if(props.easing) new GTween(m, props.easing.time/1000, {y:ny, ease:props.easing.type});
					else m.y = ny;					
				}
			}
		}
		public function get width():Number{
			return stageWidth;
		}
		public function get height():Number{
			return stageHeight;
		}
	}
}