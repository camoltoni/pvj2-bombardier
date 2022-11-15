package;

import PlayState.BulletOptions;
import flixel.FlxSprite;

class ShooterActor extends FlxSprite {

    var _bulletCallback:BulletOptions->Void;
    public function new(X:Float, Y:Float, ?bulletCallBak:BulletOptions->Void) {
        super(X, Y);
        _bulletCallback = bulletCallBak;
    }


    function shoot(options:BulletOptions):Void {
        _bulletCallback(options);
    }
}