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
    boundaries.add(new Boundary(gx(0.056), gy(0.85), gx(0.110), gy(0.04), 69.64)); // top left wall
    boundaries.add(new Boundary(gx(0.035), gy(0.5), gx(0.256), gy(0.044), 90)); // left wall
    boundaries.add(new Boundary(gx(0.054), gy(0.15), gx(0.110), gy(0.04), 110.36)); // bot left wall

    boundaries.add(new Boundary(gx(0.944), gy(0.85), gx(0.110), gy(0.04), 110.36)); // top right wall
    boundaries.add(new Boundary(gx(0.965), gy(0.5), gx(0.256), gy(0.044), 90)); // right wall
    boundaries.add(new Boundary(gx(0.944), gy(0.15), gx(0.110), gy(0.04), 69.64)); // bot right wall

    boundaries.add(new Boundary(gx(0.5), gy(0.941), gx(0.835), gy(0.0114), 0)); // top wall
    boundaries.add(new Boundary(gx(0.5), gy(0.059), gx(0.835), gy(0.0114), 0)); // bot wall


    boundaries.add(new Boundary(gx(0.565), gy(0.860), gx(0.06), gy(0.146), 0)); // top wheel of fortune
    boundaries.add(new Boundary(gx(0.565), gy(0.786), gx(0.0430), gy(0.00950), 0)); // top wheel of fortune bot indent
    boundaries.add(new Boundary(gx(0.435), gy(0.140), gx(0.06), gy(0.146), 0)); // bot wheel of fortune
    boundaries.add(new Boundary(gx(0.435), gy(0.216), gx(0.0430), gy(0.00950), 0)); // bot wheel of fortune top indent


    boundaries.add(new Boundary(gx(0.355), gy(0.600), gx(0.0165), gy(0.0315), 25)); // shield generator top left
    boundaries.add(new Boundary(gx(0.565), gy(0.765), gx(0.0165), gy(0.0315), 25)); // shield generator top right
    boundaries.add(new Boundary(gx(0.435), gy(0.235), gx(0.0165), gy(0.0315), 25)); // shield generator bot left
    boundaries.add(new Boundary(gx(0.645), gy(0.400), gx(0.0165), gy(0.0315), 25)); // shield generator bot right

    powerCells = new ArrayList<PowerCell>();
    powerCells.add(new PowerCell(gx(0.396), gy(0.863)));
    powerCells.add(new PowerCell(gx(0.448), gy(0.863)));
    powerCells.add(new PowerCell(gx(0.500), gy(0.863)));
    powerCells.add(new PowerCell(gx(0.592), gy(0.836)));
    powerCells.add(new PowerCell(gx(0.592), gy(0.886)));
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
    powerCells.add(new PowerCell(gx(0.407), gy(0.156)));
    powerCells.add(new PowerCell(gx(0.407), gy(0.107)));
    powerCells.add(new PowerCell(gx(0.499), gy(0.132)));
    powerCells.add(new PowerCell(gx(0.552), gy(0.134)));
    powerCells.add(new PowerCell(gx(0.603), gy(0.134)));
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

    player1 = new Robot(gx(0.1), gy(0.5), gx(0.06), gy(0.075), 0, RED, true);
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
    for(PowerCell powerCell : powerCells) {
        powerCell.show();
    }
    image(shieldGenerator, width / 2, height / 2);
    // for(Boundary boundary : boundaries) {
    //     boundary.show();
    // }
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
