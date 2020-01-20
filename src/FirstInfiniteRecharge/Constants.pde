// robot colors
final color RED = color(255, 175, 175);
final color RED_LIGHTER = color(255, 200, 200);
final color BLUE = color(175, 175, 255);
final color BLUE_LIGHTER = color(200, 200, 255);

// field dimensions in Box2D space
final float FIELD_WIDTH = 277.2;
final float FIELD_HEIGHT = 146.3;

final int FPS = 60; // frames per second
final int MATCH_LENGTH = 150; // match length in seconds
final boolean DEBUG_CLICK = false; // whether or not to do debugging printing on mouse press

// Box2D categories and masks for collisions
// Utilize bitwise masks to efficiently store data
final short CATEGORY_BOUNDARY = 0x0001;
final short CATEGORY_ROBOT = 0x0002;
final short CATEGORY_CELL = 0x0004;
final short CATEGORY_CELL_AIRBORNE = 0x0008;

final short MASK_ROBOT = CATEGORY_BOUNDARY | CATEGORY_ROBOT | CATEGORY_CELL;
final short MASK_CELL = CATEGORY_BOUNDARY | CATEGORY_ROBOT | CATEGORY_CELL;
final short MASK_CELL_AIRBORNE =  CATEGORY_BOUNDARY | CATEGORY_CELL_AIRBORNE;
