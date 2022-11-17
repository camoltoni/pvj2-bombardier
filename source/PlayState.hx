package;

import flixel.system.FlxSound;
import Utils.GetLayer;
import Utils.SetObjects;
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

class PlayState extends FlxState
{
	static inline var SLOW_UPDATE_TIME:Float = 0.1;

	var _player:Player;
	var _enemies:FlxTypedGroup<ShooterActor>;
	var _actors:FlxGroup;
	var _updateCannonsTime:Float = SLOW_UPDATE_TIME;
	var _landingPoint:FlxPoint;
	var _planeSpawner:PlaneSpawner;
	var _powerUpSpawner:PowerUpSpawner;
	public var _bullets:FlxTypedGroup<Bullet>;
	var _hud:HUD;
	var _score:Int;
	var _enemyHitSFX:FlxSound;
	var _playerHitSFX:FlxSound;
	var _pickupSFX:FlxSound;

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

		_enemies = new FlxTypedGroup<ShooterActor>();
		_planeSpawner = new PlaneSpawner(_enemies, addBullet);
		SetObjects(_enemies, addBullet, cast(_player, FlxSprite));

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
/* 		if (_updateCannonsTime <= 0.0)
		{
			_enemies.forEachAlive((o:ShooterActor) ->
			{
				if (Std.isOfType(o, Tank))
				{
					var tank:Tank = cast(o, Tank);
					tank.updateCannon(_player.getPosition());
				}
			});
			_updateCannonsTime = SLOW_UPDATE_TIME;
		}
		_updateCannonsTime -= elapsed; */
		FlxG.overlap(_bullets, _actors, collideBulletActor);
		FlxG.overlap(_player, _powerUpSpawner, onPowerUp);

		if (FlxG.camera.scroll.y < _landingPoint.y)
			_player.landing = true;

		if (FlxG.camera.scroll.y <= 240+96) {
			_planeSpawner.active = false;
			_powerUpSpawner.spawn = false;
		}

		if (FlxG.camera.scroll.y < 240) {
			_player.landing = true;
			FlxG.state.openSubState(new PauseSubState());
		}

		super.update(elapsed);
	}

	function cameraTarget():Void
	{
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height * 4);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width, FlxG.height * 4);
		var target:FlxSprite = new FlxSprite();
		target.solid = false;
		target.makeGraphic(1, 1, FlxColor.RED, true);
		target.alpha = 0.0;
		target.screenCenter(X);
		target.y = FlxG.worldBounds.bottom - FlxG.height / 2.0;
		target.velocity.y = -30.0;

		FlxG.camera.follow(target, LOCKON);
		add(target);
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
					actor.health -= 1.0;
					_score += 100;
					_hud.setScore(_score);
					_enemyHitSFX.play();
					if (actor.health <= 0.0)
						actor.kill();
				}
				bullet.kill();
			}
			else if (bullet.owner == "Enemy")
			{
				if (Std.isOfType(actor, Player))
				{
					bullet.kill();
					actor.health -= 0.5;
					_playerHitSFX.play();
					if (actor.health <= 0.0)
					{
						actor.kill();
						FlxG.resetState();
					}
				}
			}
		}
	}

	function onPowerUp(player:Player, powerUp:PowerUp)
	{
		player.powerUpPicked(powerUp.type);
		_pickupSFX.play();
		powerUp.kill();
	}
}
