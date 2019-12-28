from Robot import *
from KeyHandler import *
from Debug import *

bodies = []
robots = []

def setup():
    size(1200, 800)

    robotBlue = Robot(PVector(width / 3, height / 2), 0, 100, 150, color(50, 50, 255))
    robotRed = Robot(PVector(width * 2 / 3, height / 2), 0, 100, 150, color(255, 50, 50))

    bodies.append(robotBlue)
    bodies.append(robotRed)
    robots.append(robotBlue)
    robots.append(robotRed)

def draw():
    update()
    show()

def update():
    if getKey('w'):
        robots[0].applyForceRel(PVector(0, ROBOT_APPLIED_FORCE))
    if getKey('s'):
        robots[0].applyForceRel(PVector(0, -ROBOT_APPLIED_FORCE))
    if getKey('a'):
        robots[0].applyTorque(-ROBOT_APPLIED_TORQUE)
    if getKey('d'):
        robots[0].applyTorque(ROBOT_APPLIED_TORQUE)

    robots[0].applyForceRel(PVector(0, 1000), PVector(-50, 75))

    for body in bodies:
        body.update()

def show():
    pushMatrix()

    scale(1, -1)
    translate(0, -height)

    background(200)
    for body in bodies:
        body.show()

    popMatrix()
