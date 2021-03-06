package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class MenuState extends FlxState 
{
	private var camFollow:FlxObject;
	
	private var logo:FlxSprite;
	private var logo2:FlxSprite;

	override public function create():Void 
	{
		
		var bg:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.bg__png);
		bg.scrollFactor.set(0.1, 0.2);
		/*bg.setGraphicSize(Std.int(WORLDSIZE.width), Std.int(WORLDSIZE.height));
		bg.updateHitbox();*/
		add(bg);
		
		var clouds1:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.cloudsLong__png);
		clouds1.scrollFactor.set(0.35, 0.35);
		clouds1.alpha = 0.6;
		add(clouds1);
		FlxTween.tween(clouds1, {x: FlxG.width * 0.5}, 40, {type:FlxTweenType.PINGPONG});
		
		var moreCloudsLol:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.cloudsFew__png);
		moreCloudsLol.setGraphicSize(Std.int(moreCloudsLol.width * 0.6));
		moreCloudsLol.updateHitbox();
		moreCloudsLol.scrollFactor.set(0.25, 0.25);
		moreCloudsLol.alpha = 0.4;
		add(moreCloudsLol);
		FlxTween.tween(moreCloudsLol, {x: FlxG.width * 0.3}, 40, {type:FlxTweenType.PINGPONG});
		
		var bg1:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.bg1point2__png);
		bg1.scrollFactor.set(0.45, 0.45);
		add(bg1);
		
		var clouds2:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.cloudsFew__png);
		clouds2.flipX = true;
		clouds2.scrollFactor.set(0.52, 0.52);
		clouds2.alpha = 0.7;
		add(clouds2);
		FlxTween.tween(clouds2, {x: FlxG.width * 0.6}, 40, {type:FlxTweenType.PINGPONG});
		
		var bg2:FlxSprite = new FlxSprite(-200, -200).loadGraphic(AssetPaths.bg2__png);
		bg2.scrollFactor.set(0.60, 0.60);
		add(bg2);
		
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		
		FlxG.camera.follow(camFollow, null, 0.1);
		
		var girl:FlxSprite = new FlxSprite(620, 100).loadGraphic(AssetPaths.witchTitle__png);
		girl.scrollFactor.set(0.1, 0.1);
		girl.flipX = true;
		girl.setGraphicSize(Std.int(girl.width * 0.7));
		girl.updateHitbox();
		girl.antialiasing = true;
		add(girl);
		
		var txt:FlxText = new FlxText(40, 40, 0, "PARISTROYER\n\n\nPRESS ENTER", 32);
		txt.font = "assets/data/DK Lemon Yellow Sun.otf";
		txt.scrollFactor.set();
		//add(txt);
		
		logo2 = new FlxSprite(90, 185).loadGraphic(AssetPaths.titlelogo__png);
		logo2.setGraphicSize(Std.int(logo2.width * 0.355));
		logo2.updateHitbox();
		logo2.antialiasing = true;
		logo2.scrollFactor.set(0.02, 0.02);
		logo2.color = FlxColor.BLACK;
		add(logo2);
		
		logo = new FlxSprite(90, 185).loadGraphic(AssetPaths.titlelogo__png);
		logo.setGraphicSize(Std.int(logo.width * 0.35));
		logo.updateHitbox();
		logo.antialiasing = true;
		logo.scrollFactor.set(0.02, 0.02);
		FlxTween.tween(logo.offset, {y: logo.offset.y + 20}, 0.8, {ease:FlxEase.quadInOut, type:	FlxTweenType.PINGPONG});
		FlxTween.tween(logo2.offset, {y: logo2.offset.y + 26}, 0.81, {ease:FlxEase.quadInOut, type:	FlxTweenType.PINGPONG});
		add(logo);
		
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		FlxG.sound.playMusic(AssetPaths.ambience__mp3, 0);
		FlxG.sound.music.fadeIn(3, 0, 0.65);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		cameraHandle();
		
		logo.angle = FlxMath.remapToRange(FlxG.mouse.x - FlxG.width / 2, 0, FlxG.width / 2, 0, 2);
		logo2.angle = FlxMath.remapToRange(FlxG.mouse.x - FlxG.width / 2, 0, FlxG.width / 2, 0, 4);
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.sound.music.fadeOut(2);
			FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}
		super.update(elapsed);
	}
	
	private function cameraHandle():Void
	{
		//SHOUTOUT TO MIKE, AND ALSO BOMTOONS
		var dx = (FlxG.width / 2) - FlxG.mouse.x;
		var dy = (FlxG.height / 2) - FlxG.mouse.y;
		//length = Math.sqrt(dx * dx + dy * dy);
		var camOffset = 0.4;
		dx *= camOffset;
		dy *= camOffset;
		camFollow.x = (FlxG.width / 2) - dx;
		camFollow.y = (FlxG.height / 2) - dy;
	}
}