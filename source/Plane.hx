package;

import PlayState.BulletOptions;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Plane extends ShooterActor
{
	var _tween:FlxTween;
	var _atween:FlxTween;

	static inline var AMPLITUDE:Float = 300.0;
	static inline var DURATION = 3.0;

	var _last:FlxPoint;

	public function new(X:Float, Y:Float, bulletCallback:BulletOptions->Void, graphic:FlxGraphicAsset, ?path:Array<FlxPoint>)
	{
		super(X, Y, bulletCallback);
		loadGraphic(graphic);
		_last = FlxPoint.get(x, y);
		var newPath:Array<FlxPoint> = [];
		if (path != null)
		{
			newPath.push(FlxPoint.get(x, y));
			for (p in path)
			{
				newPath.push(FlxPoint.get(x + p.x, y + p.y));
			}
		}
		else
		{
			newPath = [
				FlxPoint.get(x, y),
				FlxPoint.get(x + AMPLITUDE / 4.0, y + AMPLITUDE),
				FlxPoint.get(x + AMPLITUDE / 2.0, y),
			];
		}

		var options:TweenOptions = {type: ONESHOT, ease: FlxEase.linear, onComplete: tweenCallback};
		_tween = FlxTween.quadPath(this, newPath, DURATION, true, options);
		_tween.start();
		new FlxTimer().start(.05, timerCallback, 0);
	}

	function timerCallback(?t:FlxTimer)
	{
		_last = _last.subtractPoint(FlxPoint.get(x, y));
		var degree = (Math.atan2(_last.y, _last.x));
		if (cast(_last, FlxVector).lengthSquared > 0.0)
			angle = degree * 180 / Math.PI - 90;
		_last = FlxPoint.get(x, y);
	}

	function tweenCallback(tween:FlxTween)
	{
		kill();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.random.float() < 0.02 && getScreenPosition().y > 16 && getScreenPosition().y < FlxG.height / 4.0)
		{
			var bo:BulletOptions = {
				X: getGraphicMidpoint().x,
				Y: getGraphicMidpoint().y,
				vel: FlxPoint.get(0, 200),
				owner: "Enemy",
				type: "plane"
			};
			shoot(bo);
		}
		super.update(elapsed);
	}
}
