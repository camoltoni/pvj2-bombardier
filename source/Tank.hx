package;

import flixel.util.FlxTimer;
import PlayState.BulletOptions;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;

class Tank extends ShooterActor
{
	static inline var FACTOR:Float = 0.5;
	static inline var BULLET_VEL:Float = 100.0;

	var _cannon:FlxSprite;
	var _added:Bool = false;

	var _cannonTarget:FlxSprite;
	var _cannonUpdateTimer:FlxTimer;

	public function new(?X:Float, ?Y:Float, bulletCallback:BulletOptions->Void, vertical:Bool, length:Int, target:FlxSprite)
	{
		super(X, Y, bulletCallback);
		loadGraphic(AssetPaths.tile_0029__png);
		_cannon = new FlxSprite(0, 0, AssetPaths.tile_0030__png);
		if (vertical)
		{
			angle = 90;
			FlxTween.linearMotion(this, x, y, x, length * 16.0 + y, length * FACTOR, true, {type: FlxTweenType.PINGPONG});
		}
		else
		{
			_cannon.angle = -90;
			FlxTween.linearMotion(this, x, y, x + length * 16.0, y, length * FACTOR, true, {type: FlxTweenType.PINGPONG});
		}
		health = 2.0;
		_cannonTarget = target;
		_cannonUpdateTimer = new FlxTimer().start(0.1, function(t:FlxTimer){
			updateCannon();
		}, 0);
	}

	override public function update(elapsed:Float)
	{
		if (!_added)
		{
			FlxG.state.add(_cannon);
			_added = true;
		}
		_cannon.setPosition(x, y);

		if (isOnScreen() && FlxG.random.float() < 0.003)
		{
			var rangle:Float = _cannon.angle * (Math.PI / 180);
			var xc = getGraphicMidpoint().x + Math.sin(rangle) * -_cannon.origin.x;
			var yc:Float = getGraphicMidpoint().y + Math.cos(rangle) * _cannon.origin.x;
			var vel:FlxPoint = FlxPoint.get(Math.sin(rangle) * -BULLET_VEL, Math.cos(rangle) * BULLET_VEL);
			_bulletCallback({
				X: xc,
				Y: yc,
				vel: vel,
				owner: "Enemy",
				type: "tank"
			});
		}
		if (y > FlxG.camera.scroll.y && !isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}

	override public function kill()
	{
		_cannon.kill();
		super.kill();
	}

	public function updateCannon()
	{
		var target:FlxVector = _cannonTarget.getPosition();
		if (FlxG.camera.containsRect(this.getScreenBounds()))
		{
			target = target.subtractPoint(getPosition());
			var degree = (Math.atan2(target.y, target.x));
			_cannon.angle = degree * 180 / Math.PI - 90;
		}
	}
}
