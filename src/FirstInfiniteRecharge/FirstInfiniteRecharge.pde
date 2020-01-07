import shiffman.box2d.*;

import java.util.*;

Box2DProcessing box2D;

final int FPS = 60;

HashSet<Character> keysPressed;
HashSet<Integer> keyCodes;

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

}

void draw() {
    update();
    showBackground();
    showSprites();
}

void update() {
    box2D.step();
}

void showBackground() {
    background(200);
}

void showSprites() {

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
