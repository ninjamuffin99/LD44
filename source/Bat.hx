package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Bat extends Enemy 
{
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		ETYPE = Enemy.BAT;
		
		
		damageDone = 0.01;
		color = FlxColor.CYAN;
		
		speed *= FlxG.random.float(1.5, 2.3);
		life = 0.1;
	}
	
	override public function kill():Void 
	{
		FlxG.log.add("DIED???");
		super.kill();
	}
	
}