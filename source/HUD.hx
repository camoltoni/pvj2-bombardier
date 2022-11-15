package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;

class HUD extends FlxTypedGroup<FlxObject>
{
	static inline var BORDER_COLOR:Int = 0x88434A5F;
	var _scoreText:FlxText;
	public function new(player:Player)
	{
		super();

		var _coolingBar:FlxBar = new FlxBar(
			10, 10, 
			LEFT_TO_RIGHT, 
			80, 18, 
			player, "hot", 
			0, 20);
		_coolingBar.createFilledBar(0x00000000, 0x99DC143C);
		_coolingBar.numDivisions = 20;
		add(_coolingBar);

		var _lifeBar:FlxBar = new FlxBar(
			0, 10,
			LEFT_TO_RIGHT, 
			80, 16, 
			player, "health", 
			0, 5);

		_lifeBar.createImageBar(null, AssetPaths.lifes__png, 0x00000000, 0x00000000);
		_lifeBar.alpha = 0.5;
		_lifeBar.x = FlxG.worldBounds.right - _lifeBar.width - 10;
		add(_lifeBar);
		
		var box:FlxShapeBox = new FlxShapeBox(
			_lifeBar.x - 1, _lifeBar.y - 1, 
			_lifeBar.width + 2, _lifeBar.height + 2, 
			{thickness: 2, color: BORDER_COLOR},
			0x00000000);
		add(box);

		box = null;

		box = new FlxShapeBox(
			_coolingBar.x - 1, _coolingBar.y - 1, 
			_coolingBar.width + 2, _coolingBar.height, 
			{thickness: 2, color: BORDER_COLOR},
			0x00000000);
		add(box);

		_scoreText = new FlxText(0, 0, 0, "0", 24, false);
		_scoreText.screenCenter(X);
		_scoreText.y = 10;
		_scoreText.font = AssetPaths.BlackOpsOne_Regular__ttf;
		_scoreText.alignment = CENTER;
		_scoreText.borderColor = BORDER_COLOR;
		_scoreText.borderSize = 2.0;
		_scoreText.borderStyle = OUTLINE;
		add(_scoreText);

		forEach(function(obj) obj.scrollFactor.set(0, 0));
	}

	public function setScore(score:Int):Void {
		_scoreText.text = Std.string(score);
	}
}
