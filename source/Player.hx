package;

import flixel.system.FlxSound;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import PlayState.BulletOptions;
import PowerUpSpawner.PowerUpType;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;

class Player extends ShooterActor
{
	static inline var PLAYER_VEL:Float = 200.0;
	static inline var CONSTANT_VEL:Float = -20.0;
	static inline var MAX_HEALTH:Float = 5.0;
	static inline var FIRE_RATE:Float = 0.15;

	var _shootTimer:FlxTimer;
	var _shooting:Void->Void;
	var _ratio:Float;
	var _shootSFX:FlxSound;
	var _overheatingSFX:FlxSound;
	public var landing:Bool;
	public var hot:Float = 0.0;

	public function new(X:Float = 0, Y:Float = 0, bulletCallback:BulletOptions->Void)
	{
		super(X, Y, bulletCallback);
		loadGraphic(AssetPaths.ship_0005__png);
		health = 100;
		screenCenter(FlxAxes.X);
		y = FlxG.worldBounds.bottom - height * 1.5;
		_shootTimer = new FlxTimer().start(FIRE_RATE, function(t:FlxTimer)
		{
			_shooting();
			_shootSFX.play();
			hot++;
			if (hot > 20) {
				_overheatingSFX.play();
				t.active = false;
			}
		}, 0);
		_shootTimer.active = false;
		health = MAX_HEALTH;
		_shooting = singleShoot;
		landing = false;
		_ratio = 0.0;
		_shootSFX = FlxG.sound.load(AssetPaths.shoot__ogg);
		_overheatingSFX = FlxG.sound.load(AssetPaths.overheating__ogg);
	}

	override public function update(elapsed:Float)
	{
		if (landing) {
			x = FlxMath.lerp(x, FlxG.worldBounds.width / 2 - origin.x, _ratio * 5.0);
			y = FlxMath.lerp(y, 112, _ratio);
			_ratio += elapsed / 200.0;
			if (hot > 0.0)
				hot = 0.0;
			if(_shootTimer.active)
				_shootTimer.cancel();
			if(velocity.x != 0.0 || velocity.y != 0.0)
				velocity.set();
		} else {
			var vel:FlxPoint = FlxPoint.get();

			if (FlxG.keys.anyPressed([UP, W]))
				vel.y -= PLAYER_VEL;
			if (FlxG.keys.anyPressed([DOWN, S]))
				vel.y += PLAYER_VEL;
			if (FlxG.keys.anyPressed([LEFT, A]))
				vel.x -= PLAYER_VEL;
			if (FlxG.keys.anyPressed([RIGHT, D]))
				vel.x += PLAYER_VEL;
			if (FlxG.keys.justPressed.SPACE && hot < 20)
				_shootTimer.active = true;
			if (FlxG.keys.justReleased.SPACE)
				_shootTimer.active = false;

			if (FlxG.keys.released.SPACE && hot > 0)
				hot -= elapsed * 20.0;
			velocity = vel;

			x = Math.max(0, Math.min(x, FlxG.width - width));
			y = Math.max(FlxG.camera.scroll.y, Math.min(y, FlxG.camera.scroll.y + FlxG.height - height));
		}
		super.update(elapsed);
	}

	public function powerUpPicked(type:PowerUpType)
	{
		switch (type)
		{
			case DOUBLE_FIRE:
				powerUpDoubleFire();
			case HEALTH:
				powerUpHealth();
			case DOUBLE_RATE:
				powerUpDoubleRate();
		}
	}

	function powerUpDoubleFire()
	{
		_shooting = doubleShoot;
		new FlxTimer().start(4.0, function(t:FlxTimer)
		{
			_shooting = singleShoot;
		});
	}

	function powerUpHealth():Void
	{
		if (health < MAX_HEALTH)
		{
			health += 0.5;
		}
	}

	function powerUpDoubleRate()
	{
		_shootTimer.time = FIRE_RATE / 2.0;
		new FlxTimer().start(4.0, function(t:FlxTimer)
		{
			_shootTimer.time = FIRE_RATE;
		});
	}

	function singleShoot():Void
	{
		shoot({
			X: x + this.origin.x,
			Y: y + 3.0,
			vel: FlxPoint.get(0, -500),
			owner: "Player",
			type: "simple"
		});
	}

	function doubleShoot():Void
	{
		var space:Float = width / 4.0;
		shoot({
			X: x + space * 1.0,
			Y: y + 3.0,
			vel: FlxPoint.get(0, -500),
			owner: "Player",
			type: "double"
		});
		shoot({
			X: x + space * 3.0,
			Y: y + 3.0,
			vel: FlxPoint.get(0, -500),
			owner: "Player",
			type: "double"
		});
	}
}
