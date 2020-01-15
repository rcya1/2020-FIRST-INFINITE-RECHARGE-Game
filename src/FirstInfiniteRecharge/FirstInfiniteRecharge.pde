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
    // fullScreen();
    frameRate(FPS);
    setupImages();

    box2D = new Box2DProcessing(this, 10); // TODO fix scaling factor
    box2D.createWorld();
    box2D.listenForCollisions();
    box2D.setGravity(0, 0);

    keysPressed = new HashSet<Character>();
    keyCodes = new HashSet<Integer>();

    resetGame();

    boundaries = new ArrayList<Boundary>(); // TODO Fix the boundaries
    boundaries.add(new Boundary(cx(0.056), cy(0.15), cw(0.110), ch(0.036), -20.36)); // top left wall
    boundaries.add(new Boundary(cx(0.037), cy(0.5), cw(0.021), ch(0.46), 90)); // left wall
    boundaries.add(new Boundary(cx(0.056), cy(0.85), cw(0.110), ch(0.036), 20.36)); // bot left wall
    
    boundaries.add(new Boundary(cx(0.944), cy(0.85), cw(0.110), ch(0.036), -20.36)); // bot right wall
    boundaries.add(new Boundary(cx(0.963), cy(0.5), cw(0.021), ch(0.46), 90)); // right wall
    boundaries.add(new Boundary(cx(0.944), cy(0.15), cw(0.110), ch(0.036), 20.36)); // top right wall
    
    boundaries.add(new Boundary(cx(0.5), cy(0.054), cw(0.838), ch(0.008), 90)); // top wall
    boundaries.add(new Boundary(cx(0.5), cy(0.946), cw(0.838), ch(0.008), 90)); // bot wall
    
    boundaries.add(new Boundary(cx(0.564), cy(0.130), cw(0.061), ch(0.139), 90)); // top wheel of fortune
    boundaries.add(new Boundary(cx(0.564), cy(0.208), cw(0.045), ch(0.0067), 90)); // top wheel of fortune bot indent
    boundaries.add(new Boundary(cx(0.436), cy(0.870), cw(0.061), ch(0.139), 90)); // bot wheel of fortune
    boundaries.add(new Boundary(cx(0.436), cy(0.792), cw(0.045), ch(0.0067), 90)); // bot wheel of fortune top indent

    boundaries.add(new Boundary(cx(0.355), cy(0.400), cw(0.020), ch(0.032), 23)); // shield generator top left
    boundaries.add(new Boundary(cx(0.563), cy(0.233), cw(0.020), ch(0.032), 23)); // shield generator top right
    boundaries.add(new Boundary(cx(0.436), cy(0.763), cw(0.020), ch(0.032), 23)); // shield generator bot left
    boundaries.add(new Boundary(cx(0.644), cy(0.598), cw(0.020), ch(0.032), 23)); // shield generator bot right

    powerCells = new ArrayList<PowerCell>();
    powerCells.add(new PowerCell(cx(0.5), cy(0.5)));
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

    player1 = new Robot(cx(1./10), cy(1./2), cw(1./25), ch(1./10), 0, RED, true);
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
    // for(Boundary boundary : boundaries) {
    //     boundary.show();
    // }
    for(PowerCell powerCell : powerCells) {
        powerCell.show();
    }
    
    image(shieldGenerator, width / 2, height / 2);
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
