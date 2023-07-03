package miniproject;

import javafx.scene.image.Image;

public class PlayerBlob extends Sprite {
	private final int BULLET_SPEED = 10;
	public final static Image BULLET_IMAGE = new Image("images/bullet.png",PlayerBlob.BULLET_WIDTH,PlayerBlob.BULLET_WIDTH,false,false);
	public final static int BULLET_WIDTH = 20;

	public PlayerBlob(int x, int y){
		super(x,y);
		this.loadImage(PlayerBlob.BULLET_IMAGE);
	}

	public void move(){
		this.x += BULLET_SPEED;
		if(this.x >= GameStage.WINDOW_WIDTH){
			this.visible = false;
		}
	}
}