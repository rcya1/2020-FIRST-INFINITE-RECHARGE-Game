void beginContact(Contact contact) {
    Fixture fixture1 = contact.getFixtureA();
    Fixture fixture2 = contact.getFixtureB();

    Object o1 = fixture1.getUserData();
    Object o2 = fixture2.getUserData();

    if(o1 instanceof Robot && o2 instanceof PowerCell) {
        handleRobotCell((Robot) o1, (PowerCell) o2);
    }
    else if(o2 instanceof Robot && o1 instanceof PowerCell) {
        handleRobotCell((Robot) o2, (PowerCell) o1);
    }

    if(o1 instanceof PowerCell && o2 instanceof Boundary) {
        handleCellBoundary((PowerCell) o1, (Boundary) o2);
    }
    else if(o2 instanceof PowerCell && o1 instanceof Boundary) {
        handleCellBoundary((PowerCell) o2, (Boundary) o1);
    }
}

public void handleRobotCell(Robot robot, PowerCell cell) {
    robot.contactCell(cell);
}

public void handleCellBoundary(PowerCell cell, Boundary boundary) {
    if(boundary.isGoal) {
        float speed = cell.getLinearVelocitySquared();
        println(speed);
        if(speed > 1257 && speed < 2590) {
            if(boundary.isRed) {
                redScore += 2;
            }
            else {
                blueScore += 2;
            }
            powerCells.remove(cell);
            scheduleDelete.add(cell);
        }
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
