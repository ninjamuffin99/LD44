package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;

/**
 * ...
 * @author ...
 */
class Pixie extends FlxSprite 
{
	private var thePlayer:Player;
	
	private var speed:Float = 400;
	
	public function new(?X:Float=0, ?Y:Float=0, daPlayer:Player) 
	{
		super(X, Y);
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.pixie__png, AssetPaths.pixie__xml);
		frames = tex;
		animation.add("idle", [0, 1], 6);
		animation.play("idle");
		
		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		maxVelocity.set(300, 300);
		
		thePlayer = daPlayer;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (velocity.x < 0)
			flipX = true;
		else
			flipX = false;
		
		angle = FlxMath.remapToRange(velocity.x, 0, 120, 0, 15);
		super.update(elapsed);
		var dx = thePlayer.getMidpoint().x - x;
		var dy = thePlayer.getMidpoint().y - y;
		var length = Math.sqrt(dx * dx + dy * dy);
		
		if (length > 40)
		{
			var angleOffset = Math.atan2(this.y - thePlayer.y, this.x - thePlayer.x);
			
			var xdir = Math.cos(angleOffset);
			var ydir = Math.sin(angleOffset);
			acceleration.x = xdir * -speed;
			acceleration.y = ydir * -speed;
			
		}
		else
		{
			acceleration.set();
		}
		
	}
	
}