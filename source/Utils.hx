package;

import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;

function GetLayer(name:String, path:String, tiles:String, tilesetName:String):FlxTilemap
{
	var map = new FlxTilemap();
	var tiledMap:TiledMap;
	tiledMap = new TiledMap(path);
	var layer:TiledTileLayer = cast(tiledMap.getLayer(name), TiledTileLayer);
	map.loadMapFromArray(layer.tileArray, tiledMap.width, tiledMap.height, tiles, tiledMap.tileWidth, tiledMap.tileHeight, FlxTilemapAutoTiling.OFF,
		tiledMap.tilesets[tilesetName].firstGID);
	return map;
}

function SetObjects(tanks:FlxTypedGroup<ShooterActor>, bulletCallback, target:FlxSprite)
{
	var tiledMap = new TiledMap(AssetPaths.level01__tmx);
	var objectLayer = cast(tiledMap.getLayer("tanks"), TiledObjectLayer);

	for (o in objectLayer.objects)
	{
		if (o.type == "Tank")
		{
			var vertical:Bool = o.properties.get("vertical") == "true";
			var length:Int = Std.parseInt(o.properties.get("length"));
			tanks.add(new Tank(o.x, o.y - 16, bulletCallback, vertical, length, target));
		}
	}
}
