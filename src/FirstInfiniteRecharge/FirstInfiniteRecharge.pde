import shiffman.box2d.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;

import java.util.*;

Box2DProcessing box2D;

final int FPS = 60;

HashSet<Character> keysPressed;
HashSet<Integer> keyCodes;

Robot player1;
ArrayList<Boundary> boundaries;
ArrayList<PowerCell> powerCells;

PImage field;
PImage shieldGenerator;
PImage powerCell;

boolean topPadding;
float scalingFactor;

void setup() {
    size(1000, 600);
    // size(500, 300);
    // fullScreen();
    frameRate(FPS);
    setupImages();

    box2D = new Box2DProcessing(this, 10);
    box2D.createWorld();
    box2D.listenForCollisions();
    box2D.setGravity(0, 0);

    keysPressed = new HashSet<Character>();
    keyCodes = new HashSet<Integer>();

    resetGame();

    boundaries = new ArrayList<Boundary>(); // TODO Fix the boundaries
    // boundaries.add(new Boundary(gx(0.5), gy(0.5), gx(0.1), gy(0.1), 45));
    // boundaries.add(new Boundary(0.056, 0.15, 0.110, 0.036, -20.36)); // top left wall
    // boundaries.add(new Boundary(0.037, 0.5, 0.021, 0.46, 90)); // left wall
    // boundaries.add(new Boundary(0.056, 0.85, 0.110, 0.036, 20.36)); // bot left wall
    
    // boundaries.add(new Boundary(0.944, 0.85, 0.110, 0.036, -20.36)); // bot right wall
    // boundaries.add(new Boundary(0.963, 0.5, 0.021, 0.46, 90)); // right wall
    // boundaries.add(new Boundary(0.944, 0.15, 0.110, 0.036, 20.36)); // top right wall
    
    // boundaries.add(new Boundary(0.5, 0.054, 0.838, 0.008, 90)); // top wall
    // boundaries.add(new Boundary(0.5, 0.946, 0.838, 0.008, 90)); // bot wall
    
    // boundaries.add(new Boundary(0.564, 0.130, 0.061, 0.139, 90)); // top wheel of fortune
    // boundaries.add(new Boundary(0.564, 0.208, 0.045, 0.0067, 90)); // top wheel of fortune bot indent
    // boundaries.add(new Boundary(0.436, 0.870, 0.061, 0.139, 90)); // bot wheel of fortune
    // boundaries.add(new Boundary(0.436, 0.792, 0.045, 0.0067, 90)); // bot wheel of fortune top indent

    // boundaries.add(new Boundary(0.355, 0.400, 0.020, 0.032, 23)); // shield generator top left
    // boundaries.add(new Boundary(0.563, 0.233, 0.020, 0.032, 23)); // shield generator top right
    // boundaries.add(new Boundary(0.436, 0.763, 0.020, 0.032, 23)); // shield generator bot left
    // boundaries.add(new Boundary(0.644, 0.598, 0.020, 0.032, 23)); // shield generator bot right

    powerCells = new ArrayList<PowerCell>();
    powerCells.add(new PowerCell(gx(0.5), gy(0.5)));
}

void setupImages() {
    field = loadImage("img/Field.png");
    shieldGenerator = loadImage("img/ShieldGenerator.png");
    powerCell = loadImage("img/PowerCell.png");

    if(((float) width) / field.width > ((float) height) / field.height) {
        scalingFactor = ((float) field.height) / height;
        field.resize(0, height);
        shieldGenerator.resize(0, height);
        topPadding = false;
    }
    else {
        scalingFactor = ((float) field.width) / width;
        field.resize(width, 0);
        shieldGenerator.resize(width, 0);
        topPadding = true;
    }

    powerCell.resize((int) (powerCell.width / scalingFactor), 0);
}

void resetGame() {
    if(player1 != null) {
        player1.removeFromWorld();
    }

    player1 = new Robot(gx(0.1), gy(0.5), gx(0.08), gy(0.10), 0, RED, true);
}

void draw() {
    update();
    showBackground();
    showSprites();
}

void update() {
    player1.handleInput(keysPressed, keyCodes);

    box2D.step();

    player1.update();
    for(PowerCell powerCell : powerCells) {
        powerCell.update();
    }

    // println(frameRate);
}

void showBackground() {
    background(200);
    imageMode(CENTER);
    image(field, width / 2, height / 2);
}

void showSprites() {
    player1.show();
    image(shieldGenerator, width / 2, height / 2);
    for(Boundary boundary : boundaries) {
        boundary.show();
    }
    for(PowerCell powerCell : powerCells) {
        powerCell.show();
    }
    
}

void keyPressed() {
    keysPressed.add(Character.toLowerCase(key));
    keyCodes.add(keyCode);
    
    if(keysPressed.contains('r')) {
        resetGame();
    }
}

void keyReleased() {
    keysPressed.remove(Character.toLowerCase(key));
    keyCodes.remove(keyCode);
}
