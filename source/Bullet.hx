package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Bullet extends FlxSprite 
{

	private var life:Float = 3;
	public var speed:Float;
	private var angleOffset:Float = 0;
	public var accuracy:Float = 1;
	public var bType:String = "";
	
	public var damage:Float = 0.1;
	
	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, bullAngle:Float) 
	{
		super(X, Y);
		
		makeGraphic(16, 8, FlxColor.RED);
		width = 10;
		height = 10;
		offset.y = 5;
		offset.x = 11;
		
		angleOffset = FlxAngle.asRadians(FlxG.random.float( -4, 4) * accuracy + FlxAngle.asDegrees(bullAngle));
		
		var xdir = Math.cos(angleOffset);
		var ydir = Math.sin(angleOffset);
		
		x += xdir * 10;
		y += ydir * 10;
		
		speed = Speed;
		
		velocity.x = xdir * -speed;
		velocity.y = ydir * -speed;
		
		angle = FlxAngle.asDegrees(angleOffset);
		
		//dir = Direction;
		damage = 0.1;
		centerOffsets(true);
		
		//velocity.y = FlxG.random.float( -25, 25);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var rads:Float = Math.atan2(velocity.y, velocity.x);
		//curRads = rads;
		
		var degs = FlxAngle.asDegrees(rads);
		//FlxG.watch.addQuick("Degs/Angle", degs);
		if (bType == "Player")
		{
			angle = degs + 90;
		}
		else
			angle = degs;
		
		life -= FlxG.elapsed;
		if (life < 0)
		{
			kill();
		}	
	}
}