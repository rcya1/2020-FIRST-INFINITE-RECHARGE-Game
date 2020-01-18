class Robot {
    
    float w, h;
    color robotColor;
    color intakeColor;
    
    boolean wasd;
    
    Body body;
    Fixture fixture;

    boolean shooting;
    boolean intaking;
    ArrayList<PowerCell> contactCells;
    int numBalls;
    int lastShotTime;
    int goalStatus; // 0 - not touching, 1 - red, 2 - blue
    float[] ballX;
    float[] ballY;

    static final float FRICTION = 0.7;
    static final float RESTITUTION = 0.2;
    static final float DENSITY = 1;

    static final float DRIVE_FORCE = 75000;
    static final float TURN_TORQUE = 125000;

    static final int TIME_BETWEEN_SHOTS = 500; // millis
    static final int SHOOTER_SPEED = 750;
    
    Robot(float x, float y, float w, float h, float angle, color robotColor, color intakeColor, boolean wasd) {
        this.w = w;
        this.h = h;
        
        this.robotColor = robotColor;
        this.intakeColor = intakeColor;
        
        this.wasd = wasd;

        intaking = false;
        contactCells = new ArrayList<PowerCell>();
        numBalls = 0;

        ballX = new float[] {-cw(w * 3 / 8), -cw(w * 3 / 8), -cw(w * 3 / 8), -cw(w * 1.5 / 8), -cw(w * 1.5 / 8)};
        ballY = new float[] {ch(h / 4), ch(0), -ch(h / 4), ch(h / 8), -ch(h / 8)};

        setupBox2D(x, y, angle);
    }

    void setupBox2D(float x, float y, float angle) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);
        bodyDef.angle = radians(angle);

        bodyDef.linearDamping = 7.5;
        bodyDef.angularDamping = 6.5;
        
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
    
    void update(ArrayList<PowerCell> powerCells) {
        if(shooting && goalStatus == 0 && numBalls > 0) {
            if(millis() - lastShotTime >= TIME_BETWEEN_SHOTS) {
                lastShotTime = millis();
                numBalls--;
                Vec2 loc = body.getTransform().p;
                powerCells.add(new PowerCell(loc.x, loc.y,
                    cos(body.getAngle() + PI) * SHOOTER_SPEED + body.getLinearVelocity().x, 
                    sin(body.getAngle() + PI) * SHOOTER_SPEED + body.getLinearVelocity().y));
            }
        }
        else if(shooting && goalStatus != 0) {
            if(goalStatus == 1) {
                redScore += numBalls;
                blueStationAvailable += numBalls;
                numBalls = 0;
            }
            else {
                blueScore += numBalls;
                redStationAvailable += numBalls;
                numBalls = 0;
            }
        }
        else if(intaking) {
            Iterator<PowerCell> iterator = powerCells.iterator();
            while(iterator.hasNext()) {
                PowerCell powerCell = iterator.next();

                if(numBalls >= 5) {
                    break;
                }

                if(contactCells.contains(powerCell)) {
                    powerCell.removeFromWorld();
                    contactCells.remove(powerCell);
                    iterator.remove();
                    numBalls++;
                }
            }
        }
    }

    void contactCell(PowerCell cell) {
        contactCells.add(cell);
    }

    void endContactCell(PowerCell cell) {
        contactCells.remove(cell);
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
            rect(cw(w / 2 - w / 8), 0, cw(w / 4), ch(w / 2));

            for(int i = 0; i < numBalls; i++) {
                image(powerCell, ballX[i], ballY[i]);
            }
        
        popMatrix();
    }
    
    void handleInput(HashSet<Character> keys, HashSet<Integer> keyCodes) {
        if(wasd) {
            if(keys.contains('d')) {
                turnClock();
            }
            if(keys.contains('a')) {
                turnCounter();
            }
            if(keys.contains('w')) {
                moveForward();
            }
            if(keys.contains('s')) {
                moveBackward();
            }

            intaking = keys.contains('f');
            shooting = keys.contains(' ');
        }
        else {
            if(keys.contains('\'') || keys.contains('\"')) {
                turnClock();
            }
            if(keys.contains('l')) {
                turnCounter();
            }
            if(keys.contains('p')) {
                moveForward();
            }
            if(keys.contains(';') || keys.contains(':')) {
                moveBackward();
            }
        }
    }

    void turnClock() {
        applyTorque(-TURN_TORQUE);
    }

    void turnCounter() {
        applyTorque(TURN_TORQUE);
    }

    void moveForward() {
        PVector moveForce = PVector.fromAngle(body.getAngle()).mult(DRIVE_FORCE);
        applyForce(moveForce);
    }

    void moveBackward() {
        PVector moveForce = PVector.fromAngle(body.getAngle() + PI).mult(DRIVE_FORCE);
        applyForce(moveForce);
    }

    void setGoal(boolean isRed) {
        goalStatus = isRed ? 1 : 2;
    }

    void removeGoal() {
        goalStatus = 0;
    }

    void removeFromWorld() {
        if(body != null) {
            box2D.destroyBody(body);
        }
    }
}