package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{
	private var speed:Float = 1750;
	private var thaDrag:Float = 500;
	private var maxVel:Float = 330;
	public var life:Float = 0.2;
	
	public var invincible:Bool = false;
	
	public var on:Bool = false;
	
	private var boostDir:Int = 0;
	private var boostTmr:Float = 0;
	private var boostCoolDown:Float = 0;
	public var shootingCoolDown:Float = 0;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		//makeGraphic(100, 60);
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.witch__png, AssetPaths.witch__xml);
		frames = tex;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		setGraphicSize(Std.int(width * 0.6));
		updateHitbox();
		
		offset.y = 70;
		height -= 50;
		
		offset.x = 200;
		width -= 190;
		
		
		drag.set(thaDrag, thaDrag);
		
		maxVelocity.set(maxVel, maxVel);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (shootingCoolDown > 0)
			shootingCoolDown -= FlxG.elapsed;
		
		switch (facing)
		{
			case FlxObject.LEFT:
				offset.x = 150;
			case FlxObject.RIGHT:
				offset.x = 200;
		}
		
		if (!on)
			controls();
		
		if (invincible)
		{
			//drag.set(thaDrag * 0.6, thaDrag * 0.6);
			FlxFlicker.flicker(this, 0, 0.04, false, false);
		}
		else
		{
			drag.set(thaDrag, thaDrag);
			FlxFlicker.stopFlickering(this);
		}
		
		super.update(elapsed);
	}
	
	public function invincibleStart(time:Float = 1):Void
	{
		invincible = true;
		
		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			invincible = false;
		});
	}
	
	private function controls():Void
	{
		var up:Bool = FlxG.keys.anyPressed(["UP", "W"]);
		var down:Bool = FlxG.keys.anyPressed(["DOWN", "S"]);
		var left:Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
		var right:Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		var upP:Bool = FlxG.keys.anyJustPressed(["UP", "W"]);
		var downP:Bool = FlxG.keys.anyJustPressed(["DOWN", "S"]);
		var leftP:Bool = FlxG.keys.anyJustPressed(["LEFT", "A"]);
		var rightP:Bool = FlxG.keys.anyJustPressed(["RIGHT", "D"]);
		
		// only does it for a second, little baby ass optimization lol
		if (boostTmr < 1)
			boostTmr += FlxG.elapsed;
		
		if (boostCoolDown > 0)
			boostCoolDown -= FlxG.elapsed;
		
		if (maxVelocity.x > maxVel)
		{
			maxVelocity.x -= 10;
			maxVelocity.y -= 10;
		}
		
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		
		if (up || down || right || left)
		{
			if (up || down)
			{
				if (up)
				{
					acceleration.y = -speed;
				}
				else
				{
					acceleration.y = speed;
				}
			}
			else
				acceleration.y = 0;
			
			
			if (left || right)
			{
				if (left)
				{
					if (!FlxG.keys.pressed.SHIFT)
						facing = FlxObject.LEFT;
					acceleration.x = -speed;
				}
				else
				{
					if (!FlxG.keys.pressed.SHIFT)
						facing = FlxObject.RIGHT;
					acceleration.x = speed;
				}
			}
			else
				acceleration.x = 0;
			
			
		}
		else
			acceleration.x = acceleration.y = 0;
		
		if (upP || downP || leftP || rightP)
		{
			var boostOld = boostDir;
			
			if (upP)
			{
				boostDir = FlxObject.UP;
			}
			else if (downP)
			{
				boostDir = FlxObject.DOWN;
			}
			else if (leftP)
			{
				boostDir = FlxObject.LEFT;
			}
			else if (rightP)
			{
				boostDir = FlxObject.RIGHT;
			}
			
			if (boostTmr <= 0.3 && boostOld == boostDir && boostCoolDown <= 0)
			{
				FlxG.log.add("BOOSTED");
				//velocity.set(velocity.x * 0.1, velocity.y * 0.1);
				
				var velMult:Float = 2.2;
				maxVelocity.set(maxVel * velMult, maxVel * velMult);
				switch(boostDir)
				{
					case FlxObject.UP:
						velocity.y *= 0.1;
						velocity.y -= maxVel * velMult;
					case FlxObject.DOWN:
						velocity.y *= 0.1;
						velocity.y += maxVel * velMult;
					case FlxObject.LEFT:
						velocity.x *= 0.1;
						velocity.x -= maxVel * velMult;
					case FlxObject.RIGHT:
						velocity.x *= 0.1;
						velocity.x += maxVel * velMult;
				}
				
				boostCoolDown = 0.5;
			}
			
			boostTmr = 0;
		}
	}
}