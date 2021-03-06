package component.basic;
import core.animation.Animation;
import core.animation.AnimationManager;
import core.focus.FocusManager;
import js.html.CanvasElement;
import tweenxcore.expr.ComplexEasingKind;
import tweenxcore.expr.ComplexEasingKindTools;
import tweenxcore.structure.FloatChange;
import tweenxcore.structure.FloatChangePart;

class PreviewAnimation implements Animation
{
    public static var WIDTH = 600;
    public static var HEIGHT = 5;
    public static var MARKER_WIDTH = 30;
    public static var MARGIN = 80;
    public static var TOTAL_TIME = 1000;
    
    private var canvas:CanvasElement;
    private var currentTime:Float;
    private var totalTime:Float;
    private var func:Float->Float;
    private var manager:AnimationManager;
    
    public function new(manager:AnimationManager, canvas:CanvasElement, easing:ComplexEasingKind) 
    {
        this.manager = manager;
        this.func = ComplexEasingKindTools.toFunction(easing);
        this.canvas = canvas;
        totalTime = TOTAL_TIME * manager.time;
        currentTime = 0;
    }
    
    public function onFrame(time:Float):Void
    {
        var change = new FloatChange(currentTime, currentTime += time);
        change.handlePart(0, totalTime, updatePart);
    }
    
    private function updatePart(part:FloatChangePart):Void
    {
        init(canvas);
        
        var ctx = canvas.getContext2d();
        
        var left = MARGIN;
        var right = WIDTH - MARGIN - MARKER_WIDTH;
        
        ctx.fillStyle = "#ff64b1";
        var x = func(part.current).lerp(left, right);
        ctx.fillRect(x, 0, MARKER_WIDTH, HEIGHT);
    }
    
    public function isDead():Bool
    {
        return currentTime >= totalTime;
    }
    
    public static function init(canvas:CanvasElement):Void 
    {
        var ctx = canvas.getContext2d();
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        var left = MARGIN;
        var right = WIDTH - MARGIN - MARKER_WIDTH;
        
        ctx.fillStyle = "#E6E6E6";
        ctx.fillRect(0, 0, left - 2, HEIGHT);
        ctx.fillRect(WIDTH - MARGIN + 1, 0, MARGIN - 2, HEIGHT);
        
        ctx.fillStyle = "#F5F5F5";
        ctx.fillRect(left, 0, WIDTH - MARGIN * 2, HEIGHT);
    }
}