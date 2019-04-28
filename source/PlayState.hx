package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	
	private var enemiesLeft:Int = 0;
	private var curWave:Int = 0;
	private var waveTimer:Float = 20;
	
	private var txtWaveTime:FlxText;
	
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
		
		initHUD();
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.LOCKON, 0.1);
		FlxG.camera.followLead.set(10, 5);
		FlxG.camera.setScrollBounds(0, WORLDSIZE.width, 0, WORLDSIZE.height);
		FlxG.worldBounds.set(0, 0, WORLDSIZE.width, WORLDSIZE.height);
		
		super.create();
	}
	
	private function initHUD():Void
	{
		
		grpHUD = new FlxSpriteGroup();
		add(grpHUD);
		grpHUD.scrollFactor.set();
		
		txtHUD = new FlxText(4, 4, 0, "", 32);
		grpHUD.add(txtHUD);
		
		txtWaveTime = new FlxText(0, FlxG.height - 80, 0, "WAVE STARTS IN: ", 30);
		txtWaveTime.color = FlxColor.RED;
		txtWaveTime.alignment = CENTER;
		txtWaveTime.screenCenter(X);
		grpHUD.add(txtWaveTime);
	}
	
	private function generateEnemies():Void
	{
		if (enemiesLeft == 0)
		{
			if (waveTimer >= 0)
			{
				waveTimer -= FlxG.elapsed;
				
				if (waveTimer > 9)
				{
					txtWaveTime.visible = true;
				}
				else
				{
					FlxFlicker.flicker(txtWaveTime, 0, 0.3, false, false);
				}
				
				
				txtWaveTime.text = "WAVE STARTS IN\n" + FlxMath.roundDecimal(waveTimer, 2) + "S";
				txtWaveTime.screenCenter(X);
			}
			else
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
		else
			txtWaveTime.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		if (_player.life <= 0)
			FlxG.resetState();
		
		if (FlxG.mouse.justPressed)
		{
			var dir:Int = 1;
			if (_player.facing == FlxObject.LEFT)
				dir = -1;
			
			var bullet:Bullet = new Bullet(_player.x, _player.y, 700 * dir, FlxAngle.asRadians(180));
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
		});
		
		FlxG.overlap(_player, grpEnemies, function(p:Player, e:Enemy)
		{
			if (!_player.invincible)
			{
				var pulseShit:Float = 1500;
				
				var daAngle:Float = Math.atan2(p.getMidpoint().y - e.getMidpoint().y, p.getMidpoint().x - e.getMidpoint().x);
				
				var xdir = Math.cos(daAngle);
				var ydir = Math.sin(daAngle);
				
				p.velocity.y += ydir * pulseShit;
				p.velocity.x += xdir * pulseShit;
				
				e.kill();
				
				_player.life -= 0.1;
				_player.invincibleStart();
			}
		});
		
		var enCount:Int = 0;
		grpEnemies.forEachAlive(function(e:Enemy)
		{
			enCount += 1;
		});
		
		enemiesLeft = enCount;
		
		txtHUD.text = "Enemies left: " + enemiesLeft + " --- Wave: " + curWave + " --- LIFE: " + FlxMath.roundDecimal(_player.life, 2);
		generateEnemies();
	}
}
