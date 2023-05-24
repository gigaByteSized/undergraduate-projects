package miniproject;

import java.util.ArrayList;
import java.util.Random;

import javafx.animation.AnimationTimer;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import java.text.DecimalFormat;

public class GameTimer extends AnimationTimer{
	private GameStage gStage;
	private double x = 0.0, y = 0.0;
	private GraphicsContext gc;
	private Scene theScene;
	private Player playerOne;
	private ArrayList<FoodBlob> foodBlobs;
	private ArrayList<EnemyBlob> enemyBlobs;

	private long start;
	private double timeElapsed;
	private boolean tick = true;

	private boolean gameOver;

	public static final int MAX_NUM_ENEMY_BLOBS = 10; 
	public static final int MAX_NUM_FOOD_BLOBS = 50; 
	public static final int MAX_NUM_POWERUPS = 10; 

	public static final int POWERUP_SPAWNTIME = 10; 
	public static final int ENEMY_SPAWNTIME = 5;
	public static final int FOOD_SPAWNTIME = 30;

	public static final int SPEEDBOOST_DURATION = 5;
	public static final int IMMUNITY_DURATION = 5;

	public static final Image GAME_OVER_IMAGE = new Image("images/gameOver.png", GameStage.WINDOW_HEIGHT, GameStage.WINDOW_WIDTH,false,false);
	public static final Image YOU_WIN_IMAGE = new Image("images/youWin.png", GameStage.WINDOW_HEIGHT, GameStage.WINDOW_WIDTH,false,false);
	
	public static final Image BLACK = new Image("images/black.png", 3600, 3600,false,false);
	public static final Image BACKGROUND_IMAGE = new Image("images/map.png", GameStage.WORLD_HEIGHT, GameStage.WORLD_WIDTH,false,false);

	private static final DecimalFormat df = new DecimalFormat("0.00");

	GameTimer(GraphicsContext gc, Scene theScene, GameStage gStage){
		this.gc = gc;
		this.gStage = gStage;
		this.theScene = theScene;
		this.playerOne = new Player("playerOne", GameStage.WORLD_WIDTH/2 - GameStage.INIT_PLAYER_SIZE/2, GameStage.WORLD_HEIGHT/2 - GameStage.INIT_PLAYER_SIZE/2);

		//instantiate the ArrayList of Fish
		this.enemyBlobs = new ArrayList<EnemyBlob>();
		this.foodBlobs = new ArrayList<FoodBlob>();
		//call the spawnFishes method
		this.spawnEnemyBlobs();
		this.spawnFoodBlobs();
		//call method to handle mouse click event
		this.handleKeyPressEvent();
		
		this.start = System.nanoTime();
	}

	@Override
	public void handle(long currentNanoTime) {
		if(this.gameOver == true){
			this.gc.clearRect(0, 0, GameStage.WORLD_WIDTH,GameStage.WORLD_HEIGHT);
			this.gc.drawImage(GAME_OVER_IMAGE, 0,0);

			gStage.updateStatusBar(this.playerOne.getFoodEaten(),
								this.playerOne.getBlobsEaten(),
								"Final size: " + (int) this.playerOne.getWidth(),
								df.format(timeElapsed),
								GameStage.WINDOW_WIDTH/2-100,
								GameStage.WINDOW_HEIGHT/2-150);
			this.stop();
		} else{
			this.gc.clearRect(0, 0, GameStage.WORLD_WIDTH,GameStage.WORLD_HEIGHT);
			this.gc.drawImage(BLACK,0,0);

			this.gc.setGlobalAlpha(0.1);
			//////
			this.gc.drawImage(BACKGROUND_IMAGE,
							-this.playerOne.x + GameStage.WINDOW_WIDTH/2 - this.playerOne.getWidth()/2,
							-this.playerOne.y + GameStage.WINDOW_HEIGHT/2 - this.playerOne.getHeight()/2);
			//////
			this.gc.setGlobalAlpha(1.0);
			
			double timeElapsed;
			if(this.playerOne.hasActivePowerup()){
				if(this.playerOne.hasSpeedBoost){
					timeElapsed = (System.nanoTime() - this.playerOne.speedBoostStart) / 1_000_000_000.0;
					if(timeElapsed >= 5.0){
						System.out.println("player now has normal speed");
						this.playerOne.setSpeed();
						this.playerOne.hasSpeedBoost = false;
					}
				} else{
					timeElapsed = (System.nanoTime() - this.playerOne.immunityStart) / 1_000_000_000.0;
					
					if(timeElapsed >= 5.0){
						this.playerOne.loadImage(new Image("images/player.png", this.playerOne.width, this.playerOne.height,false,false));
						this.playerOne.isImmune = false;
						System.out.println("player is now vulnerable");
					}
				}
			}

			timeElapsed = (System.nanoTime() - start) / 1_000_000_000.0;
			if((int) (timeElapsed * 10 % 10) == 0 ){
				if((int) (timeElapsed % POWERUP_SPAWNTIME) == 0 && (int) (timeElapsed) != 0 && this.tick == true){
					this.tick = false;
					spawnPowerups();
				}

				if((int) (timeElapsed % ENEMY_SPAWNTIME) == 0 && (int) (timeElapsed) != 0 && this.tick == true){
					this.tick = false;
					spawnEnemyBlobs();
				}
							
				if((int) (timeElapsed % FOOD_SPAWNTIME) == 0 && (int) (timeElapsed) != 0 && this.tick == true){
					this.tick = false;
					spawnFoodBlobs();
				}
			} else this.tick = true;

			// Movement
			this.playerOne.move();
			this.moveEnemyBlobs();

			// Render player
			this.playerOne.render(this.gc);		

			// Render enemies and food
			this.renderEnemyBlobs();
			this.renderFoodBlobs();

			// Check for collision
			ArrayList<FoodBlob> fRemove = new ArrayList<FoodBlob>();
			for(FoodBlob f: this.foodBlobs){
				f.checkCollision(this.playerOne);
				for(EnemyBlob e: this.enemyBlobs) f.checkCollision(e);
				f.decay(currentNanoTime);
				if(!f.isAlive()) fRemove.add(f);
			} for(FoodBlob f: fRemove) this.foodBlobs.remove(f);

			ArrayList<EnemyBlob> eRemove = new ArrayList<EnemyBlob>();
			for(EnemyBlob e: this.enemyBlobs){
				e.checkCollision(playerOne);
				for(EnemyBlob g: this.enemyBlobs) if(e != g) e.checkCollision(g);
				if(!e.isAlive()) eRemove.add(e);
			} for(EnemyBlob e: eRemove) this.enemyBlobs.remove(e);

			if(!this.playerOne.isAlive()) this.gameOver = true;

			this.timeElapsed = (System.nanoTime() - start) / 1_000_000_000.0;
			gStage.updateStatusBar(this.playerOne.getFoodEaten(),
								this.playerOne.getBlobsEaten(),
								"Current size: " + (int) this.playerOne.getWidth(),
								df.format(timeElapsed),
								15,35);

			if(this.playerOne.width >= GameStage.WINDOW_WIDTH){
				this.gc.clearRect(0, 0, GameStage.WORLD_WIDTH,GameStage.WORLD_HEIGHT);
				this.gc.drawImage(YOU_WIN_IMAGE, 0,0);

				gStage.updateStatusBar(this.playerOne.getFoodEaten(),
									this.playerOne.getBlobsEaten(),
									"Final size: " + (int) this.playerOne.getWidth(),
									df.format(timeElapsed),
									GameStage.WINDOW_WIDTH/2-100,
									GameStage.WINDOW_HEIGHT/2-150);
				this.stop();
			} // Player wins if they are the size of or bigger than the window
		}
		
	}

	private void renderEnemyBlobs() {
		for (EnemyBlob e : this.enemyBlobs){
			e.render(this.gc, 0, 0,
				(int) (-this.playerOne.x + GameStage.WINDOW_WIDTH/2 - this.playerOne.getWidth()/2),
				(int) (-this.playerOne.y + GameStage.WINDOW_HEIGHT/2 - this.playerOne.getHeight()/2));
		}
	}

	private void renderFoodBlobs() {
		for (FoodBlob f : this.foodBlobs){
			if(f.isAlive()){
				f.render(this.gc, 0, 0,
				(int) (-this.playerOne.x + GameStage.WINDOW_WIDTH/2 - this.playerOne.getWidth()/2),
				(int) (-this.playerOne.y + GameStage.WINDOW_HEIGHT/2 - this.playerOne.getHeight()/2));
			}
		}
	}

	private void spawnEnemyBlobs(){
		Random r = new Random();
		for(int i=0;i<GameTimer.MAX_NUM_ENEMY_BLOBS;i++){
			int x = r.nextInt(GameStage.WORLD_WIDTH-50);
			int y = r.nextInt(GameStage.WORLD_HEIGHT-50);
			this.enemyBlobs.add(new EnemyBlob(x,y));
			System.out.println("An enemy has spawned.");
		}

	}

	private void spawnFoodBlobs(){
		Random r = new Random();
		for(int i=0;i<GameTimer.MAX_NUM_FOOD_BLOBS;i++){
			int x = r.nextInt(GameStage.WORLD_WIDTH-50);
			int y = r.nextInt(GameStage.WORLD_HEIGHT-50);
			this.foodBlobs.add(new FoodBlob(x,y, false, System.nanoTime()));
			System.out.println("A food has spawned.");
		}
	}

	private void spawnPowerups(){
		Random r = new Random();

		for(int i=0;i<MAX_NUM_POWERUPS;i++){
			int x = r.nextInt(GameStage.WORLD_WIDTH-50);
			int y = r.nextInt(GameStage.WORLD_HEIGHT-50);
			this.foodBlobs.add(new FoodBlob(x,y, true, System.nanoTime()));
			System.out.println("A powerup has spawned.");
		}

	}

	//method that will listen and handle the key press events
	private void handleKeyPressEvent() {
		theScene.setOnKeyPressed(new EventHandler<KeyEvent>(){
			public void handle(KeyEvent e){
            	KeyCode code = e.getCode();
                moveMyBlob(code);
			}
		});

		theScene.setOnKeyReleased(new EventHandler<KeyEvent>(){
		            public void handle(KeyEvent e){
		            	KeyCode code = e.getCode();
		                stopMyBlob(code);
		            }
		        });
    }

	//method that will move the ship depending on the key pressed
	private void moveMyBlob(KeyCode ke) {
		if(ke==KeyCode.W) this.playerOne.setDY(-(this.playerOne.getSpeed()));

		if(ke==KeyCode.A) this.playerOne.setDX(-(this.playerOne.getSpeed()));

		if(ke==KeyCode.S) this.playerOne.setDY(this.playerOne.getSpeed());

		if(ke==KeyCode.D) this.playerOne.setDX(this.playerOne.getSpeed());

		if(ke==KeyCode.SPACE){ // Cheat code for debugging purposes
			if(!this.playerOne.hasSpeedBoost()){
				this.playerOne.speed *= 2;
				this.playerOne.hasSpeedBoost = true;
			}
			this.playerOne.speedBoostStart = System.nanoTime();

			this.playerOne.isImmune = true;
			this.playerOne.loadImage(new Image("images/immunity.png", this.playerOne.width, this.playerOne.height,false,false));
			this.playerOne.immunityStart = System.nanoTime();
		}

		System.out.println(ke+" key pressed.");
   	}

	// Stop player movement
	private void stopMyBlob(KeyCode ke){
		this.playerOne.setDX(0.0);
		this.playerOne.setDY(0.0);
	}

	private void moveEnemyBlobs(){
		for(int i = 0; i < this.enemyBlobs.size(); i++){
			EnemyBlob f = this.enemyBlobs.get(i);
			if(f.isAlive()) f.move(this.start);
        	else this.enemyBlobs.remove(i);
		}
	}

	public double getX(){
		return x;
	}

	public double getY(){
		return y;
	}

	public void setX(double x){
		this.x = x;
	}

	public void setY(double y){
		this.y = y;
	}

	public void setStart(){
		this.start = System.nanoTime();
	}

}
