package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Eyeball extends Enemy 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		speed *= FlxG.random.float(1.5, 2.3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		velocity.x = -speed;
		
		super.update(elapsed);
	}
	
}