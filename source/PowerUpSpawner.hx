package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import haxe.EnumTools;

enum PowerUpType
{
	DOUBLE_FIRE;
	HEALTH;
	DOUBLE_RATE;
}

class PowerUpSpawner extends FlxTypedGroup<FlxSprite>
{
	public var spawn:Bool;
	var dropTimer:FlxTimer;
	var assets:Map<Int, String> = [
		0 => AssetPaths.tile_0001__png,
		1 => AssetPaths.tile_0024__png,
		2 => AssetPaths.tile_0025__png
	];

	public function new()
	{
		super();
		dropTimer = new FlxTimer().start(nextTime(), dropPowerUp, 0);
		spawn = true;
	}

	function dropPowerUp(t:FlxTimer)
	{
		if (spawn) {
			dropTimer.time = nextTime();
			var constructors:Array<String> = EnumTools.getConstructors(PowerUpType);
			var numType = FlxG.random.int(0, constructors.length - 1);
			var type:PowerUpType = [0 => PowerUpType.DOUBLE_FIRE, 1 => PowerUpType.HEALTH, 2 => PowerUpType.DOUBLE_RATE][numType];
			var path:String = assets[numType];
			var pos:FlxPoint = FlxPoint.get();
			pos.x = FlxG.random.float(16.0, FlxG.width - 32.0);
			pos.y = FlxG.camera.scroll.y - 16.0;
			add(new PowerUp(pos.x, pos.y, type, path));
		} else {
			t.destroy();
			kill();
		}
	}

	function nextTime():Float
	{
		return FlxG.random.float(2.5, 5.0);
	}
}
