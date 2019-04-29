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
		
		ETYPE = Enemy.EYEBALL;
		
		speed *= FlxG.random.float(1.7, 2.3);
		
		life = 0.2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		acceleration.x = -speed;
		maxVelocity.x = speed;
		
		super.update(elapsed);
	}
	
}