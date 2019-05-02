package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

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
	
	private var grp1stPage:FlxTypedSpriteGroup<FlxText>;
	private var title:FlxText;
	private var p:Player;
	
	private var nextBtn:FlxSpriteButton;
	private var prevBtn:FlxSpriteButton;
	private var nextTxt:FlxText;
	private var prevTxt:FlxText;

	public function new(X:Float=0, Y:Float=0, p:Player) 
	{
		super(X, Y);
		
		this.p = p;
		
		generateSpells();
		
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.book__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);
		
		prevBtn = new FlxSpriteButton(70, FlxG.height - 100, null, function()
		{
			curPage -= 1; 
			FlxG.sound.play(AssetPaths.bookClose__mp3, 0.5);
		});
		prevBtn.makeGraphic(50, 32, FlxColor.BLACK);
		prevBtn.alpha = 0.1;
		prevBtn.onOver.callback = function(){prevBtn.alpha = 0.2; };
		prevBtn.onOut.callback = function(){prevBtn.alpha = 0.1; };
		add(prevBtn);
		
		nextBtn = new FlxSpriteButton(FlxG.width - 95, FlxG.height - 100, null, function()
		{
			curPage += 1;
			FlxG.sound.play(AssetPaths.bookOpen__mp3, 0.5);
		});
		nextBtn.makeGraphic(50, 32, FlxColor.BLACK);
		nextBtn.alpha = 0.1;
		nextBtn.onOver.callback = function(){nextBtn.alpha = 0.2; };
		nextBtn.onOut.callback = function(){nextBtn.alpha = 0.1; };
		nextBtn.visible = false;
		add(nextBtn);
		
		prevTxt = new FlxText(70 + 4, FlxG.height - 100 + 4, 0, "prev", 22);
		prevTxt.font = AssetPaths.LionCub_Regular_2__ttf;
		prevTxt.color = FlxColor.BLACK;
		add(prevTxt);
		
		nextTxt = new FlxText(FlxG.width - 90, FlxG.height - 100 + 4, 0, "next", 22);
		nextTxt.font = AssetPaths.LionCub_Regular_2__ttf;
		nextTxt.color = FlxColor.BLACK;
		add(nextTxt);
		
		grpBtns = new FlxTypedSpriteGroup<FlxSpriteButton>();
		add(grpBtns);
		
		grpTxts = new FlxTypedSpriteGroup<FlxText>();
		add(grpTxts);
		
		for (i in 0...6)
		{
			var curSpell:Array<Dynamic> = spells.get(spellArray[i]);
			
			var xOff:Float = 50;
			if (i >= 3)
				xOff += FlxG.width * 0.47;
			
			var txt:FlxText = new FlxText(xOff + 20, 80 + (110 * (i % 3)), FlxG.width * 0.4, "BLAH BLAH BLACH\n\nSPELLS AND SHIT\nLMAO", 24);
			txt.font = AssetPaths.LionCub_Regular_2__ttf;
			txt.color = FlxColor.BLACK;
			txt.text = curSpell[3] + ": " + curSpell[0] + "\nCosts: " + Std.string(curSpell[1] * 100) + "% of total life";
			txt.alpha = 0.7;
			
			var bgBtn:FlxSpriteButton = new FlxSpriteButton(xOff, 80 + (110 * (i % 3)), null);
			bgBtn.makeGraphic(400, 95, FlxColor.WHITE);
			bgBtn.color = FlxColor.BLACK;
			bgBtn.alpha = 0.1;
			bgBtn.onOver.callback = function(){bgBtn.alpha = 0.2; };
			bgBtn.onOut.callback = function(){bgBtn.alpha = 0.1; };
			grpBtns.add(bgBtn);
			
			grpTxts.add(txt);
		}
		
		grp1stPage = new FlxTypedSpriteGroup<FlxText>();
		add(grp1stPage);
		
		title = new FlxText(FlxG.width * 0.02, 70, FlxG.width * 0.5, "Paristroyer", 90);
		title.font = "assets/data/DK Lemon Yellow Sun.otf";
		title.color = FlxColor.BLACK;
		title.alignment = CENTER;
		grp1stPage.add(title);
		
		var createdBy:FlxText = new FlxText(FlxG.width * 0.1, 160, FlxG.width * 0.3, "Designed by Arzonaut and ninja_muffin99\nMade in 72 hours for Ludum Dare 44\n'Your life is currency'", 32);
		createdBy.font = AssetPaths.LionCub_Regular_2__ttf;
		createdBy.color = FlxColor.BLACK;
		createdBy.alpha = 0.7;
		createdBy.alignment = CENTER;
		grp1stPage.add(createdBy);
		
		var creds:FlxText = new FlxText(FlxG.width * 0.28, 100, FlxG.width * 0.9, "Programming - ninja_muffin99\nArt - Arzonaut\nAdditional Art - FuShark and Digimin\nMusic - nerostratos\nAdditional Music - Yahtzei\nSound Help - PhantomArcade\n\nMade with HaxeFlixel\nSpecial thanks to Newgrounds", 24);
		creds.text += "\nSource code - Githib.com/ninjamuffin99/ld44";
		creds.font = AssetPaths.LionCub_Regular_2__ttf;
		creds.color = FlxColor.BLACK;
		creds.alpha = 0.7;
		creds.alignment = CENTER;
		grp1stPage.add(creds);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (curPage == 0)
		{
			prevTxt.visible = true;
			prevBtn.visible = true;
			nextTxt.visible = false;
			nextBtn.visible = false;
		}
		else
		{
			prevTxt.visible = false;
			prevBtn.visible = false;
			nextBtn.visible = true;
			nextTxt.visible = true;
		}
		
		if (curPage >= 0)
		{
			grpTxts.visible = true;
			grpBtns.visible = true;
			grp1stPage.visible = false;
			
			for (i in 0...6)
			{
				var curSpell:Array<Dynamic> = spells.get(spellArray[i + (3 * curPage)]);
				
				if (!curSpell[2])
				{
					grpTxts.members[i].text = curSpell[3] + ": " + curSpell[0] + "\nCosts: " + Std.string(curSpell[1] * 100) + "% of total life";
					
					grpBtns.members[i].onUp.callback = function()
					{
						if (p.life > curSpell[1])
						{
							p.life -= curSpell[1];
							spells.get(spellArray[i + (3 * curPage)])[2] = true;
							if (spellArray[i + (3 * curPage)] == "altcol")
							FlxG.sound.play(AssetPaths.aquireSkill__mp3, 0.7);
						}
						else
						{
							FlxG.sound.play(AssetPaths.cantBuy__mp3);
							grpBtns.members[i].color = FlxColor.RED;
							FlxFlicker.flicker(grpBtns.members[i], 0.5, 0.1, true, false, function(flk:FlxFlicker){grpBtns.members[i].color = FlxColor.BLACK; });
						}
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
			grp1stPage.visible = true;
			grpBtns.visible = false;
			grpTxts.visible = false;
		}
		else
			curPage = -1;
		
		super.update(elapsed);
	}
	
	private function generateSpells():Void
	{
		spells.set("triple", ["Shoots 3 bullets in a burst!", 			0.4, false, "Triplosus"]);
		spells.set("triple2", ["Shoots bullets in multi directions!", 	0.2, false, "Triplosus"]);
		spells.set("boost", ["Double tap a direction to do a dash!", 	0.1, false, "Broom Boost"]);
		spells.set("pixie", ["A pixie helps you defeat enemies!", 		0.2, false, "Smol Shield"]);
		spells.set("ass", 	["Dashing downwards deals damage! (Needs Broom Boost)", 		0.3, false, "Booty Bounce"]);
		spells.set("altcol", ["An alternate color pallete!", 			0.5, false, "Fashion Police"]);
		spells.set("pixie4", ["Literally just spending life for no reason lmao", 		0.99, false, "Go commit die"]);
	}
	
	private var spellArray:Array<String> = 
	[
		"boost",
		"pixie",
		"ass",
		"triple",
		"altcol",
		"pixie4",
		
	];
}