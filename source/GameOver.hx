package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class GameOver extends FlxState 
{
	
	private var selector:FlxText;
	private var contSelected:Bool = true;
	private var cont:FlxText;
	private var text:FlxText;
	
	override public function create():Void 
	{
		FlxG.sound.playMusic(AssetPaths.gameOverSong__mp3, 0);
		FlxG.sound.music.fadeIn(3, 0, 0.7);
		FlxG.camera.fade(FlxColor.BLACK, 4, true);
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.cry__png, AssetPaths.cry__xml);
		var sad:FlxSprite = new FlxSprite(80, FlxG.height * 0.3);
		sad.frames = tex;
		sad.animation.addByPrefix("sad", "cry", 24);
		sad.animation.play("sad");
		add(sad);
		
		cont = new FlxText(0, 100, 0, "continue??", 24);
		cont.screenCenter(X);
		cont.x += 200;
		add(cont);
		
		text = new FlxText(0, FlxG.height * 0.7, 0, "CONTINUE\nQUIT", 24);
		text.alignment = CENTER;
		text.screenCenter(X);
		text.x += 200;
		add(text);
		
		selector = new FlxText(FlxG.width * 0.35, text.y, 0, ">>", 24);
		selector.x += 210;
		add(selector);
		FlxFlicker.flicker(selector, 0, 0.7);
		
		super.create();
	}
	
	private var transitioning:Bool = false;
	
	override public function update(elapsed:Float):Void 
	{
		if (!transitioning)
		{
			if (FlxG.keys.anyJustPressed([W, S, UP, DOWN]))
			contSelected = !contSelected;
			
			if (contSelected)
				selector.y = FlxG.height * 0.7;
			else
				selector.y = (FlxG.height * 0.7) + 30;
			
			if (FlxG.keys.justPressed.SPACE)
			{
				transitioning = true;
				FlxFlicker.stopFlickering(selector);
				if (contSelected)
				{
					FlxG.switchState(new PlayState());
				}
				else
				{
					FlxG.camera.fade(FlxColor.BLACK, 11);
					FlxG.sound.music.fadeOut(1.5);
					FlxG.sound.play(AssetPaths.gameOverJingle__mp3, 0.7, false, null, true, function()
					{
						FlxG.switchState(new MenuState());
					}).fadeIn(5, 0, 1);
				}
			}
			
		}
		else
		{
			FlxFlicker.flicker(selector, 0, 0.1);
		}
		
		super.update(elapsed);
	}
	
}