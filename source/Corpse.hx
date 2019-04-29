package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Corpse extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, etype:Int) 
	{
		super(X, Y);
		
		makeGraphic(70, 20, FlxColor.BROWN);
		acceleration.y = 600;
		drag.set(10, 10);
		
		switch(etype)
		{
			case Enemy.EYEBALL:
				var tex = FlxAtlasFrames.fromSparrow(AssetPaths.eyeball__png, AssetPaths.eyeball__xml);
				frames = tex;
				setGraphicSize(Std.int(width * 0.2));
				updateHitbox();
				
				animation.addByPrefix("ded", "eyedeadblue", 24);
				animation.play("ded");
		}
		
		
		new FlxTimer().start(5, function(tmr:FlxTimer){kill(); });
	}
	
}