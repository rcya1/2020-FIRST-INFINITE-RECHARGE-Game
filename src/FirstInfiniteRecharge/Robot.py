from Constants import *
from Body import *

class Robot(Body):

    def __init__(self, pos, angle, w, h, fill_color):
        super(Robot, self).__init__(pos, angle, w * h * ROBOT_DENSITY, w * w * w * h / 3 + w * h * h * h / 3)
        self.w = w
        self.h = h
        self.fill_color = fill_color

    def update(self):
        force = PVector(0, 0)
        torque = 0

        super(Robot, self).update(force, torque)

    def show(self):
        pushMatrix()

        translate(self.pos.x, self.pos.y)
        rotate(self.angle)

        stroke(0)
        strokeWeight(1)
        fill(self.fill_color)

        rectMode(CENTER)
        rect(0, 0, self.w, self.h)
        
        popMatrix()
