package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Corpse extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(70, 20, FlxColor.BROWN);
		acceleration.y = 600;
		drag.set(10, 10);
		
		new FlxTimer().start(5, function(tmr:FlxTimer){kill(); });
	}
	
}