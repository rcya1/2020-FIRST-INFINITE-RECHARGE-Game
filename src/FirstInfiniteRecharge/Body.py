from Debug import *

class Body(object):

    # pos - PVector with x and y coordinates
    # angle - angle of rotation in radians
    # mass - mass of the body
    # moi - moment of inertia of the body
    def __init__(self, pos, angle, mass, moi):
        self.pos = pos
        self.vel = PVector(0, 0)
        self.force = PVector(0, 0)
        self.angle = angle
        self.a_vel = 0.0
        self.torque = 0.0

        self.mass = mass
        self.moi = moi

    # apply a force to the center of mass in absolute coordinates
    def applyForceAbs(self, force_add):
        self.force.add(force_add)

    # apply a force to the center of mass relative to the body's orientation
    def applyForceRel(self, force_add):
        force_add_abs = force_add.rotate(-self.angle)
        self.applyForceAbs(force_add_abs)
        drawPVector(self.pos, force_add_abs)

    # apply a force at a point not at the center of mass
    # both the force and the position of application will be in absolute coordinates
    def applyForceAbsPosAbs(self, force_add, pos_app):
        self.force.add(force_add)
        radius = PVector.sub(pos_app, self.pos)
        cross = PVector.cross(radius, force_add)

        torque = cross.mag()
        if cross.z >= 0:
            torque *= -1
        self.applyTorque(torque)
        drawPVector(pos_app, force_add)

    # apply a force at a point not at the center of mass
    # both the force and the position of application will be relative to the robot's center and rotated
    def applyForceRelPosRel(self, force_add, pos_app):
        force_add_abs = force_add.rotate(-self.angle)
        pos_app_abs = PVector.add(pos_app.rotate(-self.angle), self.pos)
        self.applyForceAbsPosAbs(force_add_abs, pos_app_abs)

    # apply a force at a point not at the center of mass
    # the force will be in absolute coordinates
    # the position of application will be relative to the robot's center and rotated
    def applyForceAbsPosRel(self, force_add, pos_app):
        pos_app_abs = PVector.add(pos_app.rotate(-self.angle), self.pos)
        self.applyForceAbsPosAbs(force_add, pos_app_abs)

    # apply a torque to the body
    def applyTorque(self, torque_add):
        self.torque += torque_add
        
    # update the state of the body
    # includes position, velocity, acceleration, angle, angular velocity, and angular acceleration
    def update(self):
        acc = PVector.div(self.force, self.mass)

        self.vel.add(acc)
        self.pos.add(self.vel)

        a_acc = self.torque / self.moi
        self.a_vel += a_acc
        self.angle += self.a_vel

        while self.angle >= 2 * PI:
            self.angle -= 2 * PI
        while self.angle < 0:
            self.angle += 2 * PI

        self.force = PVector(0, 0)
        self.torque = 0.0
