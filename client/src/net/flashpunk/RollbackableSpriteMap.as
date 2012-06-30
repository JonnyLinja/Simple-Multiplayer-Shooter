package net.flashpunk {
	import net.flashpunk.Rollbackable;
	import net.flashpunk.graphics.Spritemap;
	
	public class RollbackableSpriteMap extends Spritemap implements Rollbackable {
		public function RollbackableSpriteMap(source:*, frameWidth:uint = 0, frameHeight:uint = 0, callback:Function = null) {
			super(source, frameWidth, frameHeight, callback);
		}
		
		public function rollback(orig:Rollbackable):void {
			//declare variables
			var s:Spritemap = orig as Spritemap;
			
			//animation frame
			if (s.currentAnim) {
				play(s.currentAnim);
				index = s.index;
			}else
				frame = s.frame;
		}
	}
}