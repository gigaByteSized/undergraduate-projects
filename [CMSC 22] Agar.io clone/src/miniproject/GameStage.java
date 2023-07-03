package miniproject;

import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Button;
import javafx.scene.image.Image;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.stage.Stage;

public class GameStage {
	public static final int WINDOW_HEIGHT = 800;
	public static final int WINDOW_WIDTH = 800;
	public static final int WORLD_HEIGHT = 2400;
	public static final int WORLD_WIDTH = 2400;
	public static final int INIT_PLAYER_SIZE = 40;
	public final static int ENEMY_SIZE=40;
	private Scene scene;
	private Stage stage;
	private Pane root;
	private Canvas canvas;
	private Canvas statusBar;
	private GraphicsContext gc;
	private GameTimer gametimer;

	public GameStage() {
		this.root = new Pane();
		this.scene = new Scene(root, GameStage.WINDOW_WIDTH,GameStage.WINDOW_HEIGHT, Color.BLACK);
		this.canvas = new Canvas(GameStage.WORLD_WIDTH,GameStage.WORLD_HEIGHT);
		this.statusBar = new Canvas(GameStage.WORLD_WIDTH,GameStage.WORLD_HEIGHT);
		this.gc = canvas.getGraphicsContext2D();

		this.gametimer = new GameTimer(this.gc, this.scene, this);
	}

	public void setStage(Stage stage) {
		this.stage = stage;
		this.stage.setResizable(false);

		root.getChildren().add(canvas);
		root.getChildren().add(statusBar);

		this.stage.setTitle("Fighting Fire With Fire");
		this.stage.setScene(createWelcomeScreen(this.stage, this.scene));
		
		this.stage.show();
	}

	public void updateStatusBar(int foodEaten, int blobsEaten, String size, String timeElapsed, double x, double y) {
		this.gc = this.statusBar.getGraphicsContext2D();
		gc.clearRect(0,0,WINDOW_WIDTH,WINDOW_HEIGHT);
		Font font = Font.font("Arial", FontWeight.BOLD,20);

		this.gc.setFont(font);
		this.gc.setFill(Color.WHITE);
		this.gc.setStroke(Color.BLACK);
		this.gc.setLineWidth(2);
		this.gc.fillText("Food eaten: " + foodEaten + "\n" +
						"Blobs eaten: " + blobsEaten + "\n" +
						size + "\n" +
						"Time elapsed (s): " + timeElapsed + "\n",
						x, y);
	}

	public Scene createWelcomeScreen(Stage stage, Scene theScene){
		Scene scene;

		Canvas canvas = new Canvas(WINDOW_WIDTH, WINDOW_HEIGHT);
		GraphicsContext gc = canvas.getGraphicsContext2D();

		Image splash = new Image("images/splash.png", GameStage.WINDOW_WIDTH, GameStage.WINDOW_HEIGHT,false,false);
		gc.drawImage(splash, 0, 0);

		HBox hBox = new HBox();
		Button newGame = new Button("New Game");
		Button instructions = new Button("Instructions");
		Button about = new Button("About");

		newGame.setMinWidth(100);
		instructions.setMinWidth(100);
		about.setMinWidth(100);

		HBox.setMargin(newGame, new Insets(0, 0, 0, 50));
		HBox.setMargin(instructions, new Insets(0, 0, 0, 50));
		HBox.setMargin(about, new Insets(0, 0, 0, 50));

		this.handleNewGame(newGame, stage, theScene);
		this.handleInstructions(instructions);
		this.handleAbout(about);

		hBox.getChildren().addAll(instructions,newGame,about);
		hBox.setTranslateX(WINDOW_WIDTH/2-250);
		hBox.setTranslateY(WINDOW_HEIGHT/2+250);

		StackPane stackPane = new StackPane();
		stackPane.getChildren().addAll(canvas,hBox);

		scene = new Scene(stackPane, WINDOW_WIDTH, WINDOW_HEIGHT);
		return scene;
	}

	public void createInstructionStage(){
		Stage stage = new Stage();
		Scene scene;
		stage.setResizable(false);

		Canvas canvas = new Canvas(WINDOW_WIDTH, WINDOW_HEIGHT);
		GraphicsContext gc = canvas.getGraphicsContext2D();

		Image splash = new Image("images/instructions.png", GameStage.WINDOW_WIDTH, GameStage.WINDOW_HEIGHT,false,false);
		gc.drawImage(splash, 0, 0);

		Button exit = new Button("Exit");

		this.handleExit(exit, stage);

		exit.minWidth(100);
		exit.setTranslateY(300);

		StackPane stackPane = new StackPane();
		stackPane.getChildren().addAll(canvas,exit);

		scene = new Scene(stackPane, WINDOW_WIDTH, WINDOW_HEIGHT);

		stage.setScene(scene);
		stage.show();
	}

	public void createAboutStage(){
		Stage stage = new Stage();
		Scene scene;
		stage.setResizable(false);

		Canvas canvas = new Canvas(WINDOW_WIDTH, WINDOW_HEIGHT);
		GraphicsContext gc = canvas.getGraphicsContext2D();

		Image splash = new Image("images/about.png", GameStage.WINDOW_WIDTH, GameStage.WINDOW_HEIGHT,false,false);
		gc.drawImage(splash, 0, 0);

		Button exit = new Button("Exit");

		this.handleExit(exit, stage);

		exit.minWidth(100);
		exit.setTranslateY(300);

		StackPane stackPane = new StackPane();
		stackPane.getChildren().addAll(canvas,exit);

		scene = new Scene(stackPane, WINDOW_WIDTH, WINDOW_HEIGHT);

		stage.setScene(scene);
		stage.show();
	}

	private void handleNewGame(Button btn, Stage stage, Scene scene) {
		btn.setOnMouseClicked(new EventHandler<MouseEvent>() {
			public void handle(MouseEvent arg0) {
				gametimer.setStart();
				stage.setScene(scene);
				gametimer.start();
			}
		});
	}

	private void handleInstructions(Button btn) {
		btn.setOnMouseClicked(new EventHandler<MouseEvent>() {
			public void handle(MouseEvent arg0) {
				createInstructionStage();
			}
		});
	}

	private void handleAbout(Button btn) {
		btn.setOnMouseClicked(new EventHandler<MouseEvent>() {
			public void handle(MouseEvent arg0) {
				createAboutStage();
			}
		});
	}

	private void handleExit(Button btn, Stage stage) {
		btn.setOnMouseClicked(new EventHandler<MouseEvent>() {
			public void handle(MouseEvent arg0) {
				stage.hide();
			}
		});
	}
}