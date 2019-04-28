package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{
	private var speed:Float = 1900;
	private var thaDrag:Float = 680;
	private var maxVel:Float = 350;
	public var life:Float = 1;
	
	public var invincible:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(100, 60);
		
		drag.set(thaDrag, thaDrag);
		
		maxVelocity.set(maxVel, maxVel);
	}
	
	override public function update(elapsed:Float):Void 
	{
		controls();
		
		if (invincible)
		{
			//drag.set(thaDrag * 0.6, thaDrag * 0.6);
			FlxFlicker.flicker(this, 0, 0.04, false, false);
		}
		else
		{
			drag.set(thaDrag, thaDrag);
			FlxFlicker.stopFlickering(this);
		}
		
		super.update(elapsed);
	}
	
	public function invincibleStart(time:Float = 1):Void
	{
		invincible = true;
		
		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			invincible = false;
		});
	}
	
	private function controls():Void
	{
		var up:Bool = FlxG.keys.anyPressed(["UP", "W"]);
		var down:Bool = FlxG.keys.anyPressed(["DOWN", "S"]);
		var left:Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
		var right:Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		
		if (up || down || right || left)
		{
			if (up || down)
			{
				if (up)
				{
					acceleration.y = -speed;
				}
				else
				{
					acceleration.y = speed;
				}
			}
			else
				acceleration.y = 0;
			
			
			if (left || right)
			{
				if (left)
				{
					facing = FlxObject.LEFT;
					acceleration.x = -speed;
				}
				else
				{
					facing = FlxObject.RIGHT;
					acceleration.x = speed;
				}
			}
			else
				acceleration.x = 0;
			
			
		}
		else
			acceleration.x = acceleration.y = 0;
	}
}