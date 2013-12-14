import com.haxepunk.HXP;
import com.haxepunk.tmx.TmxEntity;

class Level
{
	public function new (name:String)
	{
		var e = new TmxEntity("maps/"+name+".tmx");		
		e.loadGraphic("graphics/basictiles.png", ["layer1"]);
		e.loadMask("collisions", "walls");
		HXP.scene.add(e);
		
		HXP.scene.add(new Player(10, 10));
	}
}
