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
Boundary boundary1;

PImage field;
PImage shieldGenerator;

boolean topPadding;

void setup() {
    size(1000, 600);
    frameRate(FPS);

    box2D = new Box2DProcessing(this);
    box2D.createWorld();
    box2D.listenForCollisions();
    box2D.setGravity(0, 0);

    keysPressed = new HashSet<Character>();
    keyCodes = new HashSet<Integer>();

    setupBackground();
    resetGame();

    boundary1 = new Boundary(width / 2, height / 2, 100, 200);
}

void setupBackground() {
    field = loadImage("img/Field.png");
    shieldGenerator = loadImage("img/ShieldGenerator.png");

    if(((float) width) / field.width > ((float) height) / field.height) {
        field.resize(0, height);
        shieldGenerator.resize(0, height);
        topPadding = false;
    }
    else {
        field.resize(width, 0);
        shieldGenerator.resize(width, 0);
        topPadding = true;
    }
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
}

void showBackground() {
    background(200);
    imageMode(CENTER);
    image(field, width / 2, height / 2);
    image(shieldGenerator, width / 2, height / 2);
}

void showSprites() {
    player1.show();
    boundary1.show();
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
