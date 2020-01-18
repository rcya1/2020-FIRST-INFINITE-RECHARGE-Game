class PowerCell {

    float w, h;
    
    BodyDef bodyDef;
    Body body;
    FixtureDef fixtureDef;  

    boolean destroyed;
    boolean airborne;

    static final float FRICTION = 1.0;
    static final float RESTITUTION = 0.4;
    static final float DENSITY = 2.0;
    
    PowerCell(float x, float y) {
        this(x, y, 0, 0);
    }

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

    void setupBox2D(float x, float y) {
        bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);

        if(airborne) {
            bodyDef.bullet = true;
            bodyDef.linearDamping = 1.5;
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
    
    void update() {
        if(body.getLinearVelocity().lengthSquared() < 400) {
            setNormal();
            airborne = false;
        }
    }
    
    void show() {
        if(!destroyed) {
            pushMatrix();
            
                imageMode(CENTER);
                Vec2 loc = body.getTransform().p;
                translate(cx(loc.x), height - cy(loc.y));
                rotate(-body.getAngle());
                image(powerCell, 0, 0, cw(w), ch(h));

                if(airborne) ellipse(0, 0, cw(w), ch(h)); // debug
            
            popMatrix();
        }
    }

    void removeFromWorld() {
        if(body != null) box2D.destroyBody(body);
        destroyed = true;
    }

    void setNormal() {
        airborne = false;
        Filter filter = new Filter();
        filter.categoryBits = CATEGORY_CELL;
        filter.maskBits = MASK_CELL;
        body.getFixtureList().setFilterData(filter);
        body.setLinearDamping(3.0);
    }
}
