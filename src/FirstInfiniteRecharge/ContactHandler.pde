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

    if(o1 instanceof Robot && o2 instanceof Boundary) {
        handleRobotBoundary((Robot) o1, (Boundary) o2);
    }
    else if(o2 instanceof Robot && o1 instanceof Boundary) {
        handleRobotBoundary((Robot) o2, (Boundary) o1);
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
                blueStationAvailable++;
            }
            else {
                blueScore += 2;
                redStationAvailable++;
            }
            powerCells.remove(cell);
            scheduleDelete.add(cell);
        }
    }
}

public void handleRobotBoundary(Robot robot, Boundary boundary) {
    if(boundary.isGoal) {
        robot.setGoal(boundary.isRed);
    }
}

void endContact(Contact contact) {
    Fixture fixture1 = contact.getFixtureA();
    Fixture fixture2 = contact.getFixtureB();

    Object o1 = fixture1.getUserData();
    Object o2 = fixture2.getUserData();

    if(o1 instanceof Robot && o2 instanceof PowerCell) {
        endHandleRobotCell((Robot) o1, (PowerCell) o2);
    }
    else if(o2 instanceof Robot && o1 instanceof PowerCell) {
        endHandleRobotCell((Robot) o2, (PowerCell) o1);
    }

    if(o1 instanceof Robot && o2 instanceof Boundary) {
        endHandleRobotBoundary((Robot) o1, (Boundary) o2);
    }
    else if(o2 instanceof Robot && o1 instanceof Boundary) {
        endHandleRobotBoundary((Robot) o2, (Boundary) o1);
    }
}

public void endHandleRobotCell(Robot robot, PowerCell cell) {
    robot.endContactCell(cell);
}

public void endHandleRobotBoundary(Robot robot, Boundary boundary) {
    if(boundary.isGoal) {
        robot.removeGoal();
    }
}
