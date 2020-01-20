class Robot {
    
    float w, h; // width and height of the Robot in Box2D space
    color robotColor; // color to fill in the robot
    color intakeColor; // color to draw the intake with
    
    boolean wasd; // whether or not the Robot is controlled with WASD

    // Box2D objects
    Body body;
    Fixture fixture;

    /**
     * State Machine:
     * 0 - normal
     * 1 - intaking
     * 2 - charging shooter
     * 3 - shooting 
     */
    int state = 0;
    float shooterSpeed;
    float shooterSpeedBarVelocity;

    ArrayList<PowerCell> contactCells; // list of all balls the Robot is touching
    int numBalls; // number of balls stored by the Robot
    int lastShotTime; // the last time the Robot shot the ball
    int goalStatus; // 0 - not touching a goal, 1 - touching red goal, 2 - touching blue goal

    float[] ballX; // x coordinates of where to draw the stored balls 
    float[] ballY; // y coordinates of where to draw the stored bals

    // physics constants
    static final float FRICTION = 0.7;
    static final float RESTITUTION = 0.2;
    static final float DENSITY = 1;
    static final float DRIVE_FORCE = 75000;
    static final float TURN_TORQUE = 125000;

    // shooter constants
    static final int TIME_BETWEEN_SHOTS = 500; // millis
    static final int MAX_SHOOTER_SPEED = 150;
    

    /**
     * Create a robot at the given x, y and width and height in Box2D space
     * Initializes with an angle given in radians from the positive x-axis and with set colors for drawing
     * wasd is true for using WASD controls to control the robot
     */
    Robot(float x, float y, float w, float h, float angle, color robotColor, color intakeColor, boolean wasd) {
        this.w = w;
        this.h = h;
        
        this.robotColor = robotColor;
        this.intakeColor = intakeColor;
        
        this.wasd = wasd;

        state = 0;
        shooterSpeed = 0;
        shooterSpeedBarVelocity = 1;
        contactCells = new ArrayList<PowerCell>();
        numBalls = 3;

        // set up the positions for the balls to be drawn in the back of the robot
        ballX = new float[] {-cw(w * 3 / 8), -cw(w * 3 / 8), -cw(w * 3 / 8), -cw(w * 1.5 / 8), -cw(w * 1.5 / 8)};
        ballY = new float[] {ch(h / 4), ch(0), -ch(h / 4), ch(h / 8), -ch(h / 8)};

        setupBox2D(x, y, angle);
    }


    /**
     * Set up the Box2D physics for the robot
     */
    void setupBox2D(float x, float y, float angle) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);
        bodyDef.angle = radians(angle);

        bodyDef.linearDamping = 7.5;
        bodyDef.angularDamping = 6.5;
        
        body = box2D.createBody(bodyDef);
        
        // create the robot shape
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

        // create the intake shape
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
    
    /**
     * Update shooting and intaking
     */
    void update(ArrayList<PowerCell> powerCells) {
        // if the robot is currently charging the shooter
        if(state == 2) {
            if(numBalls != 0) {
                shooterSpeed += shooterSpeedBarVelocity;
                if(shooterSpeed >= MAX_SHOOTER_SPEED) {
                    shooterSpeed = MAX_SHOOTER_SPEED;
                    shooterSpeedBarVelocity *= -1;
                }
                else if(shooterSpeed <= 0) {
                    shooterSpeed = 0;
                    shooterSpeedBarVelocity *= -1;
                }
            }
            else {
                state = 0;
            }
        }
        // if the robot is currently shooting and has balls to shoot
        if(state == 3 && goalStatus == 0 && numBalls > 0) {
            // ensure they can't shoot balls too fast
            if(millis() - lastShotTime >= TIME_BETWEEN_SHOTS) {
                lastShotTime = millis();
                numBalls--;
                Vec2 loc = body.getTransform().p;
                powerCells.add(new PowerCell(loc.x + cos(body.getAngle()) * w / 2, loc.y + sin(body.getAngle()) * w / 2,
                    cos(body.getAngle()) * shooterSpeed + body.getLinearVelocity().x, 
                    sin(body.getAngle()) * shooterSpeed + body.getLinearVelocity().y));
                if(numBalls == 0) {
                    state = 0;
                }
            }
        }
        // if the robot is currently dumping balls and is touching a goal
        else if(state == 3 && goalStatus != 0) {
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
        // if the robot is currently intaking balls
        else if(state == 1) {
            // go through every power cell and see if it is touching the intake
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
        // if the robot is currently in the neutral state
        else if(state == 0) {
        }
    }

    /**
     * Register a Power Cell as touching the intake
     */
    void contactCell(PowerCell cell) {
        contactCells.add(cell);
    }

    /**
     * Unregister a Power Cell as touching the intake
     */
    void endContactCell(PowerCell cell) {
        contactCells.remove(cell);
    }
    /**
     * Apply a force to the center of the Robot
     */
    void applyForce(PVector force) {
        body.applyForceToCenter(new Vec2(force.x, force.y));
    }
    
    /**
     * Apply a torque to the robot (counterclockwise is positive)
     */
    void applyTorque(float torque) {
        body.applyTorque(torque);
    }
    
    /**
     * Draw the robot's frame, intake, and the stored power cells
     */
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

            fill(intakeColor);
            rect(cw(w / 2 - w / 8), 0, cw(w / 4), ch(w / 2));

            for(int i = 0; i < numBalls; i++) {
                image(powerCell, ballX[i], ballY[i]);
            }
        
        popMatrix();
    }

    void showShooterBar() {
        pushMatrix();
        
            Vec2 loc = body.getTransform().p;
            // println(loc);
            translate(cx(loc.x), height - cy(loc.y));

            noStroke();
            fill(intakeColor);
            
            rectMode(CORNER);
            float ratio = shooterSpeed / MAX_SHOOTER_SPEED;
            rect(cw(w * 9 / 16), cw(h * 3 / 4) - cw(h * 3 / 2) * ratio, cw(w / 8), cw(h * 3 / 2) * ratio);

            rectMode(CENTER);
            stroke(0);
            noFill();
            rect(cw(w * 5 / 8), 0, cw(w / 8), cw(h * 3 / 2));
        
        popMatrix();
    }
    
    /**
     * look at the currently pressed keys and apply forces/update state as necessary
     */
    void handleInput(HashSet<Character> keys, HashSet<Integer> keyCodes) {
        if(wasd) {
            if(keys.contains('d')) {
                turnClock();
                if(state == 3) state = 0;
            }
            if(keys.contains('a')) {
                turnCounter();
                if(state == 3) state = 0;
            }
            if(keys.contains('w')) {
                moveForward();
                if(state == 3) state = 0;
            }
            if(keys.contains('s')) {
                moveBackward();
                if(state == 3) state = 0;
            }

            // begin charging the shooter
            if(keys.contains(' ') && state == 0 && numBalls != 0) {
                state = 2;
                // reset the shooter bar
                shooterSpeed = 0;
                shooterSpeedBarVelocity = 1;
            }
            // begin shooting when the spacebar is released
            if(!keys.contains(' ') && state == 2) {
                state = 3;
            }
            // begin intaking when the f key is pressed and not shooting
            if(keys.contains('f') && state == 0) {
                state = 1;
            }
            if(!keys.contains('f') && state == 1) {
                state = 0;
            }
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

    /**
     * Rotate the robot clockwise
     */
    void turnClock() {
        applyTorque(-TURN_TORQUE);
    }

    /**
     * Rotate the robot counter-clockwise
     */
    void turnCounter() {
        applyTorque(TURN_TORQUE);
    }

    /**
     * Move the robot in the direction it is currently facing
     */
    void moveForward() {
        PVector moveForce = PVector.fromAngle(body.getAngle()).mult(DRIVE_FORCE);
        applyForce(moveForce);
    }

    /**
     * Move the robot in the opposite direction it is currently facing
     */
    void moveBackward() {
        PVector moveForce = PVector.fromAngle(body.getAngle() + PI).mult(DRIVE_FORCE);
        applyForce(moveForce);
    }

    /**
     * Register a goal that is being touched
     */
    void setGoal(boolean isRed) {
        goalStatus = isRed ? 1 : 2;
    }

    /**
     * Unregister a goal as being touched
     */
    void removeGoal() {
        goalStatus = 0;
    }
    
    /**
     * Remove the Robot from the Box2D world and physics calculations
     */
    void removeFromWorld() {
        if(body != null) {
            box2D.destroyBody(body);
        }
    }
}