package entities {
	import net.flashpunk.RollbackableSpriteMap;
	import net.flashpunk.Rollbackable;
	import net.flashpunk.FP;
	
	import general.Utils;
	
	import entities.SpriteMapEntity;
	import entities.Bullet;
	
	public class Person extends SpriteMapEntity {
		//animation constants
		public static const WALK_DOWN_ANIMATION:String = "walkdown";
		public static const WALK_UP_ANIMATION:String = "walkup";
		public static const WALK_LEFT_ANIMATION:String = "walkleft";
		public static const WALK_RIGHT_ANIMATION:String = "walkright";
		
		//movement
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveUp:Boolean = false;
		private static const speed:Number = 4;
		
		//mouse
		private var _mouseDown:Boolean = false;
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		
		//collisions
		public static const COLLISION_TYPE:String = "person";
		
		//hp
		public var _hp:int = 10;
		
		public function Person(x:Number=0, y:Number=0, image:Class=null, w:uint=0, h:uint=0) {
			//super
			super(x, y, image, w, h);
			
			//animations
			sprite_map.add(WALK_DOWN_ANIMATION, [0, 1, 2], 10, true);
			sprite_map.add(WALK_RIGHT_ANIMATION, [3, 4, 5], 10, true);
			sprite_map.add(WALK_LEFT_ANIMATION, [6, 7, 8], 10, true);
			sprite_map.add(WALK_UP_ANIMATION, [9, 10, 11], 10, true);
			sprite_map.play(WALK_DOWN_ANIMATION);
			
			//collision type
			type = COLLISION_TYPE;
			
			//tint
			sprite_map.tintMode = 1.0;
			sprite_map.tinting = 0.2;
		}
		
		public function get mouseDown():Boolean {
			return _mouseDown;
		}
		
		public function set mouseDown(m:Boolean):void {
			//save
			_mouseDown = m;
			
			//determine if make bullet
			if (_mouseDown && world) {
				var bullet:Bullet = world.create(Bullet, true) as Bullet;
				bullet.x = centerX - bullet.halfWidth;
				bullet.y = centerY - bullet.halfHeight;
				bullet.calculateVector(mouseX, mouseY);
			}
		}
		
		public function get hp():int {
			return _hp;
		}
		
		public function set hp(hp:int):void {
			//save
			_hp = hp;
			
			//visual effect
			if (_hp > 0) {
				//tint
				sprite_map.tinting = (Number)(((1 - (hp * .1)) * 0.8) + 0.2);
			}else if(world) {
				//recycle
				world.recycle(this);
			}
		}
		
		override public function update():void {
			//super
			super.update();
			
			//prevent offscreen
			clampHorizontal(0, FP.width);
			clampVertical(0, FP.height);
			
			//movement
			var moveX:Number = 0;
			var moveY:Number = 0;
			if (moveUp)
				moveY -= speed;
			if (moveDown)
				moveY += speed;
			if (moveLeft)
				moveX -= speed;
			if (moveRight)
				moveX += speed;
			
			//move and prevent overlap
			moveBy(moveX, moveY, COLLISION_TYPE, false);
			
			//face the mouse
			switch(Utils.direction(centerX, centerY, mouseX, mouseY)) {
				case 7:
				case 8:
				case 9:
					if(sprite_map.currentAnim != WALK_UP_ANIMATION)
						sprite_map.play(WALK_UP_ANIMATION);
					break;
				case 4:
					if(sprite_map.currentAnim != WALK_LEFT_ANIMATION)
						sprite_map.play(WALK_LEFT_ANIMATION);
					break;
				case 1:
				case 2:
				case 3:
					if(sprite_map.currentAnim != WALK_DOWN_ANIMATION)
						sprite_map.play(WALK_DOWN_ANIMATION);
					break;
				case 6:
					if(sprite_map.currentAnim != WALK_RIGHT_ANIMATION)
						sprite_map.play(WALK_RIGHT_ANIMATION);
					break;
				default:
					break;
			}
			
			//if no force, stop walking
			if (!moveUp && !moveDown && !moveLeft && !moveRight)
				sprite_map.setAnimFrame(sprite_map.currentAnim, 1);
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var p:Person = orig as Person;
			
			//rollback
			moveDown = p.moveDown;
			moveUp = p.moveUp;
			moveLeft = p.moveLeft;
			moveRight = p.moveRight;
			_mouseDown = p._mouseDown;
			mouseX = p.mouseX;
			mouseY = p.mouseY;
		}
	}
}