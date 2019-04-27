package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxRect;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var _player:Player;
	
	private var enemiesLeft:Int = 0;
	private var curWave:Int = 0;
	
	private var grpBullets:FlxTypedGroup<Bullet>;
	private var grpEnemies:FlxTypedGroup<Enemy>;
	
	private var txtHUD:FlxText;
	private var grpHUD:FlxSpriteGroup;
	
	private var WORLDSIZE:FlxRect;
	
	override public function create():Void
	{
		WORLDSIZE = new FlxRect(0, 0, FlxG.width * 4, FlxG.height * 4);
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.bg__jpg);
		bg.setGraphicSize(Std.int(WORLDSIZE.width), Std.int(WORLDSIZE.height));
		bg.updateHitbox();
		add(bg);
		
		_player = new Player(20, 20);
		add(_player);
		
		grpEnemies = new FlxTypedGroup<Enemy>();
		add(grpEnemies);
		
		grpBullets = new FlxTypedGroup<Bullet>();
		add(grpBullets);
		
		generateEnemies();
		
		grpHUD = new FlxSpriteGroup();
		add(grpHUD);
		grpHUD.scrollFactor.set();
		
		txtHUD = new FlxText(4, 4, 0, "", 32);
		grpHUD.add(txtHUD);
		
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN, 0.02);
		FlxG.camera.followLead.set(80, 70);
		FlxG.camera.setScrollBounds(0, WORLDSIZE.width, 0, WORLDSIZE.height);
		FlxG.worldBounds.set(0, 0, WORLDSIZE.width, WORLDSIZE.height);
		
		super.create();
	}
	
	private function generateEnemies():Void
	{
		if (enemiesLeft == 0)
		{
			curWave += 1;
			while (enemiesLeft < Std.int(FlxG.random.float(8 * curWave * 0.7, 12 * (curWave * 0.7))))
			{
				var enemy:Enemy = new Eyeball(FlxG.width + FlxG.random.float(0, 60), FlxG.random.int(0, FlxG.height - 30));
				grpEnemies.add(enemy);
				
				enemiesLeft += 1;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed)
		{
			var dir:Int = 1;
			if (_player.facing == FlxObject.LEFT)
				dir = -1;
			
			var bullet:Bullet = new Bullet(_player.x, _player.y, 400 * dir, FlxAngle.asRadians(180));
			grpBullets.add(bullet);
		}
		
		
		super.update(elapsed);
		
		grpEnemies.forEachAlive(function(e:Enemy)
		{
			if (e.x <= 0)
				e.x = FlxG.width;
		});
		
		FlxG.overlap(grpBullets, grpEnemies, function(b:Bullet, e:Enemy)
		{
			b.kill();
			e.kill();
			
			enemiesLeft -= 1;
		});
		
		
		txtHUD.text = "Enemies left: " + enemiesLeft + " --- Wave: " + curWave;
		generateEnemies();
	}
}
