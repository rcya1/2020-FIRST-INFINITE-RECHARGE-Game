class Boundary
{
    float w, h;
    boolean counted;
    
    Body body;

    static final float FRICTION = 0.3;
    static final float RESTITUTION = 0.1257;
    static final float DENSITY = 1.257;
    
    Boundary(float x, float y, float w, float h) {
        this.w = w;
        this.h = h;

        setupBox2D(x, y);
    }

    void setupBox2D(float x, float y) {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyType.STATIC;
        bodyDef.position = box2D.coordPixelsToWorld(x, y);
        
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
        
        body.createFixture(fixtureDef);
    }
    
    void update() {
        
    }
    
    // only used for debugging
    void show() {
        pushMatrix();
        
            rectMode(CENTER);
            fill(255, 0, 0);
            Vec2 loc = box2D.getBodyPixelCoord(body);
            translate(loc.x, loc.y);
            rotate(-body.getAngle());
            rect(0, 0, w, h);
        
        popMatrix();
    }
}