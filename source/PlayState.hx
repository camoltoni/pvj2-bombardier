package;

import flixel.system.FlxSound;
import Utils.GetLayer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

typedef BulletOptions =
{
	X:Float,
	Y:Float,
	vel:FlxPoint,
	owner:String,
	type:String,
}

typedef TankOptions = 
{
	X:Float,
	Y:Float,
	vertical:Bool,
	length:Int,
}

class PlayState extends FlxState
{
	static inline var SLOW_UPDATE_TIME:Float = 0.1;

	var _player:Player;
	var _actors:FlxGroup;
	var _landingPoint:FlxPoint;
	var _powerUpSpawner:PowerUpSpawner;
	var _enemies:EnemySpawner;
	public var _bullets:FlxTypedGroup<Bullet>;
	var _hud:HUD;
	var _score:Int;
	var _enemyHitSFX:FlxSound;
	var _playerHitSFX:FlxSound;
	var _pickupSFX:FlxSound;
	var _target:FlxSprite;

	override public function create():Void
	{
		super.create();
		_score = 0;
		cameraTarget();
		add(GetLayer("water", AssetPaths.level01__tmx, AssetPaths.tiles_packed__png, "terrain"));
		add(GetLayer("isles", AssetPaths.level01__tmx, AssetPaths.tiles_packed__png, "terrain"));
		add(new FlxSprite(264, 40, AssetPaths.big_carrier__png));
		_landingPoint = FlxPoint.get(320, 90);

		_bullets = new FlxTypedGroup<Bullet>();
		add(_bullets);

		_powerUpSpawner = new PowerUpSpawner();
		add(_powerUpSpawner);
		_player = new Player(0, 0, addBullet);

		_enemies = new EnemySpawner(addBullet, _player);


		_actors = new FlxGroup();
		_actors.add(_player);
		_actors.add(_enemies);

		add(_actors);
		_hud = new HUD(_player);
		add(_hud);

		_enemyHitSFX = FlxG.sound.load(AssetPaths.enemykill__ogg);
		_playerHitSFX = FlxG.sound.load(AssetPaths.umph__ogg);
		_pickupSFX = FlxG.sound.load(AssetPaths.pickup__ogg);
		FlxG.sound.playMusic(AssetPaths.Pompy__ogg, 0.5);
	}

	override public function update(elapsed:Float):Void
	{

		FlxG.overlap(_bullets, _actors, collideBulletActor);
		FlxG.overlap(_player, _powerUpSpawner, onPowerUp);

		if(_enemies.spawn) {
			if(FlxG.camera.scroll.y <= 720) {
				_enemies.spawn = false;
				_powerUpSpawner.spawn = false;
			}
		}
		
		if(!_player.landing){
			if (FlxG.camera.scroll.y <= 480) {	
				_player.landing = true;
				_target.velocity.y *= 4;
				FlxG.state.openSubState(new PauseSubState());
			}
		}

		super.update(elapsed);
	}

	function cameraTarget():Void
	{
		FlxG.worldBounds.set(0, 0, FlxG.width, 140 * 16);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width, 140 * 16);
		_target = new FlxSprite();
		_target.solid = false;
		_target.makeGraphic(1, 1, FlxColor.RED, true);
		_target.alpha = 0.0;
		_target.screenCenter(X);
		_target.y = FlxG.worldBounds.bottom - FlxG.height / 2.0;
		_target.velocity.y = -30.0;

		FlxG.camera.follow(_target, LOCKON);
		add(_target);
		FlxG.camera.updateFollow();
	}

	function addBullet(options:BulletOptions):Void
	{
		_bullets.add(new Bullet(options));
	}

	function collideBulletActor(bullet:Bullet, actor:ShooterActor):Void
	{
		if (FlxG.pixelPerfectOverlap(bullet, actor))
		{
			if (bullet.owner == "Player")
			{
				if (_enemies.members.contains(actor))
				{
					actor.hurt(1.0);
					_score += 100;
					_hud.setScore(_score);
					_enemyHitSFX.play();
				}
				bullet.kill();
			}
			else if (bullet.owner == "Enemy")
			{
				if (Std.isOfType(actor, Player))
				{
					bullet.kill();
					actor.hurt(0.5);
					_playerHitSFX.play();
				}
			}
		}
	}

	function onPowerUp(player:Player, powerUp:PowerUp)
	{
		player.powerUpPicked(powerUp.type);
		_pickupSFX.play();
		powerUp.kill();
		_score += 500;
		_hud.setScore(_score);
	}
}
