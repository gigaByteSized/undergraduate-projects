package miniproject;

import java.util.Random;

import javafx.scene.image.Image;

public class EnemyBlob extends Sprite {
	public final static Image BLOB_IMAGE = new Image("images/enemy.png",EnemyBlob.BLOB_WIDTH,EnemyBlob.BLOB_WIDTH,false,false);
	public final static int BLOB_WIDTH=40;
	private boolean alive;
	//attribute that will determine if a fish will initially move to the right part of the screen
	private int direction;


	EnemyBlob(int x, int y){
		super(x,y);
		this.alive = true;
		this.loadImage(EnemyBlob.BLOB_IMAGE);


		/*
		 *Randomize speed of fish and moveRight's initial value
		 */

		Random r = new Random();
		this.direction = r.nextInt(4)+1;
		this.speed = 120/BLOB_WIDTH;

	}

	//method that changes the x position of the fish
	void move(double start){
		Random r = new Random();

		double timeElapsed = (System.nanoTime() - start) / 1_000_000_000.0;
		if((int) (timeElapsed * 10 % 10) == 0 ){
			if((int) (timeElapsed % (r.nextInt(5)+1)*(this.width/4) ) == 0)this.direction = r.nextInt(4)+1;
		}

		// Sets dx and dy relative to random location
		if(this.direction == 1) this.dy = this.speed;
		else if(this.direction == 2) this.dx = this.speed;
		else if(this.direction == 3) this.dy = -this.speed;
		else this.dx = -this.speed;

		if(this.x+this.dx <= GameStage.WORLD_WIDTH-this.width && this.x+this.dx >= 0 && this.y+this.dy <= GameStage.WORLD_HEIGHT-this.width && this.y+this.dy >=0){
			this.x += this.dx;
    		this.y += this.dy;
    	} else if(this.x+this.dx <= 0){
			this.dx *= -1;
		} else if(this.y+this.dy <= 0){
			this.dy *= -1;
		}else if(this.x+this.dx >= GameStage.WORLD_WIDTH-this.width){
			this.dx *= -1;
			this.x = (int) (GameStage.WORLD_WIDTH-this.width);
		} else if(this.y+this.dy >= GameStage.WORLD_HEIGHT-this.height){
			this.dy *= -1;
			this.y = (int) (GameStage.WORLD_HEIGHT-this.height);
		}	// Prevents enemy from "getting stuck on borders"

	}

	public void checkCollision(Sprite sprite){
		if(this.collidesWith(sprite)){
			if(sprite.isPlayer()){
				if(this.width < sprite.width){
					sprite.grow((int)this.width);
					if(!sprite.isImmune()) sprite.loadImage(new Image("images/player.png", sprite.width, sprite.height,false,false));
					else sprite.loadImage(new Image("images/immunity.png", sprite.width, sprite.height,false,false));
					if(!sprite.hasSpeedBoost) sprite.setSpeed();
					((Player) sprite).incrementBlobsEaten();
					this.alive = false;
				} else if(this.width > sprite.width && !sprite.isImmune()){
					((Player) sprite).die();
					this.alive = false;
				}
			} else{
				if(this.width < sprite.width){
					sprite.grow((int)this.width);
					sprite.loadImage(new Image("images/enemy.png", sprite.width, sprite.height,false,false));
					sprite.setSpeed();
					
					this.alive = false;
				}
			}
		}
	}

	//getter
	public boolean isAlive() {
		return this.alive;
	}
}
