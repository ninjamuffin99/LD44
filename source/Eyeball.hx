package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
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
			case 0:
				animation.play("blue");
				ETYPE = Enemy.EYEBALL;
			case 1:
				animation.play("blue");
				ETYPE = Enemy.EYERED;
		}
		
		theEyeType = eyeType;
		
		speed *= FlxG.random.float(1.7, 2.3);
		
		life = 0.2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		switch(theEyeType)
		{
			case 0:
				acceleration.x = speed;
				maxVelocity.x = speed;
			case 1:
				
		}
		
		
		super.update(elapsed);
	}
	
}