package;

import PowerUpSpawner.PowerUpType;
import flixel.FlxG;
import flixel.FlxSprite;

class PowerUp extends FlxSprite
{
	public var type(default, null):PowerUpType;

	public function new(X:Float, Y:Float, type:PowerUpType, path:String)
	{
		super(X, Y);
		loadGraphic(path);
		this.type = type;
        velocity.set(0, 150.0);
	}

	override public function update(elapsed:Float)
	{
		if (!isOnScreen() && y > FlxG.camera.scroll.y){
            kill();
		}
		super.update(elapsed);
	}
}
