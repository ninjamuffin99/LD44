package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
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
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.eyeball__png, AssetPaths.eyeball__xml);
		frames = tex;
		
		setGraphicSize(Std.int(width * FlxG.random.float(0.19, 0.22)));
		updateHitbox();
		
		animation.addByPrefix("blue", "eyeblue", 24);
		animation.addByPrefix("red", "eyered", 24);
		animation.play("blue");
		
		ETYPE = Enemy.EYEBALL;
		
		speed *= FlxG.random.float(1.7, 2.3);
		
		life = 0.2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		acceleration.x = speed;
		maxVelocity.x = speed;
		
		super.update(elapsed);
	}
	
}