package;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Laser extends Bullet 
{

	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, bullAngle:Float) 
	{
		super(X, Y, Speed, bullAngle);
		
		makeGraphic(50, 4, FlxColor.YELLOW);
		width = 4;
		centerOffsets();
	}
	
}