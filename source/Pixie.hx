package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Pixie extends FlxSprite 
{
	private var thePlayer:Player;
	
	public function new(?X:Float=0, ?Y:Float=0, daPlayer:Player) 
	{
		super(X, Y);
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.pixie__png, AssetPaths.pixie__xml);
		frames = tex;
		setGraphicSize(Std.int(width * 0.7));
		
		thePlayer = daPlayer;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!FlxMath.isDistanceToPointWithin(this, thePlayer.getMidpoint(), 120))
		{
			FlxVelocity.moveTowardsPoint(this, thePlayer.getMidpoint(), 180);
		}
		
		
		super.update(elapsed);
	}
	
}