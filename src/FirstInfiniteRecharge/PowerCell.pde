/**
 * Class for representing power cells, the primary game piece of First Infinite Recharge
 */
class PowerCell {

    float w, h; // width and height of the Power Cell in Box2D space
    
    // Box2D objects
    BodyDef bodyDef;
    Body body;
    FixtureDef fixtureDef;

    boolean destroyed; // represents whether the power cell has been destroyed and is no longer in the world
    boolean airborne; // represents whether the power cell is in the air and can be scored

    // physics constants
    static final float FRICTION = 1.0;
    static final float RESTITUTION = 0.4;
    static final float DENSITY = 0.5;
    
    /**
     * Create a Power Cell with the given x and y coordinates in Box2D space
     */
    PowerCell(float x, float y) {
        this(x, y, 0, 0);
    }

    /**
     * Create a Power Cell with the given x and y coordinates in Box2D space with an initial velocity
     */
    PowerCell(float x, float y, float velX, float velY) {
        w = gx(getWRatio(powerCell.width));
        h = gy(getHRatio(powerCell.height));

        destroyed = false;

        if(velX != 0 || velY != 0) {
            airborne = true;
        }
        setupBox2D(x, y);
        body.setLinearVelocity(new Vec2(velX, velY));
    }

    /**
     * Set up the Box2D physics for the game piece and add it to the world
     */
    void setupBox2D(float x, float y) {
        bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);

        if(airborne) {
            bodyDef.bullet = true;
            bodyDef.linearDamping = 0.75;
        }
        else {
            bodyDef.linearDamping = 3.0;
        }
        bodyDef.angularDamping = 2.0;
        
        body = box2D.createBody(bodyDef);
        
        CircleShape shape = new CircleShape();
        shape.m_radius = w / 2;
        
        fixtureDef = new FixtureDef();
        fixtureDef.shape = shape;
        fixtureDef.density = DENSITY;
        fixtureDef.friction = FRICTION;
        fixtureDef.restitution = RESTITUTION;

        // change collisions depending on if the Power Cell is airborne or not
        if(airborne) {
            fixtureDef.filter.categoryBits = CATEGORY_CELL_AIRBORNE;
            fixtureDef.filter.maskBits = MASK_CELL_AIRBORNE;
        }
        else {
            fixtureDef.filter.categoryBits = CATEGORY_CELL;
            fixtureDef.filter.maskBits = MASK_CELL;
        }

        fixtureDef.setUserData(this);
        
        body.createFixture(fixtureDef);
    }
    
    /**
     * Update the airborne state of the Power Cell
     */
    void update() {
        if(!destroyed) {
            if(getLinearVelocitySquared() < 400) {
                setNormal();
                airborne = false;
            }
        }
    }

    /**
     * Returns the current velocity of the ball for goal calculations
     */
    float getLinearVelocitySquared() {
        return body.getLinearVelocity().lengthSquared();
    }

    /**
     * Draws the PowerCell image (PowerCell.png) at the ball's location
     */
    void show() {
        if(!destroyed) {
            pushMatrix();
            
                imageMode(CENTER);
                Vec2 loc = body.getTransform().p;
                translate(cx(loc.x), height - cy(loc.y));
                rotate(-body.getAngle());
                image(powerCell, 0, 0, cw(w), ch(h));

                // if(airborne) ellipse(0, 0, cw(w), ch(h)); // debug
            
            popMatrix();
        }
    }

    /**
     * Remove the Power Cell from the Box2D world and physics calculations
     */
    void removeFromWorld() {
        if(body != null) box2D.destroyBody(body);
        destroyed = true;
    }

    /**
     * Change the physics of the Power Cell from airbone to grounded
     */
    void setNormal() {
        airborne = false;
        Filter filter = new Filter();
        filter.categoryBits = CATEGORY_CELL;
        filter.maskBits = MASK_CELL;
        body.getFixtureList().setFilterData(filter);
        body.setLinearDamping(3.0);
    }
}
