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

int redStationAvailable;
int blueStationAvailable;

int redStationLastTime;
int blueStationLastTime;

ArrayList<Boundary> boundaries;
ArrayList<PowerCell> powerCells;
ArrayList<PowerCell> scheduleDelete;

int redScore;
int blueScore;

PImage field;
PImage shieldGenerator;
PImage trench;
PImage powerCell;

boolean topPadding;
float scalingFactor;

// TODO Add trench run, fix tape with the shield generator, and add 15 station limit
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

    powerCells = new ArrayList<PowerCell>();
    scheduleDelete = new ArrayList<PowerCell>();

    resetGame();

    boundaries = new ArrayList<Boundary>();
    boundaries.add(new Boundary(gx(0.056), gy(0.85), gx(0.110), gy(0.04), 69.64)); // top left wall
    boundaries.add(new Boundary(gx(0.035), gy(0.5), gx(0.256), gy(0.044), 90)); // left wall
    boundaries.add(new Boundary(gx(0.054), gy(0.15), gx(0.110), gy(0.04), 110.36)); // bot left wall

    boundaries.add(new Boundary(gx(0.944), gy(0.85), gx(0.110), gy(0.04), 110.36)); // top right wall
    boundaries.add(new Boundary(gx(0.965), gy(0.5), gx(0.256), gy(0.044), 90)); // right wall
    boundaries.add(new Boundary(gx(0.944), gy(0.15), gx(0.110), gy(0.04), 69.64)); // bot right wall

    boundaries.add(new Boundary(gx(0.5), gy(0.941), gx(0.835), gy(0.0114), 0)); // top wall
    boundaries.add(new Boundary(gx(0.5), gy(0.059), gx(0.835), gy(0.0114), 0)); // bot wall


    boundaries.add(new Boundary(gx(0.565), gy(0.786), gx(0.0430), gy(0.00950), 0)); // top wheel of fortune bot indent
    boundaries.add(new Boundary(gx(0.435), gy(0.216), gx(0.0430), gy(0.00950), 0)); // bot wheel of fortune top indent


    boundaries.add(new Boundary(gx(0.355), gy(0.600), gx(0.0165), gy(0.0315), 25)); // shield generator top left
    boundaries.add(new Boundary(gx(0.565), gy(0.765), gx(0.0165), gy(0.0315), 25)); // shield generator top right
    boundaries.add(new Boundary(gx(0.435), gy(0.235), gx(0.0165), gy(0.0315), 25)); // shield generator bot left
    boundaries.add(new Boundary(gx(0.645), gy(0.400), gx(0.0165), gy(0.0315), 25)); // shield generator bot right

    boundaries.add((new Boundary(gx(0.035), gy(0.678), gx(0.065), gy(0.044), 90)).setGoal(true)); // left (red) goal
    boundaries.add((new Boundary(gx(0.965), gy(0.3125), gx(0.065), gy(0.044), 90)).setGoal(false)); // right (blue) goal
}

void setupImages() {
    field = loadImage("img/Field.png");
    shieldGenerator = loadImage("img/ShieldGenerator.png");
    trench = loadImage("img/Trench.png");
    powerCell = loadImage("img/PowerCell.png");

    if(((float) width) / field.width > ((float) height) / field.height) {
        scalingFactor = ((float) field.height) / height;
        field.resize(0, height);
        shieldGenerator.resize(0, height);
        trench.resize(0, height);
        topPadding = false;
    }
    else {
        scalingFactor = ((float) field.width) / width;
        field.resize(width, 0);
        shieldGenerator.resize(width, 0);
        trench.resize(width, 0);
        topPadding = true;
    }

    powerCell.resize((int) (powerCell.width / scalingFactor), 0);
}

void resetGame() {
    if(player1 != null) {
        player1.removeFromWorld();
    }

    player1 = new Robot(gx(0.1), gy(0.5), gx(0.06), gy(0.075), 0, RED, RED_LIGHTER, true);

    powerCells.clear();

    // top trench power cells
    powerCells.add(new PowerCell(gx(0.396), gy(0.863)));
    powerCells.add(new PowerCell(gx(0.448), gy(0.863)));
    powerCells.add(new PowerCell(gx(0.500), gy(0.863)));

    // top wheel of fortune power cells
    powerCells.add(new PowerCell(gx(0.600), gy(0.836)));
    powerCells.add(new PowerCell(gx(0.600), gy(0.886)));

    // shield generator power cells
    powerCells.add(new PowerCell(gx(0.384), gy(0.609)));
    powerCells.add(new PowerCell(gx(0.407), gy(0.626)));
    powerCells.add(new PowerCell(gx(0.375), gy(0.541)));
    powerCells.add(new PowerCell(gx(0.385), gy(0.494)));
    powerCells.add(new PowerCell(gx(0.394), gy(0.459)));
    powerCells.add(new PowerCell(gx(0.592), gy(0.369)));
    powerCells.add(new PowerCell(gx(0.615), gy(0.386)));
    powerCells.add(new PowerCell(gx(0.625), gy(0.452)));
    powerCells.add(new PowerCell(gx(0.615), gy(0.495)));
    powerCells.add(new PowerCell(gx(0.606), gy(0.535)));

    // bottom wheel of fortune power cells
    powerCells.add(new PowerCell(gx(0.400), gy(0.156)));
    powerCells.add(new PowerCell(gx(0.400), gy(0.107)));

    // bottom trench power cells
    powerCells.add(new PowerCell(gx(0.499), gy(0.132)));
    powerCells.add(new PowerCell(gx(0.552), gy(0.134)));
    powerCells.add(new PowerCell(gx(0.603), gy(0.134)));

    redScore = 0;
    blueScore = 0;
}

void draw() {
    update();
    showBackground();
    showSprites();
    showOverlay();
}

void update() {
    player1.handleInput(keysPressed, keyCodes);

    box2D.step();

    player1.update(powerCells);
    for(PowerCell powerCell : powerCells) {
        powerCell.update();
    }

    for(PowerCell powerCell : scheduleDelete) {
        powerCell.removeFromWorld();
    }

    if(keysPressed.contains('q') && millis() - redStationLastTime > 500 && redStationAvailable > 0) {
        powerCells.add(new PowerCell(gx(0.948), gy(0.659), gx(-0.1), gy(0)));
        redStationLastTime = millis();
        redStationAvailable--;
    }
    if(keysPressed.contains('o') && millis() - blueStationLastTime > 500 && blueStationAvailable > 0) {
        powerCells.add(new PowerCell(gx(0.057), gy(0.328), gx(0.1), gy(0)));
        blueStationLastTime = millis();
        blueStationAvailable--;
    }
    scheduleDelete.clear();

    // println(frameRate);
}

void showBackground() {
    background(200);
    imageMode(CENTER);
    image(field, width / 2, height / 2);
}

void showSprites() {
    player1.show();
    for(PowerCell powerCell : powerCells) {
        powerCell.show();
    }
    image(shieldGenerator, width / 2, height / 2);
    image(trench, width / 2, height / 2);
    // for(Boundary boundary : boundaries) {
    //     boundary.show();
    // }
}

void showOverlay() {
    fill(200);
    rect(width / 2, height / 30, width, height / 15);

    textAlign(CENTER);
    textSize(56 / scalingFactor);
    fill(0);
    text("Red Score: " + redScore, width / 5, height / 20);
    text("Red Available: " + redStationAvailable, width * 2 / 5, height / 20);

    text("Blue Score: " + blueScore, width * 3 / 5, height / 20);
    text("Blue Available: " + blueStationAvailable, width * 4 / 5, height / 20);
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
