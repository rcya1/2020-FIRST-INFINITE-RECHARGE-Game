class PowerCell {
    float w, h;
    
    BodyDef bodyDef;
    Body body;
    FixtureDef fixtureDef;  

    Vec2 lastPosition;
    boolean destroyed;

    static final float FRICTION = 1.0;
    static final float RESTITUTION = 0.4;
    static final float DENSITY = 2.0;
    
    PowerCell(float x, float y) {
        w = powerCell.width;
        h = powerCell.height;

        lastPosition = new Vec2();
        destroyed = false;

        setupBox2D(x, y);
    }

    void setupBox2D(float x, float y) {
        bodyDef = new BodyDef();
        bodyDef.type = BodyType.DYNAMIC;
        bodyDef.position = box2D.coordPixelsToWorld(x, y);
        bodyDef.linearDamping = 3.0;
        bodyDef.angularDamping = 2.0;
        
        body = box2D.createBody(bodyDef);
        
        PolygonShape shape = new PolygonShape();
        float box2DWidth = box2D.scalarPixelsToWorld(w);
        float box2DHeight = box2D.scalarPixelsToWorld(h);
        shape.setAsBox(box2DWidth / 2, box2DHeight / 2);
        
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
            Vec2 loc = destroyed ? lastPosition : box2D.getBodyPixelCoord(body);
            lastPosition = loc;
            translate(loc.x, loc.y);
            rotate(-body.getAngle());
            image(powerCell, 0, 0, w, h);
        
        popMatrix();
    }

    void removeFromWorld() {
        if(body != null) box2D.destroyBody(body);
        destroyed = true;
    }

    void addToWorld(PVector position, float angle) {
        bodyDef.position = box2D.coordPixelsToWorld(position);
        bodyDef.angle = angle;
        body = box2D.createBody(bodyDef);
        body.createFixture(fixtureDef);
        destroyed = false;
    }
}