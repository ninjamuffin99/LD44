package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
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
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.bat__png, AssetPaths.bat__xml);
		frames = tex;
		
		animation.addByPrefix("fly", "batfly", 24);
		animation.play("fly");
		
		setGraphicSize(Std.int(width * 0.4));
		updateHitbox();
		
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