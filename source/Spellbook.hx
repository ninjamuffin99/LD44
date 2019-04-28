package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Spellbook extends FlxSpriteGroup 
{
	/**
	 * And by on, i actually mean open lolol
	 */
	public var on:Bool = false;
	
	public var spells:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
	public var arrowSpeed:Float = 1;

	public function new(X:Float=0, Y:Float=0, p:Player) 
	{
		super(X, Y);
		
		spells.set("goLeft", ["Allows you to shoot to the left!", 0.1, false]);
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.book__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);
		
		var txt:FlxText = new FlxText(60, 30, FlxG.width / 2, "BLAH BLAH BLACH\n\nSPELLS AND SHIT\nLMAO", 20);
		txt.color = FlxColor.BLACK;
		txt.text = spells.get("goLeft")[0] + "\nCosts: " + Std.string(spells.get("goLeft")[1] * 10) + "% of total life";
		add(txt);
		
		var btn:FlxButton = new FlxButton(60, 80, "Learn!", function()
		{
			if (!spells.get("goLeft")[2])
			{
				p.life -= spells.get("goLeft")[1];
				spells.get("goLeft")[2] = true;
				txt.text = "BOUGHT!";
			}
		});
		add(btn);
	}
	
}