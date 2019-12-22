from Robot import *

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
    for body in bodies:
        body.update()
        body.show()
