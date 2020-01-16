class Boundary
{
    float w, h;
    boolean counted;
    
    Body body;

    static final float FRICTION = 0.8;
    static final float RESTITUTION = 0.1257;
    static final float DENSITY = 1.257;
    
    Boundary(float x, float y, float w, float h, float angle) {
        this.w = w;
        this.h = h;

        setupBox2D(x, y, angle);
    }

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
        
        body.createFixture(fixtureDef);
    }
    
    void update() {
        
    }
    
    // only used for debugging
    void show() {
        pushMatrix();
        
            rectMode(CENTER);
            fill(255, 0, 0);
            Vec2 loc = body.getTransform().p;
            println(loc);

            translate(cx(loc.x), height - cy(loc.y));
            rotate(-body.getAngle());

            rect(0, 0, cw(w), ch(h));
            line(0, 0, cw(w) / 2, ch(-h) / 2);
        
        popMatrix();
    }
}