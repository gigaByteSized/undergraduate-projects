package miniproject;

import java.util.Random;

import javafx.scene.image.Image;

public class FoodBlob extends Sprite {
	public final static int BLOB_WIDTH = 10;
	public final static int SPEEDBOOST_FACTOR = 2;
	public final static Image BLOB_IMAGE = new Image("images/food.png",FoodBlob.BLOB_WIDTH,FoodBlob.BLOB_WIDTH,false,false);
	public final static Image SPEEDBOOST_IMAGE = new Image("images/coal.png",FoodBlob.BLOB_WIDTH+20,FoodBlob.BLOB_WIDTH+20,false,false);
	public final static Image IMMUNITY_IMAGE = new Image("images/gas.png",FoodBlob.BLOB_WIDTH+20,FoodBlob.BLOB_WIDTH+20,false,false);

	private boolean alive;
	private boolean isAPowerup;
	private boolean isSpeedBoost;

	private double timeOfSpawn;

	FoodBlob(int x, int y, boolean isAPowerup, double timeOfSpawn){
		super(x,y);
		this.alive = true;
		this.isAPowerup = isAPowerup;
		this.timeOfSpawn = timeOfSpawn;
		if(this.isAPowerup == false) this.loadImage(FoodBlob.BLOB_IMAGE);
		else{
			Random r = new Random();
			this.isSpeedBoost = r.nextBoolean();
			if(this.isSpeedBoost == true) this.loadImage(FoodBlob.SPEEDBOOST_IMAGE);
			else this.loadImage(FoodBlob.IMMUNITY_IMAGE);
		}

	}

	public void checkCollision(Sprite sprite){
		if(this.collidesWith(sprite) && sprite.isPlayer() == true){
			if(this.isAPowerup){
				if(this.isSpeedBoost){
					if(!sprite.hasSpeedBoost()){
						sprite.speed *= SPEEDBOOST_FACTOR;
						sprite.hasSpeedBoost = true;
					} sprite.speedBoostStart = System.nanoTime();
				} else{
					sprite.isImmune = true;
					sprite.loadImage(new Image("images/immunity.png", sprite.width, sprite.height,false,false));
					sprite.immunityStart = System.nanoTime();
				}
			} else{
				sprite.grow(BLOB_WIDTH);
				if(!sprite.isImmune()) sprite.loadImage(new Image("images/player.png", sprite.width, sprite.height,false,false));
				else sprite.loadImage(new Image("images/immunity.png", sprite.width, sprite.height,false,false));
				if(!sprite.hasSpeedBoost()) sprite.setSpeed();
				((Player) sprite).incrementFoodEaten();
			} this.alive = false;
		} else if(this.collidesWith(sprite) && sprite.isPlayer() == false){
			sprite.grow(BLOB_WIDTH);
			sprite.loadImage(new Image("images/enemy.png", sprite.width, sprite.height,false,false));
			sprite.setSpeed();

			this.alive = false;
		}
	}

	public void decay(double currentNanotime){
		if(!this.isAPowerup) return;
		double timeElapsed = (currentNanotime - this.timeOfSpawn) / 1_000_000_000.0;
		if((int) (timeElapsed * 10 % 10) == 0 ){
			if((int) (timeElapsed % 5) == 0 && (int) (timeElapsed) != 0) this.alive = false;
		}
	}

	//getter
	public boolean isAlive() {
		return this.alive;
	}

	public boolean isAPowerup() {
		return this.alive;
	}
}
