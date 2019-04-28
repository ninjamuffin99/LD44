package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	private var _player:Player;
	
	private var enemiesLeft:Int = 0;
	private var curWave:Int = 0;
	private var waveTimer:Float = 15;
	
	private var txtWaveTime:FlxText;
	
	private var grpBullets:FlxTypedGroup<Bullet>;
	private var grpEnemies:FlxTypedGroup<Enemy>;
	
	private var txtHUD:FlxText;
	private var grpHUD:FlxSpriteGroup;
	
	private var WORLDSIZE:FlxRect;
	
	private var _book:Spellbook;
	private var walls:FlxGroup;
	
	private var _camTrack:FlxObject;
	
	override public function create():Void
	{
		WORLDSIZE = new FlxRect(0, 0, FlxG.width * 4, FlxG.height * 4);
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.bg__png);
		bg.setGraphicSize(Std.int(WORLDSIZE.width), Std.int(WORLDSIZE.height));
		bg.updateHitbox();
		add(bg);
		
		_player = new Player(WORLDSIZE.width / 2, WORLDSIZE.height / 2);
		add(_player);
		
		grpEnemies = new FlxTypedGroup<Enemy>();
		add(grpEnemies);
		
		grpBullets = new FlxTypedGroup<Bullet>();
		add(grpBullets);
		
		initHUD();
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		FlxG.camera.focusOn(_player.getPosition());
		
		FlxG.camera.follow(_camTrack, FlxCameraFollowStyle.LOCKON, 0.1);
		FlxG.camera.followLead.set(10, 5);
		FlxG.camera.setScrollBounds(0, WORLDSIZE.width, 0, WORLDSIZE.height);
		FlxG.worldBounds.set(0, 0, WORLDSIZE.width, WORLDSIZE.height);
		
		
		
		super.create();
	}
	
	private function initHUD():Void
	{
		//THE BOOK SHIT
		_book = new Spellbook(0, FlxG.height, _player);
		_book.scrollFactor.set();
		add(_book);
		
		//THE ACTUAL HUD
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
					if (FlxG.random.bool(10))
					{
						var enemy:Enemy = new Bat(WORLDSIZE.width + FlxG.random.float(0, 60), FlxG.random.float(0, WORLDSIZE.height - 30));
						grpEnemies.add(enemy);
					}
					else
					{
						var enemy:Enemy = new Eyeball(WORLDSIZE.width + FlxG.random.float(0, 60), FlxG.random.float(0, WORLDSIZE.height - 30));
						grpEnemies.add(enemy);
					}
					
					
					
					enemiesLeft += 1;
				}
				
				waveTimer = 15;
			}
		}
		else
			txtWaveTime.visible = false;
	}

	private function shootBullet():Void
	{
		var dir:Int = 1;
		if (_player.facing == FlxObject.LEFT && _book.spells.get("goLeft")[2])
			dir = -1;
		
		var bullet:Bullet = new Bullet(_player.getMidpoint().x, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180));
		grpBullets.add(bullet);
		
		if (_book.spells.get("triple2")[2])
		{
			var bullet:Bullet = new Bullet(_player.getMidpoint().x, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180 - 30));
			grpBullets.add(bullet);
			
			var bullet:Bullet = new Bullet(_player.getMidpoint().x, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180 + 30));
			grpBullets.add(bullet);
		}
		
	}
	
	override public function update(elapsed:Float):Void
	{
		cameraHandle();
		
		if (_player.life <= 0)
			FlxG.resetState();
		
		if (FlxG.mouse.justPressed)
		{
			shootBullet();
			
			if (_book.spells.get("triple")[2])
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					shootBullet();
				}, 2);
			}
		}
		
		if (FlxG.keys.justPressed.E)
		{
			var goalY:Float = 0;
			var curEase;
			
			if (!_book.on && waveTimer > 0)
			{
				//FlxG.sound.play(AssetPaths.phoneOff__mp3, 0.7);
				goalY = 20;
				curEase = FlxEase.backOut;
			}
			else
			{
				goalY = FlxG.height + 160;
				curEase = FlxEase.backIn;
				//FlxG.sound.play(AssetPaths.phoneOn__wav, 0.7);
				
				//API.unlockMedal("MILLENIALS");
			}
			
			FlxTween.tween(_book, {y: goalY}, 0.5, {ease:curEase});
			
			_book.on = !_book.on;
		}
		
		super.update(elapsed);
		
		grpEnemies.forEachAlive(function(e:Enemy)
		{
			if (e.x <= -20)
				e.x = WORLDSIZE.width;
			
			switch(e.ETYPE)
			{
				case Enemy.BAT:
					FlxVelocity.moveTowardsObject(e, _player, e.speed);
			}
		});
		
		FlxG.overlap(grpBullets, grpEnemies, function(b:Bullet, e:Enemy)
		{
			e.life -= b.damage;
			e.velocity.x += b.velocity.x;
			e.velocity.y += b.velocity.y;
			
			b.kill();
			
			
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
				
				_player.life -= e.damageDone;
				_player.invincibleStart();
			}
		});
		
		var enCount:Int = 0;
		grpEnemies.forEachAlive(function(e:Enemy)
		{
			enCount += 1;
		});
		
		enemiesLeft = enCount;
		
		txtHUD.text = "Enemies left: " + enemiesLeft + " --- Wave: " + curWave + " --- LIFE: " + FlxMath.roundDecimal(_player.life, 2) * 100 + "%";
		generateEnemies();
	}
	
	private function cameraHandle():Void
	{
		//SHOUTOUT TO MIKE, AND ALSO BOMTOONS
		var dx = _player.getMidpoint().x - FlxG.mouse.x;
		var dy = _player.getMidpoint().y - FlxG.mouse.y;
		//var length = Math.sqrt(dx * dx + dy * dy);
		var camOffset = 0.4;
		dx *= camOffset;
		dy *= camOffset;
		_camTrack.x = _player.getMidpoint().x - dx;
		_camTrack.y = _player.getMidpoint().y - dy;
	}
}
