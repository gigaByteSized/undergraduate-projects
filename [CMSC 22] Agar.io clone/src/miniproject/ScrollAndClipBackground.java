package miniproject;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javafx.animation.AnimationTimer;
import javafx.application.Application;
import javafx.beans.binding.Bindings;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;

public class ScrollAndClipBackground extends Application {
    // 500x500 map with 10x10 tiles
    private final int tileSize = 10 ;
    private final int numTilesHoriz = 500 ;
    private final int numTilesVert = 500 ;

    private int speed = 400 ; // pixels / second
    private boolean up ;
    private boolean down ;
    private boolean left ;
    private boolean right ;

    private final int numFilledTiles = numTilesHoriz * numTilesVert / 8 ;   

    @Override
    public void start(Stage primaryStage) {
        Pane pane = createBackground();
        Image img = new Image("images/poro.png", 40,40,false,false);
        //Rectangle player = new Rectangle(numTilesHoriz*tileSize/2, numTilesVert*tileSize/2, 40, 40);
        //player.setFill(Color.BLUE);
        ImageView player = new ImageView(img);
        player.setX(numTilesHoriz*tileSize/2);
        player.setY(numTilesVert*tileSize/2);
        pane.getChildren().add(player);

        Scene scene = new Scene(new BorderPane(pane), 800, 800);
        Rectangle clip = new Rectangle();
        clip.widthProperty().bind(scene.widthProperty());
        clip.heightProperty().bind(scene.heightProperty());
        System.out.println(player.xProperty());
        System.out.println(player.xProperty());
        // Using beans for bindings
        clip.xProperty().bind(Bindings.createDoubleBinding(
                () -> clampRange(player.getX() - scene.getWidth() / 2, 0, pane.getWidth() - scene.getWidth()), 
                player.xProperty(), scene.widthProperty()));
        clip.yProperty().bind(Bindings.createDoubleBinding(
                () -> clampRange(player.getY() - scene.getHeight() / 2, 0, pane.getHeight() - scene.getHeight()), 
                player.yProperty(), scene.heightProperty()));

        pane.setClip(clip);
        // Using beans for bindings
        pane.translateXProperty().bind(clip.xProperty().multiply(-1));
        pane.translateYProperty().bind(clip.yProperty().multiply(-1));

        scene.setOnKeyPressed(e -> processKey(e.getCode(), true));
        scene.setOnKeyReleased(e -> processKey(e.getCode(), false));

        AnimationTimer timer = new AnimationTimer() {
            private long lastUpdate = -1 ;
            @Override
            public void handle(long now) {

                // Clock func
                long elapsedNanos = now - lastUpdate ;
                if (lastUpdate < 0) {
                    lastUpdate = now ;
                    return ;
                } double elapsedSeconds = elapsedNanos / 1_000_000_000.0 ; // underscores for readability

                double deltaX = 0 ;
                double deltaY = 0 ;

                // speed++ for testing only kasi di ko pa ginagawa yung resizing ng player
                // just wanted to check if di masisira yung program if iba na yung speed
                if (right){
                    deltaX += speed ;
                    //player.setWidth(player.getWidth()+1);
                    //player.setHeight(player.getHeight()+1);
                    //speed++;
                } if (left){
                    deltaX -= speed ;
                    //player.setWidth(player.getWidth()+1);
                    //player.setHeight(player.getHeight()+1);
                    //speed++;
                } if (down){
                    deltaY += speed ;
                    //player.setWidth(player.getWidth()+1);
                    //player.setHeight(player.getHeight()+1);
                    //speed++;
                } if (up){
                    deltaY -= speed ;
                    //player.setWidth(player.getWidth()+1);
                    //player.setHeight(player.getHeight()+1);
                    //clip.setY(clip.getY()+10);
                    //speed++;
                }

                // If i-lock yung windowsize to 800x800, no need for clampRange, iirc
                player.setX(clampRange(player.getX() + deltaX * elapsedSeconds, 0, pane.getWidth() - player.getFitWidth()));
                player.setY(clampRange(player.getY() + deltaY * elapsedSeconds, 0, pane.getHeight() - player.getFitHeight()));

                lastUpdate = now ;
            }
        };

        primaryStage.setScene(scene);
        primaryStage.show();

        timer.start();
    }

    // Para pwede sa resizeable window
    private double clampRange(double value, double min, double max) {
        if (value < min) return min ;
        if (value > max) return max ;
        return value ;
    }

    private void processKey(KeyCode code, boolean on) {
        switch (code) {
        case LEFT: 
            left = on ;
            break ;
        case RIGHT: 
            right = on ;
            break ;
        case UP:
            up = on ;
            break ;
        case DOWN:
            down = on ;
            break ;
        default:
            break ;
        }
    }


    private Pane createBackground() {

        List<Integer> filledTiles = sampleWithoutReplacement(numFilledTiles, numTilesHoriz * numTilesVert);

        Canvas canvas = new Canvas(numTilesHoriz * tileSize, numTilesVert * tileSize);
        GraphicsContext gc = canvas.getGraphicsContext2D();
        gc.setFill(Color.GREEN);

        Pane pane = new Pane(canvas);

        pane.setMinSize(numTilesHoriz * tileSize, numTilesVert * tileSize);
        pane.setPrefSize(numTilesHoriz * tileSize, numTilesVert * tileSize);
        pane.setMaxSize(numTilesHoriz * tileSize, numTilesVert * tileSize);

        for (Integer tile : filledTiles) {
            int x = (tile % numTilesHoriz) * tileSize ;
            int y = (tile / numTilesHoriz) * tileSize ;
            gc.fillRect(x, y, tileSize, tileSize);
        }

        return pane ;
    }

    // For bg generation
    private List<Integer> sampleWithoutReplacement(int sampleSize, int populationSize) {
        Random rng = new Random();
        List<Integer> population = new ArrayList<>();
        for (int i = 0 ; i < populationSize; i++) 
            population.add(i);
        List<Integer> sample = new ArrayList<>();
        for (int i = 0 ; i < sampleSize ; i++) 
            sample.add(population.remove(rng.nextInt(population.size())));
        return sample;
    }

    public static void main(String[] args) {
        launch(args);
    }
}