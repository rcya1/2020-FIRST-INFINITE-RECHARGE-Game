class Boundary
{
    float w, h; // width and height in Box2D space
    boolean isGoal; // whether or not this boundary is a scoring area
    boolean isRed; // if the boundary is a goal, whether it is red or not
    
    // Box2D object
    Body body;

    // physics constants
    static final float FRICTION = 0.8;
    static final float RESTITUTION = 0.1257;
    static final float DENSITY = 1.257;
    
    /**
     * Create a boundary with the given x and y coordinates and width and height in Box2D space
     * starting angle is in radians and measured from the positive x-axis
     */
    Boundary(float x, float y, float w, float h, float angle) {
        this.w = w;
        this.h = h;

        this.isGoal = false;
        this.isRed = false;

        setupBox2D(x, y, angle);
    }

    /**
     * Set up the Box2D physics for the boundary and add it to the world
     */
    void setupBox2D(float x, float y, float angle) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.STATIC;
        bodyDef.position = new Vec2(x, y);
        bodyDef.angle = radians(angle);
        
        body = box2D.createBody(bodyDef);
        
        PolygonShape shape = new PolygonShape();
        shape.setAsBox(w / 2, h / 2);
        
        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = shape;
        fixtureDef.density = DENSITY;
        fixtureDef.friction = FRICTION;
        fixtureDef.restitution = RESTITUTION;
        fixtureDef.setUserData(this);

        fixtureDef.filter.categoryBits = CATEGORY_BOUNDARY;
        
        body.createFixture(fixtureDef);
    }

    /**
     * Decorator to set this boundary up as a goal
     */
    Boundary setGoal(boolean isRed) {
        this.isGoal = true;
        this.isRed = isRed;

        Filter filter = new Filter();
        body.getFixtureList().setFilterData(filter);

        return this;
    }
    
    /**
     * Update the boundary (currently nothing :,( )
     */
    void update() {
        
    }
    
    /**
     * Draw the bounding box for the boundary as well as an orientation line to the top right
     * Only used for debugging 
     */
    void show() {
        pushMatrix();
        
            rectMode(CENTER);
            fill(255, 0, 0);
            Vec2 loc = body.getTransform().p;

            translate(cx(loc.x), height - cy(loc.y));
            rotate(-body.getAngle());

            rect(0, 0, cw(w), ch(h));
            line(0, 0, cw(w) / 2, ch(-h) / 2);
        
        popMatrix();
    }
}