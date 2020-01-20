/**
 * Call extra code when two objects collide with each other
 */
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

/**
 * Handle collision when a robot's intake hits a Power Cell
 * Registers the Power Cell with the robot as currently touching
 */
public void handleRobotCell(Robot robot, PowerCell cell) {
    robot.contactCell(cell);
}

/**
 * Handle collision when a power cell hits a boundary
 * Checks if the boundary is a goal and then does a check on the speed to see if it will go in
 */
public void handleCellBoundary(PowerCell cell, Boundary boundary) {
    if(getCurrentMatchTimeLeft() > 0) {
        if(boundary.isGoal) {
            float speed = cell.getLinearVelocitySquared();
            // println(speed);

            // randomly chosen numbers btw
            if(speed / 2 < 1257) {
                texts.add(new Text("Too Slow!", boundary.getX(), boundary.getY(), color(0), 1, 255, boundary.isRed));
            }
            else if(speed / 2 > 2590) {
                texts.add(new Text("Too Fast!", boundary.getX(), boundary.getY(), color(0), 1, 255, boundary.isRed));
            }
            else {
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
}


/**
 * Handle collision when a robot hits a boundary
 * Registers the boundary with the robot if the boundary is a goal
 */
public void handleRobotBoundary(Robot robot, Boundary boundary) {
    if(boundary.isGoal) {
        robot.setGoal(boundary.isRed);
    }
}

/**
 * Call extra code when two objects stop colliding with each other
 */
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

/**
 *  Unregister Power Cell with robot
 */
public void endHandleRobotCell(Robot robot, PowerCell cell) {
    robot.endContactCell(cell);
}

/**
 * Unregister goal with robot
 */
public void endHandleRobotBoundary(Robot robot, Boundary boundary) {
    if(boundary.isGoal) {
        robot.removeGoal();
    }
}
