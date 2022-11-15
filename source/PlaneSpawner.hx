package;

import flixel.system.FlxSound;
import PlayState.BulletOptions;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class PlaneSpawner
{
	static inline var AMPLITUDE:Float = 360.0;

	var _enemies:FlxTypedGroup<ShooterActor>;
	public var active(default, default):Bool;
	var _planeSFX:FlxSound;

	var _paths:Array<Array<FlxPoint>> = [
		[
			FlxPoint.get(AMPLITUDE / 4.0, AMPLITUDE * 2.2),
			FlxPoint.get(AMPLITUDE / 2.0, -128)
		],
		[
			FlxPoint.get(-AMPLITUDE / 4.0, AMPLITUDE * 2.2),
			FlxPoint.get(-AMPLITUDE / 2.0, -128)
		],
		[
			FlxPoint.get(-AMPLITUDE / 3.0, AMPLITUDE * 1.2),
			FlxPoint.get(AMPLITUDE * 2.0, AMPLITUDE)
		],
		[
			FlxPoint.get(AMPLITUDE / 3.0, AMPLITUDE * 1.2),
			FlxPoint.get(-AMPLITUDE * 2.0, AMPLITUDE)
		],
	];

	public function new(enemies:FlxTypedGroup<ShooterActor>, bulletCallback:BulletOptions->Void)
	{
		active = true;
		_enemies = enemies;
		new FlxTimer().start(5, function(t:FlxTimer){
			if(active) {
				waveLaunch(bulletCallback);
			}else{
				t.destroy();
			}
		}, 0);
		
		_planeSFX = FlxG.sound.load(AssetPaths.plane__ogg);

		waveLaunch(bulletCallback);
	}

	function waveLaunch(bulletCallback:BulletOptions->Void)
	{
		var pathNumber:Int = FlxG.random.int(0, _paths.length - 1);
		var path:Array<FlxPoint> = _paths[pathNumber];
		var half:Float = FlxG.width / 2.0;
		var separation:Float = half / 4.0;
		var line:Float = FlxG.random.float(1, 3);
		var start:FlxPoint = FlxPoint.get(separation * line, FlxG.camera.scroll.y - 96);
		start.x += half * (pathNumber % 2);
		new FlxTimer().start(0.3, (t:FlxTimer) ->
		{
			_enemies.add(new Plane(start.x, start.y, bulletCallback, AssetPaths.ship_0022__png, path));
			_planeSFX.play();
		}, 10);
	}
}
