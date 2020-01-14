class Robot
{
    float w, h;
    color robotColor;
    
    boolean wasd;
    
    Body body;
    Fixture fixture;

    static final float FRICTION = 0.7;
    static final float RESTITUTION = 0.2;
    static final float DENSITY = 1 ;

    static final float DRIVE_FORCE = 35000;
    static final float TURN_TORQUE = 25000;
    
    Robot(float x, float y, float w, float h, float angle, color robotColor, boolean wasd) {
        this.w = w;
        this.h = h;
        
        this.robotColor = robotColor;
        
        this.wasd = wasd;

        setupBox2D(x, y, angle);
    }

    void setupBox2D(float x, float y, float angle) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = box2D.coordPixelsToWorld(x, y);
        bodyDef.angle = radians(angle - 90);
        bodyDef.linearDamping = 7.5;
        bodyDef.angularDamping = 7.5;
        
        body = box2D.createBody(bodyDef);
        
        PolygonShape shape = new PolygonShape();
        float box2DWidth = box2D.scalarPixelsToWorld(w);
        float box2DHeight = box2D.scalarPixelsToWorld(h);
        shape.setAsBox(box2DWidth / 2, box2DHeight / 2);
        
        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = shape;
        fixtureDef.density = DENSITY;
        fixtureDef.friction = FRICTION;
        fixtureDef.restitution = RESTITUTION;
        
        fixtureDef.filter.categoryBits = CATEGORY_ROBOT;
        fixtureDef.filter.maskBits = MASK_ROBOT;
        
        fixture = body.createFixture(fixtureDef);
    }
    
    void update() {
        
    }
    
    void applyForce(PVector force) {
        body.applyForceToCenter(box2D.vectorPixelsToWorld(force));
    }
    
    void applyTorque(float torque) {
        body.applyTorque(box2D.scalarPixelsToWorld(-torque));
    }
    
    void show() {
        pushMatrix();
        
            rectMode(CENTER);
            Vec2 loc = box2D.getBodyPixelCoord(body);
            translate(loc.x, loc.y);
            rotate(-body.getAngle());

            stroke(0);
            fill(robotColor);
            rect(0, 0, w, h);
        
        popMatrix();
    }
    
    void handleInput(HashSet<Character> keys, HashSet<Integer> keyCodes) {
        if((keys.contains('d') && wasd) || ((keys.contains('\'') || keys.contains('"')) && !wasd)) {
            applyTorque(TURN_TORQUE);
        }

        if((keys.contains('a') && wasd) || (keys.contains('l') && !wasd)) {
            applyTorque(-TURN_TORQUE);
        }

        if((keys.contains('w') && wasd) || (keys.contains('p') && !wasd)) {
            PVector moveForce = PVector.fromAngle(-body.getAngle() - PI / 2).mult(DRIVE_FORCE);
            applyForce(moveForce);
        }

        if((keys.contains('s') && wasd) || ((keys.contains(';') || keys.contains(':')) && !wasd)) {
            PVector moveForce = PVector.fromAngle(-body.getAngle() + PI - PI / 2).mult(DRIVE_FORCE);
            applyForce(moveForce);
        }
    }

    void removeFromWorld() {
        if(body != null) {
            box2D.destroyBody(body);
        }
    }
}