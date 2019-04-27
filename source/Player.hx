package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{
	private var speed:Float = 800;
	private var thaDrag:Float = 440;
	private var maxVel:Float = 350;
	public var life:Float = 1;

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
		
		super.update(elapsed);
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
					acceleration.x = -speed;
				}
				else
				{
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