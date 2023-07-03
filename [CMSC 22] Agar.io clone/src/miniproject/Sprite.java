package miniproject;

import javafx.geometry.Rectangle2D;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;

public class Sprite {
	protected Image img;
	protected double x, y, dx, dy;
	protected boolean visible;
	protected double width;
	protected double height;
	
	protected double speed;

	protected double speedBoostStart;
	protected double immunityStart;

	protected boolean isPlayer = false;
	protected boolean hasSpeedBoost = false;
	protected boolean isImmune = false;

	public Sprite(int xPos, int yPos){
		this.x = xPos;
		this.y = yPos;
		this.visible = true;
	}

	//method to set the object's image
	protected void loadImage(Image img){
		try{
			this.img = img;
	        this.setSize();
		} catch(Exception e){}
	}

	//method to set the image to the image view node
	void render(GraphicsContext gc, int x, int y, int xOffset, int yOffset){
		if(x != 0) this.x = x;
		if(y != 0) this.y = y;
		gc.drawImage(this.img, this.x + xOffset, this.y + yOffset);
    }

	//method to set the object's width and height properties
	private void setSize(){
		this.width = this.img.getWidth();
	    this.height = this.img.getHeight();
	}
	
	//method that will check for collision of two sprites
	public boolean collidesWith(Sprite rect2)	{
		Rectangle2D rectangle1 = this.getBounds();
		Rectangle2D rectangle2 = rect2.getBounds();


		return rectangle1.intersects(rectangle2);
	}
	//method that will return the bounds of an image
	public Rectangle2D getBounds(){
		return new Rectangle2D(this.x, this.y, this.width, this.height);
	}

	//method to return the image
	Image getImage(){
		return this.img;
	}
	//getters
	public double getX() {
    	return this.x;
	}

	public double getY() {
    	return this.y;
	}

	public boolean getVisible(){
		return visible;
	}
	public boolean isVisible(){
		if(visible) return true;
		return false;
	}

	//setters
	public void setDX(Double dx){
		this.dx = dx;
	}

	public void setDY(Double dy){
		this.dy = dy;
	}

	public void setWidth(double val){
		this.width = val;
	}

	public void setHeight(double val){
		this.height = val;
	}

	public void setVisible(boolean value){
		this.visible = value;
	}

	public void grow(int increment){
		this.width += increment;
		this.height += increment;
	}

	public void setSpeed(){
		this.speed = 120.0/this.width;
	}

	public boolean isPlayer(){
		return isPlayer;
	}

	public boolean isImmune(){
		return this.isImmune;
	}

	public boolean hasSpeedBoost(){
		return this.hasSpeedBoost;
	}
}
