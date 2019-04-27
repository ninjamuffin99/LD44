package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;

class PlayState extends FlxState
{
	private var _player:Player;
	
	private var enemiesLeft:Int = 0;
	private var curWave:Int = 0;
	
	private var grpBullets:FlxTypedGroup<Bullet>;
	private var grpEnemies:FlxTypedGroup<Enemy>;
	
	override public function create():Void
	{
		_player = new Player(20, 20);
		add(_player);
		
		grpEnemies = new FlxTypedGroup<Enemy>();
		add(grpEnemies);
		
		grpBullets = new FlxTypedGroup<Bullet>();
		add(grpBullets);
		
		generateEnemies();
		
		super.create();
	}
	
	private function generateEnemies():Void
	{
		if (enemiesLeft == 0)
		{
			curWave += 1;
			while (enemiesLeft < Std.int(FlxG.random.float(8 * curWave * 0.7, 12 * (curWave * 0.7))))
			{
				var enemy:Enemy = new Eyeball(FlxG.width, FlxG.random.int(0, FlxG.height - 30));
				grpEnemies.add(enemy);
				
				enemiesLeft += 1;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed)
		{
			var bullet:Bullet = new Bullet(_player.x, _player.y, 400, FlxAngle.asRadians(180));
			grpBullets.add(bullet);
		}
		
		
		super.update(elapsed);
		
		FlxG.overlap(grpBullets, grpEnemies, function(b:Bullet, e:Enemy)
		{
			b.kill();
			e.kill();
		});
		
	}
}
