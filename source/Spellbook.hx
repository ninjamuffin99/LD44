package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
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
		
		generateSpells();
		
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.book__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);
		
		
		for (i in 0...3)
		{
			
			var txt:FlxText = new FlxText(70, 80 + (100 * i), FlxG.width / 2, "BLAH BLAH BLACH\n\nSPELLS AND SHIT\nLMAO", 24);
			txt.font = AssetPaths.LionCub_Regular_2__ttf;
			txt.color = FlxColor.BLACK;
			txt.text = spells.get(spellArray[i])[0] + "\nCosts: " + Std.string(spells.get(spellArray[i])[1] * 100) + "% of total life";
			txt.alpha = 0.7;
			
			var bgBtn:FlxSpriteButton = new FlxSpriteButton(50, 60 + (100 * i), null, function()
			{
				if (!spells.get(spellArray[i])[2])
				{
					p.life -= spells.get(spellArray[i])[1];
					spells.get(spellArray[i])[2] = true;
					txt.text = "BOUGHT!";
				}
			});
			bgBtn.makeGraphic(400, 86, FlxColor.BLACK);
			bgBtn.alpha = 0.1;
			bgBtn.onOver.callback = function(){bgBtn.alpha = 0.2; };
			bgBtn.onOut.callback = function(){bgBtn.alpha = 0.1; };
			add(bgBtn);
			
			add(txt);
		}
	}
	
	private function generateSpells():Void
	{
		spells.set("goLeft", ["Allows you to shoot to the left!", 		0.05, false]);
		spells.set("triple", ["Shoots 3 bullets in a burst!", 			0.05, false]);
		spells.set("triple2", ["Shoots bullets in multi directions!", 	0.05, false]);
	}
	
	private var spellArray:Array<String> = 
	[
		"goLeft",
		"triple",
		"triple2"
	];
}