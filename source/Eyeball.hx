package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;

/**
 * ...
 * @author 
 */
class Eyeball extends Enemy 
{
	private var theEyeType:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, eyeType:Int = 0) 
	{
		super(X, Y);
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.eyeball__png, AssetPaths.eyeball__xml);
		frames = tex;
		
		setGraphicSize(Std.int(width * FlxG.random.float(0.19, 0.22)));
		updateHitbox();
		
		animation.addByPrefix("blue", "eyeblue", 24);
		animation.addByPrefix("red", "eyered", 24);
		
		switch(eyeType)
		{
			case Enemy.EYEBALL:
				animation.play("blue");
				ETYPE = Enemy.EYEBALL;
			case Enemy.EYERED:
				animation.play("red");
				ETYPE = Enemy.EYERED;
				speed *= FlxG.random.float(1.0, 1.3);
		}
		
		theEyeType = eyeType;
		laserTimer = FlxG.random.float(1, 4);
		
		speed *= FlxG.random.float(1.7, 2.3);
		
		life = 0.2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		switch(theEyeType)
		{
			case Enemy.EYEBALL:
				acceleration.x = speed;
				maxVelocity.x = speed;
			case Enemy.EYERED:
				if (FlxMath.isDistanceWithin(this, _player, 300))
				{
					FlxVelocity.moveTowardsPoint(this, _player.getPosition(), speed);
					
				}
				else
				{
					acceleration.x = speed;
					maxVelocity.x = speed;
				}
				
				laserTimer -= FlxG.elapsed;
				
		}
		
		
		super.update(elapsed);
	}
	
}