package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
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
	private var curPage:Int = 0;
	
	private var grpBtns:FlxTypedSpriteGroup<FlxSpriteButton>;
	private var grpTxts:FlxTypedSpriteGroup<FlxText>;
	
	private var title:FlxText;
	private var p:Player;

	public function new(X:Float=0, Y:Float=0, p:Player) 
	{
		super(X, Y);
		
		this.p = p;
		
		generateSpells();
		
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.book__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);
		
		var prevBtn:FlxSpriteButton = new FlxSpriteButton(70, FlxG.height - 100, null, function()
		{
			curPage -= 1; 
			FlxG.sound.play(AssetPaths.bookClose__mp3, 0.5);
		});
		prevBtn.makeGraphic(50, 32, FlxColor.BLACK);
		prevBtn.alpha = 0.1;
		prevBtn.onOver.callback = function(){prevBtn.alpha = 0.2; };
		prevBtn.onOut.callback = function(){prevBtn.alpha = 0.1; };
		add(prevBtn);
		
		var nextBtn:FlxSpriteButton = new FlxSpriteButton(FlxG.width - 95, FlxG.height - 100, null, function()
		{
			curPage += 1;
			FlxG.sound.play(AssetPaths.bookOpen__mp3, 0.5);
		});
		nextBtn.makeGraphic(50, 32, FlxColor.BLACK);
		nextBtn.alpha = 0.1;
		nextBtn.onOver.callback = function(){nextBtn.alpha = 0.2; };
		nextBtn.onOut.callback = function(){nextBtn.alpha = 0.1; };
		add(nextBtn);
		
		var prevTxt:FlxText = new FlxText(70 + 4, FlxG.height - 100 + 4, 0, "prev", 22);
		prevTxt.font = AssetPaths.LionCub_Regular_2__ttf;
		prevTxt.color = FlxColor.BLACK;
		add(prevTxt);
		
		var nextTxt:FlxText = new FlxText(FlxG.width - 90, FlxG.height - 100 + 4, 0, "next", 22);
		nextTxt.font = AssetPaths.LionCub_Regular_2__ttf;
		nextTxt.color = FlxColor.BLACK;
		add(nextTxt);
		
		grpBtns = new FlxTypedSpriteGroup<FlxSpriteButton>();
		add(grpBtns);
		
		grpTxts = new FlxTypedSpriteGroup<FlxText>();
		add(grpTxts);
		
		for (i in 0...3)
		{
			var curSpell:Array<Dynamic> = spells.get(spellArray[i]);
			
			var txt:FlxText = new FlxText(70, 80 + (110 * i), FlxG.width * 0.4, "BLAH BLAH BLACH\n\nSPELLS AND SHIT\nLMAO", 24);
			txt.font = AssetPaths.LionCub_Regular_2__ttf;
			txt.color = FlxColor.BLACK;
			txt.text = curSpell[3] + ": " + curSpell[0] + "\nCosts: " + Std.string(curSpell[1] * 100) + "% of total life";
			txt.alpha = 0.7;
			
			var bgBtn:FlxSpriteButton = new FlxSpriteButton(50, 80 + (110 * i), null);
			bgBtn.makeGraphic(400, 95, FlxColor.BLACK);
			bgBtn.alpha = 0.1;
			bgBtn.onOver.callback = function(){bgBtn.alpha = 0.2; };
			bgBtn.onOut.callback = function(){bgBtn.alpha = 0.1; };
			grpBtns.add(bgBtn);
			
			grpTxts.add(txt);
		}
		
		title = new FlxText(FlxG.width * 0.12, 100, FlxG.width * 0.3, "Instert title here", 50);
		title.font = "assets/data/DK Lemon Yellow Sun.otf";
		title.color = FlxColor.BLACK;
		title.alignment = CENTER;
		add(title);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (curPage >= 0)
		{
			grpTxts.visible = true;
			grpBtns.visible = true;
			title.visible = false;
			
			for (i in 0...3)
			{
				var curSpell:Array<Dynamic> = spells.get(spellArray[i + (3 * curPage)]);
				
				if (!curSpell[2])
				{
					grpTxts.members[i].text = curSpell[3] + ": " + curSpell[0] + "\nCosts: " + Std.string(curSpell[1] * 100) + "% of total life";
					
					grpBtns.members[i].onUp.callback = function()
					{
						p.life -= curSpell[1];
						spells.get(spellArray[i + (3 * curPage)])[2] = true;
						FlxG.sound.play(AssetPaths.aquireSkill__mp3, 0.7);
					};
				}
				else
				{
					grpTxts.members[i].text = curSpell[3] + ": " + curSpell[0] + "\nLearned!";
				}
				
			}
		}
		else if (curPage >= -1)
		{
			title.visible = true;
			grpBtns.visible = false;
			grpTxts.visible = false;
		}
		else
			curPage = -1;
		
		super.update(elapsed);
	}
	
	private function generateSpells():Void
	{
		spells.set("triple", ["Shoots 3 bullets in a burst!", 			0.05, false, "Trio Spellshit"]);
		spells.set("triple2", ["Shoots bullets in multi directions!", 	0.05, false, "Triplosus"]);
		spells.set("boost", ["Double tap a direction to do a dash!", 	0.05, false, "Coolboost"]);
		spells.set("pixie", ["A pixie helps you defeat enemies!", 		0.1, false, "Smol help"]);
		spells.set("ass", 	["Dashing downwards deals damage!", 		0.1, false, "Booty bounce"]);
		spells.set("pixie3", ["", 		0.05, false, ""]);
		spells.set("pixie4", ["", 		0.05, false, ""]);
	}
	
	private var spellArray:Array<String> = 
	[
		"triple",
		"triple2",
		"boost",
		"pixie",
		"ass",
		"pixie3",
		"pixie4"
	];
}