import shiffman.box2d.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;

import java.util.*;

Box2DProcessing box2D; // Box2D world for handling physics

final int FPS = 60; // frames per second

// the currently pressed keys
HashSet<Character> keysPressed;
HashSet<Integer> keyCodes;

// players
Robot player1;

// how many balls are available in each station
int redStationAvailable;
int blueStationAvailable;

// last time that the stations ejected ball. Used for handling timing between balls
int redStationLastTime;
int blueStationLastTime;

ArrayList<Boundary> boundaries; // list of all boundaries
ArrayList<PowerCell> powerCells; // list of all Power Cells
ArrayList<PowerCell> scheduleDelete; // list of all Power Cells scheduled to be deleted

// game scores
int redScore;
int blueScore;

int startTime; // time the actual game started in millis
int fadeTimer; // time left for the current countdown number to fade
int countDown; // number of seconds left in the countdown

// all images used by the game
PImage field;
PImage shieldGenerator;
PImage trench;
PImage powerCell;

boolean topPadding; // whether or not the padding for the screen is on the top or the sides
float scalingFactor; // how much the field image was scaled down by

// TODO add the custom shooter power
// TODO make the loading bay graphic update with the amount of balls you have
// TODO improve the font of the top and add colored rectangles to make it easier to see

/**
 * Set up all of the variables in the game
 */
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

    // set up all boundaries
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

/**
 * Load all images and resize them to fit the screen
 */
void setupImages() {
    field = loadImage("img/Field.png");
    shieldGenerator = loadImage("img/ShieldGenerator.png");
    trench = loadImage("img/Trench.png");
    powerCell = loadImage("img/PowerCell.png");

    // scale differently depending on which dimension is smaller
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

/**
 * Reset all robots, game pieces, and scores
 */
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
    redStationAvailable = 5;
    blueStationAvailable = 5;

    fadeTimer = FPS;
    countDown = 5;
    startTime = -1; // -1 so that we know the game hasn't started yet
}

/**
 * Update and draw the entire game
 */
void draw() {
    update();
    showBackground();
    showSprites();
    showOverlay();
}

/**
 * Update the physics and inputs of everything
 */
void update() {
    if(countDown > 0) {
        if(fadeTimer == 0) {
            countDown--;
            fadeTimer = 60;
        }
    }
    else if(startTime == -1 || getCurrentMatchTimeLeft() > 0) {
        if(startTime == -1) {
            startTime = millis();
        }

        player1.handleInput(keysPressed, keyCodes);

        box2D.step();

        player1.update(powerCells);
        for(PowerCell powerCell : powerCells) {
            powerCell.update();
        }

        for(PowerCell powerCell : scheduleDelete) {
            powerCell.removeFromWorld();
        }

        // eject balls from stations if commanded to or forced to by the number in reserve
        if((keysPressed.contains('q') || redStationAvailable > 14) && millis() - redStationLastTime > 500 && redStationAvailable > 0) {
            powerCells.add(new PowerCell(gx(0.948), gy(0.659), gx(-0.1), gy(0)));
            redStationLastTime = millis();
            redStationAvailable--;
        }
        if((keysPressed.contains('o') || blueStationAvailable > 14) && millis() - blueStationLastTime > 500 && blueStationAvailable > 0) {
            powerCells.add(new PowerCell(gx(0.057), gy(0.328), gx(0.1), gy(0)));
            blueStationLastTime = millis();
            blueStationAvailable--;
        }
        scheduleDelete.clear();
    }
    fadeTimer--;

    // println(frameRate);
}

/** 
 * Display the field image
 */
void showBackground() {
    background(200);
    imageMode(CENTER);
    image(field, width / 2, height / 2);
}

/** 
 * Display the sprites such as the players, Power Cells, and overlaying field elements
 */
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

/**
 * Draw the top overlay
 */
void showOverlay() {
    fill(200);
    rect(width / 2, height / 30, width, height / 15);

    textAlign(CENTER);
    textSize(56 / scalingFactor);
    fill(0);
    text("Red Score: " + redScore, width / 10, height / 20);
    text("Red Available: " + redStationAvailable, width * 3 / 10, height / 20);

    text("Blue Score: " + blueScore, width * 9 / 10, height / 20);
    text("Blue Available: " + blueStationAvailable, width * 7 / 10, height / 20);

    int min, sec;
    if(startTime == -1) {
        min = 2;
        sec = 30;
    }
    else {
        min = getCurrentMatchTimeLeft() / 60;
        sec = getCurrentMatchTimeLeft() % 60;
    }

    text(min + " : " + sec, width / 2, height / 20);

    // draw fading countdown timer
    if(fadeTimer > 0) {
        fill(0, 0, 0, 255 * fadeTimer / FPS);
        textSize(150 / scalingFactor);
        text(countDown == 0 ? "Start!" : Integer.toString(countDown), width / 2, height / 2);
    }
}

/**
 * Returns the floored current match time in seconds
 */
int getCurrentMatchTime() {
    return (millis() - startTime) / 1000;
}

/**
 * Returns the ceiling current match time left in seconds
 */
int getCurrentMatchTimeLeft() {
    return 150 - getCurrentMatchTime();
}

/**
 * Register all keys that were pressed
 */
void keyPressed() {
    keysPressed.add(Character.toLowerCase(key));
    keyCodes.add(keyCode);
    
    if(keysPressed.contains('r')) {
        resetGame();
    }
}

/** 
 * Unregister all keys that were released 
 */
void keyReleased() {
    keysPressed.remove(Character.toLowerCase(key));
    keyCodes.remove(keyCode);
}
