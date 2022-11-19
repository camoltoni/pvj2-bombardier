package;

import flixel.FlxSprite;
import Utils.SetTanks;
import PlayState.TankOptions;
import flixel.util.FlxTimer;
import flixel.FlxG;
import PlayState.BulletOptions;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;

class EnemySpawner extends FlxTypedGroup<ShooterActor>{
    
	static inline var AMPLITUDE:Float = 360.0;

	var _planeSFX:FlxSound;
    var _tanksArray:Array<TankOptions>;
	var _nexTank:TankOptions;
	var _bulletCallback:BulletOptions->Void;
	var _target:FlxSprite;

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

    public function new(bulletCallback:BulletOptions->Void, target:FlxSprite) {
        super();
		_bulletCallback = bulletCallback;
        startWaves();
        _tanksArray = SetTanks();
		_tanksArray.sort((a, b) -> {
			if (a.Y < b.Y)
				return -1;
			else if (a.Y > b.Y)
				return 1;
			else
				return 0;
		});
		_nexTank = _tanksArray.pop();
		_target = target;
    }

	override public function update(elapsed:Float) {
		if(_nexTank != null) {
			if(FlxG.camera.scroll.y - 32 < _nexTank.Y) {
				add(new Tank(_nexTank.X, _nexTank.Y, 
					_bulletCallback, 
					_nexTank.vertical, 
					_nexTank.length, 
					_target));
				_nexTank = _tanksArray.pop();
			}
		}
		super.update(elapsed);
	}

    function startWaves():Void {
        new FlxTimer().start(5, function(t:FlxTimer)
		{
			if (active)
			{
				waveLaunch();
			}
			else
			{
				t.destroy();
			}
		}, 0);

		_planeSFX = FlxG.sound.load(AssetPaths.plane__ogg);
		waveLaunch();
    }

	function waveLaunch()
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
			add(new Plane(start.x, start.y, _bulletCallback, AssetPaths.ship_0022__png, path));
			_planeSFX.play();
		}, 10);
	}

    function loadTanks() {
        
    }
}