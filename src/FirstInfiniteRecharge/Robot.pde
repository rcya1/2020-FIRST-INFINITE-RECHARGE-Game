class Robot {
    
    float w, h;
    color robotColor;
    color intakeColor;
    
    boolean wasd;
    
    Body body;
    Fixture fixture;

    boolean intaking;
    PowerCell contactCell;
    int numBalls;

    static final float FRICTION = 0.7;
    static final float RESTITUTION = 0.2;
    static final float DENSITY = 1;

    static final float DRIVE_FORCE = 75000;
    static final float TURN_TORQUE = 100000;
    
    Robot(float x, float y, float w, float h, float angle, color robotColor, color intakeColor, boolean wasd) {
        this.w = w;
        this.h = h;
        
        this.robotColor = robotColor;
        this.intakeColor = intakeColor;
        
        this.wasd = wasd;

        intaking = false;
        contactCell = null;
        numBalls = 0;

        setupBox2D(x, y, angle);
    }

    void setupBox2D(float x, float y, float angle) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);
        bodyDef.angle = radians(angle);
        bodyDef.linearDamping = 7.5;
        bodyDef.angularDamping = 7.5;
        
        body = box2D.createBody(bodyDef);
        
        PolygonShape shape = new PolygonShape();
        shape.setAsBox(w / 2, h / 2);
        
        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = shape;
        fixtureDef.density = DENSITY;
        fixtureDef.friction = FRICTION;
        fixtureDef.restitution = RESTITUTION;
        
        fixtureDef.filter.categoryBits = CATEGORY_ROBOT;
        fixtureDef.filter.maskBits = MASK_ROBOT;
        
        fixture = body.createFixture(fixtureDef);

        PolygonShape intakeShape = new PolygonShape();
        Vec2 offset = new Vec2(w / 2 - w / 8, 0);
        intakeShape.setAsBox(w / 4, w / 4, offset, 0);

        FixtureDef intakeFixtureDef = new FixtureDef();
        intakeFixtureDef.shape = intakeShape;
        intakeFixtureDef.density = DENSITY;
        intakeFixtureDef.friction = FRICTION;
        intakeFixtureDef.restitution = RESTITUTION;
        intakeFixtureDef.isSensor = true;
        intakeFixtureDef.setUserData(this);

        body.createFixture(intakeFixtureDef);
    }
    
    void update() {
        if(intaking && contactCell != null && numBalls < 5) {
            contactCell.removeFromWorld();
            contactCell = null;
            numBalls++;
        }
    }

    void contactCell(PowerCell cell) {
        this.contactCell = cell;
    }

    void endContactCell(PowerCell cell) {
        this.contactCell = null;
    }
    
    void applyForce(PVector force) {
        body.applyForceToCenter(new Vec2(force.x, force.y));
    }
    
    void applyTorque(float torque) {
        body.applyTorque(torque);
    }
    
    void show() {
        pushMatrix();
        
            rectMode(CENTER);
            Vec2 loc = body.getTransform().p;
            // println(loc);
            translate(cx(loc.x), height - cy(loc.y));
            rotate(-body.getAngle());

            stroke(0);
            fill(robotColor);
            rect(0, 0, cw(w), ch(h));
            rect(cw(w / 2 - w / 8), 0, cw(w / 4), ch(w / 4));
        
        popMatrix();
    }
    
    void handleInput(HashSet<Character> keys, HashSet<Integer> keyCodes) {
        if((keys.contains('d') && wasd) || ((keys.contains('\'') || keys.contains('"')) && !wasd)) {
            applyTorque(-TURN_TORQUE);
        }

        if((keys.contains('a') && wasd) || (keys.contains('l') && !wasd)) {
            applyTorque(TURN_TORQUE);
        }

        if((keys.contains('w') && wasd) || (keys.contains('p') && !wasd)) {
            PVector moveForce = PVector.fromAngle(body.getAngle()).mult(DRIVE_FORCE);
            applyForce(moveForce);
        }

        if((keys.contains('s') && wasd) || ((keys.contains(';') || keys.contains(':')) && !wasd)) {
            PVector moveForce = PVector.fromAngle(body.getAngle() + PI).mult(DRIVE_FORCE);
            applyForce(moveForce);
        }
    }

    void removeFromWorld() {
        if(body != null) {
            box2D.destroyBody(body);
        }
    }
}