package miniproject;

import java.util.Random;
import javafx.scene.image.Image;

public class yeet extends Sprite {
	public final static Image BLOB_IMAGE = new Image("images/poro.png",EnemyBlob.BLOB_WIDTH,EnemyBlob.BLOB_WIDTH,false,false);
	public final static int BLOB_WIDTH=50;
	private boolean alive;
	//attribute that will determine if a fish will initially move to the right part of the screen


	yeet(int x, int y){
		super(x,y);
		this.alive = true;
		this.loadImage(yeet.BLOB_IMAGE);
	}

//	public void checkCollision(Ship ship){
//		for	(int i = 0; i < ship.getBullets().size(); i++)	{
//			if (this.collidesWith(ship.getBullets().get(i))){
//				ship.getBullets().get(i).setVisible(false);
//				System.out.println(">>>>>>is hit by bullet");
//				this.alive = false;
//			}
//		}
//		if(this.collidesWith(ship)){
//			ship.die();
//			this.alive = false;
//		}
//	}

	//getter
	public boolean isAlive() {
		return this.alive;
	}
}
