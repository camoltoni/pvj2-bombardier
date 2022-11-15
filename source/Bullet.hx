package;

import PlayState.BulletOptions;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var owner:String;

	public function new(options:BulletOptions)
	{
		super(options.X - 2.0, options.Y);
		owner = options.owner;
		velocity = options.vel;
		switch (owner)
		{
			case "Player":
				addPlayerBullet(options.type);
			case "Enemy":
				addEnemyBullet(options.type);
		}
	}

	override function update(elapsed:Float)
	{
		if (!isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}

	function addPlayerBullet(type:String)
	{
		type = "";
		switch (type)
		{
			case "simple":
			case "double":
			case "rocket":
			default:
				makeGraphic(4, 4, FlxColor.LIME);
		}
	}

	function addEnemyBullet(type:String)
	{
		var bcolor:FlxColor = null;
		switch (type)
		{
			case "plane":
				bcolor = FlxColor.RED;
			case "tank":
				bcolor = FlxColor.MAGENTA;
		}
		makeGraphic(4, 4, bcolor);
	}
}
