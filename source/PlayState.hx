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
	private var waveTimer:Float = 13;
	
	private var txtWaveTime:FlxText;
	
	private var grpBullets:FlxTypedGroup<Bullet>;
	private var grpEnemies:FlxTypedGroup<Enemy>;
	
	private var txtHUD:FlxText;
	private var grpHUD:FlxSpriteGroup;
	
	private var WORLDSIZE:FlxRect;
	
	private var _book:Spellbook;
	private var walls:FlxGroup;
	private var sideWallsLol:FlxGroup;
	
	private var _camTrack:FlxObject;
	private var grpPixies:FlxTypedGroup<Pixie>;
	private var pixieSpawned:Bool = false;
	
	override public function create():Void
	{
		WORLDSIZE = new FlxRect(0, 0, FlxG.width * 4, FlxG.height * 4);
		
		initEnvironment();
		
		_player = new Player(WORLDSIZE.width / 2, WORLDSIZE.height / 2);
		add(_player);
		
		grpEnemies = new FlxTypedGroup<Enemy>();
		add(grpEnemies);
		
		grpPixies = new FlxTypedGroup<Pixie>();
		add(grpPixies);
		
		grpBullets = new FlxTypedGroup<Bullet>();
		add(grpBullets);
		
		initHUD();
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		FlxG.camera.focusOn(_player.getPosition());
		
		FlxG.camera.follow(_camTrack, FlxCameraFollowStyle.LOCKON, 0.1);
		FlxG.camera.followLead.set(10, 5);
		FlxG.camera.setScrollBounds(0, WORLDSIZE.width, 500, WORLDSIZE.height);
		FlxG.worldBounds.set(0, 0, WORLDSIZE.width, WORLDSIZE.height);
		
		walls = new FlxGroup();
		add(walls);
		
		sideWallsLol = new FlxGroup();
		add(walls);
		
		var floor:FlxObject = new FlxObject(0, WORLDSIZE.height - 2, WORLDSIZE.width, 2);
		floor.immovable = true;
		walls.add(floor);
		
		var ceil:FlxObject = new FlxObject(0, 500, WORLDSIZE.width, 2);
		ceil.immovable = true;
		walls.add(ceil);
		
		var leftWall:FlxObject = new FlxObject(0, 0, 2, WORLDSIZE.height);
		leftWall.immovable = true;
		sideWallsLol.add(leftWall);
		
		var rightWall:FlxObject = new FlxObject(WORLDSIZE.width - 2, 0, 2, WORLDSIZE.height);
		rightWall.immovable = true;
		sideWallsLol.add(rightWall);
		
		
		super.create();
	}
	
	private function initEnvironment():Void
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.bg__png);
		bg.scrollFactor.set(0.1, 0.2);
		/*bg.setGraphicSize(Std.int(WORLDSIZE.width), Std.int(WORLDSIZE.height));
		bg.updateHitbox();*/
		add(bg);
		
		var clouds1:FlxSprite = new FlxSprite(0, WORLDSIZE.height * 0.2).loadGraphic(AssetPaths.cloudsLong__png);
		clouds1.scrollFactor.set(0.35, 0.35);
		clouds1.alpha = 0.6;
		add(clouds1);
		FlxTween.tween(clouds1, {x: FlxG.width * 0.5}, 40, {type:FlxTweenType.PINGPONG});
		
		var moreCloudsLol:FlxSprite = new FlxSprite(0, WORLDSIZE.height * 0.1).loadGraphic(AssetPaths.cloudsFew__png);
		moreCloudsLol.setGraphicSize(Std.int(moreCloudsLol.width * 0.6));
		moreCloudsLol.updateHitbox();
		moreCloudsLol.scrollFactor.set(0.25, 0.25);
		moreCloudsLol.alpha = 0.4;
		add(moreCloudsLol);
		FlxTween.tween(moreCloudsLol, {x: FlxG.width * 0.3}, 40, {type:FlxTweenType.PINGPONG});
		
		var bg1:FlxSprite = new FlxSprite(0, WORLDSIZE.height * 0.04).loadGraphic(AssetPaths.bg1point2__png);
		bg1.scrollFactor.set(0.45, 0.45);
		add(bg1);
		
		var clouds2:FlxSprite = new FlxSprite(0, WORLDSIZE.height * 0.35).loadGraphic(AssetPaths.cloudsFew__png);
		clouds2.flipX = true;
		clouds2.scrollFactor.set(0.52, 0.52);
		clouds2.alpha = 0.7;
		add(clouds2);
		FlxTween.tween(clouds2, {x: FlxG.width * 0.6}, 40, {type:FlxTweenType.PINGPONG});
		
		var bg2:FlxSprite = new FlxSprite(0, WORLDSIZE.height * 0.45).loadGraphic(AssetPaths.bg2__png);
		bg2.scrollFactor.set(0.60, 0.60);
		add(bg2);
		
		
		
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
	
	private var introSong:Bool = false;
	private function generateEnemies():Void
	{
		if (enemiesLeft == 0)
		{
			if (waveTimer >= 0)
			{
				if (!introSong)
				{
					introSong = true;
					FlxG.sound.playMusic(AssetPaths.intro__mp3, 1, false);
				}
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
					if (FlxG.random.bool(20))
					{
						var enemy:Bat = new Bat(WORLDSIZE.width + FlxG.random.float(0, 60), FlxG.random.float(150, WORLDSIZE.height - 180));
						grpEnemies.add(enemy);
					}
					else
					{
						var enemy:Eyeball = new Eyeball(WORLDSIZE.width + FlxG.random.float(0, 60), _player.y + FlxG.random.float(-300, 300));
						grpEnemies.add(enemy);
					}
					
					
					
					enemiesLeft += 1;
				}
				
				FlxG.sound.playMusic(AssetPaths.Cute_Witch_Bitch_69_loopable_new_drums__mp3, 1);
				FlxG.sound.music.time = 40400;
				FlxG.sound.music.fadeIn(0.3, 0.5, 1);
				waveTimer = 15;
			}
		}
		else
			txtWaveTime.visible = false;
	}

	private function shootBullet(isMultiple:Bool = false):Void
	{
		if (_player.shootingCoolDown <= 0 || isMultiple)
		{
			var dir:Int = 1;
			if (_player.facing == FlxObject.LEFT)
				dir = -1;
			
			var xOffset:Float = -90;
			
			var bullet:Bullet = new Bullet(_player.getMidpoint().x + xOffset, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180));
			grpBullets.add(bullet);
			
			if (_book.spells.get("triple2")[2])
			{
				var bullet:Bullet = new Bullet(_player.getMidpoint().x + xOffset, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180 - 30));
				grpBullets.add(bullet);
				
				var bullet:Bullet = new Bullet(_player.getMidpoint().x + xOffset, _player.getMidpoint().y - 50, 700 * dir, FlxAngle.asRadians(180 + 30));
				grpBullets.add(bullet);
			}
			_player.shootingCoolDown = 0.3;
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		cameraHandle();
		
		if (!pixieSpawned)
		{
			if (_book.spells.get("pixie")[2])
			{
				pixieSpawned = true;
				var pix:Pixie = new Pixie( -10, -10, _player);
				grpPixies.add(pix);
			}
		}
		
		_player.canBoost = _book.spells.get("boost")[2];
		
		FlxG.collide(walls, _player);
		FlxG.collide(sideWallsLol, _player);
		FlxG.collide(walls, grpEnemies);
		
		if (_player.life <= 0)
			FlxG.resetState();
		
		if (FlxG.mouse.justPressed)
		{
			shootBullet();
			
			if (_book.spells.get("triple")[2])
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					shootBullet(true);
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
				FlxG.sound.play(AssetPaths.bookOpen__mp3, 0.7);
			}
			else
			{
				goalY = FlxG.height + 160;
				curEase = FlxEase.backIn;
				FlxG.sound.play(AssetPaths.bookClose__mp3, 0.7);
				//FlxG.sound.play(AssetPaths.phoneOn__wav, 0.7);
				
				//API.unlockMedal("MILLENIALS");
			}
			
			FlxTween.tween(_book, {y: goalY}, 0.5, {ease:curEase});
			
			
			
			_book.on = !_book.on;
			
			
		}
		
		super.update(elapsed);
		
		grpEnemies.forEachAlive(function(e:Enemy)
		{
			if (e.x <= -50)
			{
				e.y = _player.y + FlxG.random.float( -300, 300);
				e.x = WORLDSIZE.width;
			}
			if (e.x >= WORLDSIZE.width + 60)
			{
				e.x = -20;
				e.y = _player.y + FlxG.random.float( -300, 300);
			}
			
			switch(e.ETYPE)
			{
				case Enemy.BAT:
					FlxVelocity.moveTowardsPoint(e, _player.getMidpoint(), e.speed);
			}
		});
		
		FlxG.overlap(grpBullets, grpEnemies, function(b:Bullet, e:Enemy)
		{
			e.life -= b.damage;
			e.velocity.x += b.velocity.x;
			e.velocity.y += b.velocity.y;
			
			if (e.life <= 0)
			{
				var corpse:Corpse = new Corpse(e.x, e.y);
				corpse.velocity.x += b.velocity.x * 0.4;
				corpse.velocity.y -= 460;
				corpse.angularVelocity = corpse.velocity.x * 1.7;
				add(corpse);
			}
			
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
				
				pulseShit *= 0.5;
				e.velocity.y -= ydir * pulseShit;
				e.velocity.x -= xdir * pulseShit;
				
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
