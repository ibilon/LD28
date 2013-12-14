import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

typedef Point = { x:Int, y:Int };

class Player extends Entity
{
	public function new (x:Int, y:Int, dir="down")
	{
		super();
		
		pos = { x: x, y: y };
		direction = dir;
		moving = false;
		
		img = new Spritemap("graphics/player.png", 16, 16);
		img.add("down", [0, 1], 4);
		img.add("right", [2, 3], 4);
		img.add("up", [4, 5], 4);
		img.add("left", [6, 7], 4);
		img.play(direction);
		
		graphic = img;		
		setHitbox(16, 16);
	}
	
	override public function update ()
	{
		super.update();
		
		if (!moving)
		{
			var dir = "";
			
			if (Input.check(Key.UP))
				dir = "up";
			if (Input.check(Key.DOWN))
				dir = "down";
			if (Input.check(Key.LEFT))
				dir = "left";
			if (Input.check(Key.RIGHT))
				dir = "right";
				
			if (dir != "")
			{
				img.play(dir);
				move(dir);
			}
		}
		else // moving
		{
			moveBy(moveTween.x*16 - x, moveTween.y*16 - y, ["walls"]);
		}
	}
	
	private function move (dir:String)
	{
		moving = true;
		
		var dx:Int = 0;
		var dy:Int = 0;
		
		switch (dir)
		{
			case "up":
				dy = 1;
			case "down":
				dy = -1;
			case "left":
				dx = 1;
			case "right":
				dx = -1;
		}
		
		
		dest = { x: pos.x-dx, y: pos.y-dy };
		
		moveTween = new LinearMotion(moveComplete);
		moveTween.setMotion(pos.x, pos.y, dest.x, dest.y, 0.3);
		scene.addTween(moveTween);
	}
	
	private function moveComplete (_)
	{
		var centerFrom = { x: pos.x*16 + 8, y: pos.y*16+8 };
		var centerTo = { x: dest.x*16 + 8, y: dest.y*16+8 };
		var distFrom = (x+8 - centerFrom.x)*(x+8 - centerFrom.x) + (y+8 - centerFrom.y)*(y+8 - centerFrom.y);
		var distTo = (x+8 - centerTo.x)*(x+8 - centerTo.x) + (y+8 - centerTo.y)*(y+8 - centerTo.y);
		
		if (distFrom > distTo) // made it
			pos = dest;
		else // couldn't move
			pos = pos;
		
		moving = false;
	}
	
	private var direction:String;
	private var img:Spritemap;
	private var moving:Bool;
	@:isVar private var pos(default, set_pos):Point;
	private function set_pos(v:Point)
	{
		x = v.x * 16;
		y = v.y * 16;
		return pos = v;
	}
	private var dest:Point;
	private var moveTween:LinearMotion;
}
