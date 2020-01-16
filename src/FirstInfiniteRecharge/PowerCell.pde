class PowerCell {

    float w, h;
    
    BodyDef bodyDef;
    Body body;
    FixtureDef fixtureDef;  

    Vec2 lastPosition;

    static final float FRICTION = 1.0;
    static final float RESTITUTION = 0.4;
    static final float DENSITY = 2.0;
    
    PowerCell(float x, float y) {
        w = gx(getWRatio(powerCell.width));
        h = gy(getHRatio(powerCell.height));

        lastPosition = new Vec2();

        setupBox2D(x, y);
    }

    void setupBox2D(float x, float y) {
        bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = new Vec2(x, y);
        bodyDef.linearDamping = 3.0;
        bodyDef.angularDamping = 2.0;
        
        body = box2D.createBody(bodyDef);
        
        CircleShape shape = new CircleShape();
        shape.m_radius = w / 2;
        
        fixtureDef = new FixtureDef();
        fixtureDef.shape = shape;
        fixtureDef.density = DENSITY;
        fixtureDef.friction = FRICTION;
        fixtureDef.restitution = RESTITUTION;

        fixtureDef.filter.categoryBits = CATEGORY_CELL;
        fixtureDef.filter.maskBits = MASK_CELL;

        fixtureDef.setUserData(this);
        
        body.createFixture(fixtureDef);
    }
    
    void update() {
        
    }
    
    void show() {
        pushMatrix();
        
            imageMode(CENTER);
            Vec2 loc = body.getTransform().p;
            lastPosition = loc;
            translate(cx(loc.x), height - cy(loc.y));
            rotate(-body.getAngle());
            image(powerCell, 0, 0, cw(w), ch(h));
        
        popMatrix();
    }

    void removeFromWorld() {
        if(body != null) box2D.destroyBody(body);
    }
}