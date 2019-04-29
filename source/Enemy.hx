package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Enemy extends FlxSprite 
{
	public var speed:Float = 150;
	private var followPlayer:Bool = false;
	public var damageDone:Float = 0.05;
	public var life:Float = 0.1;
	public var laserTimer:Float = 0;
	public var _player:Player;
	
	public var ETYPE:Int = 0;
	
	public static inline var EYEBALL:Int = 1;
	public static inline var EYERED:Int = 2;
	public static inline var BAT:Int = 10;
	
	public var daSound:FlxSound;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(40, 40, FlxColor.GREEN);
		
		drag.set(50, 200);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (life <= 0)
			kill();
		
		super.update(elapsed);
	}
	
}