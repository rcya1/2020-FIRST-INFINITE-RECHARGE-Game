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

void setup() {
    size(1000, 600);
    frameRate(FPS);

    box2D = new Box2DProcessing(this);
    box2D.createWorld();
    box2D.listenForCollisions();
    box2D.setGravity(0, 0);

    keysPressed = new HashSet<Character>();
    keyCodes = new HashSet<Integer>();

    resetGame();
}

void resetGame() {
    if(player1 != null) {
        player1.removeFromWorld();
    }

    player1 = new Robot(width / 10, height / 2, width / 20, height / 7, 90, color(255, 175, 175), 
        true);
}

void draw() {
    update();
    showBackground();
    showSprites();
}

void update() {
    player1.input(keysPressed, keyCodes);

    box2D.step();

    player1.update();
}

void showBackground() {
    background(200);
}

void showSprites() {
    player1.draw();
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
