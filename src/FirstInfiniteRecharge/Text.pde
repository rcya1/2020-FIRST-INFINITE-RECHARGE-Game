/**
 * Class for managing text that fades away upwards
 */
class Text {

    String text; // message
    float x, y; // x and y coordinates of the text
    color textColor; // color the text will be drawn in
    float floatSpeed; // speed at which the text will float away
    float life; // the current life of the text
    float maxLife; // the starting life of the text
    boolean left;

    /**
     * Creates a text object at a given position with given parameters and message
     */
    Text(String text, float x, float y, color textColor, float floatSpeed, int lifeSpan, boolean left) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.textColor = textColor;
        this.floatSpeed = floatSpeed;
        this.life = lifeSpan;
        this.maxLife = lifeSpan;
        this.left = left;
    }

    /**
     * Update the life and the y of the text
     */
    void update() {
        if(life > 0) life--;
        y -= floatSpeed;
    }

    /**
     * Draw the text and slowly fade it depending on its life
     */
    void show() {
        fill(red(textColor), green(textColor), blue(textColor), life * 255 / maxLife);
        textAlign(left ? LEFT : RIGHT);
        textSize(56 / scalingFactor);
        text(text, x, y);
    }

    /**
     * Whether or not the text is currently dead and should be deleted
     */
    boolean dead() {
        return life <= 0;
    }
}