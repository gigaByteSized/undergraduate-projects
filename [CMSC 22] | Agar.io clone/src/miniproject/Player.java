package miniproject;

import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;

public class Player extends Sprite{
	private String name;
	private boolean alive;
	
	private int foodEaten;
	private int blobsEaten;

	private final static int INIT_WIDTH = GameStage.INIT_PLAYER_SIZE;
	public final static Image BLOB_IMAGE = new Image("images/player.png", Player.INIT_WIDTH,Player.INIT_WIDTH,false,false);

	public Player(String name, int x, int y){
		super(x,y);
		this.name = name;
		this.speed = 120.0/INIT_WIDTH;
		this.alive = true;
		this.loadImage(Player.BLOB_IMAGE);
		this.isPlayer = true;
	}

	public boolean isAlive(){
		if(this.alive) return true;
		return false;
	}
	public String getName(){
		return this.name;
	}

	public void die(){
    	this.alive = false;
		System.out.println("You died");
    }

	//method to set the image to the image view node
	void render(GraphicsContext gc){
		gc.drawImage(this.img,
		GameStage.WINDOW_WIDTH/2 - this.getWidth()/2,
		GameStage.WINDOW_HEIGHT/2  - this.getHeight()/2);
    }

	/*
	 *method called if up/down/left/right arrow key is pressed.
	 *Change the x and y position of the ship if the current x,y position
	 *is within the gamestage width and height.
	 */
	public void move() {
		if(this.x+this.dx <= GameStage.WORLD_WIDTH-this.width && this.x+this.dx >= 0 && this.y+this.dy <= GameStage.WORLD_HEIGHT-this.width && this.y+this.dy >=0){
			this.x += this.dx;
    		this.y += this.dy;
    	} else if(this.x+this.dx > GameStage.WORLD_WIDTH-this.width){
			this.x = (int) (GameStage.WORLD_WIDTH-this.width);
		} else if(this.y+this.dy > GameStage.WORLD_HEIGHT-this.height){
			this.y = (int) (GameStage.WORLD_HEIGHT-this.height);
		}  // Moves player to map in case they get out of bounds
	}

	public double getSpeed(){
		return this.speed;
	}

	public double getWidth(){
		return this.width;
	}

	public double getHeight(){
		return this.height;
	}

	public int getFoodEaten(){
		return foodEaten;
	}

	public int getBlobsEaten(){
		return blobsEaten;
	}

	public void incrementFoodEaten(){
		this.foodEaten++;
	}

	public void incrementBlobsEaten(){
		this.blobsEaten++;
	}

	public boolean hasActivePowerup(){
		if(this.hasSpeedBoost || this.isImmune) return true;
		return false;
	}



}
