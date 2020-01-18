void beginContact(Contact contact) {
    Fixture fixture1 = contact.getFixtureA();
    Fixture fixture2 = contact.getFixtureB();

    Object o1 = fixture1.getUserData();
    Object o2 = fixture2.getUserData();

    if(o1 instanceof Robot && o2 instanceof PowerCell) {
        Robot robot = (Robot) o1;
        PowerCell cell = (PowerCell) o2;
        
        robot.contactCell(cell);
    }
    else if(o2 instanceof Robot && o1 instanceof PowerCell) {
        Robot robot = (Robot) o2;
        PowerCell cell = (PowerCell) o1;
        
        robot.contactCell(cell);
    }
}

void endContact(Contact contact) {
    Fixture fixture1 = contact.getFixtureA();
    Fixture fixture2 = contact.getFixtureB();

    Object o1 = fixture1.getUserData();
    Object o2 = fixture2.getUserData();

    if(o1 instanceof Robot && o2 instanceof PowerCell) {
        Robot robot = (Robot) o1;
        PowerCell cell = (PowerCell) o2;
        
        robot.endContactCell(cell);
    }
    else if(o2 instanceof Robot && o1 instanceof PowerCell) {
        Robot robot = (Robot) o2;
        PowerCell cell = (PowerCell) o1;
        
        robot.endContactCell(cell);
    }
}
