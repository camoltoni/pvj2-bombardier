package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;

/*
 * Custom Pause Scene I made for my game.
 */
class PauseSubState extends FlxSubState
{
	public var pauseText:FlxText;

	public function new()
	{
		super(0xbb333333);
	}

	override public function create()
	{
		FlxG.mouse.visible = true;
		pauseText = new FlxText(0, 0, -1, 'YOU WIN!\n<enter> Restart', 40);
		pauseText.screenCenter();
		pauseText.alignment = CENTER;
		pauseText.y -= 30;
		pauseText.scrollFactor.set(0, 0);

		add(pauseText);

		FlxG.state.persistentUpdate = true;
		FlxG.state.persistentDraw = true;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			close();
			FlxG.resetState();
		}
	}
}
