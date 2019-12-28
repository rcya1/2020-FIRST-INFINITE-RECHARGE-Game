class Body(object):

    def __init__(self, pos, angle, mass, moi):
        self.pos = pos
        self.vel = PVector(0, 0)
        self.force = PVector(0, 0)
        self.angle = angle
        self.a_vel = 0.0
        self.torque = 0.0

        self.mass = mass
        self.moi = moi

    # apply a force to the center of mass
    def applyForceAbs(self, force_add):
        self.force.add(force_add)

    # apply a force to the center of mass
    def applyForceRel(self, force_add):
        force_add_abs = force_add.rotate(self.angle)
        self.applyForceAbs(force_add_abs)

    # apply a force at a point not at the center of mass
    # both the force and the position of application will be absolute coordinates
    def applyForceAbs(self, force_add, pos_app):
        self.force.add(force_add)
        radius = PVector.sub(pos_app, self.pos)
        cross = PVector.cross(radius, force_add)
        print(force_add, radius)
        self.torque -= cross.mag() * cross.z / abs(cross.z)

    # apply a force at a point not at the center of mass
    # both the force and the position of application will be relative to the robot's center and rotated
    def applyForceRel(self, force_add, pos_app):
        force_add_abs = force_add.rotate(self.angle)
        pos_app_abs = PVector.add(pos_app.rotate(self.angle), self.pos)
        self.applyForceAbs(force_add_abs, pos_app_abs)

    def applyTorque(self, torque_add):
        self.torque += torque_add
        
    def update(self):
        acc = PVector.div(self.force, self.mass)

        self.vel.add(acc)
        self.pos.add(self.vel)

        a_acc = self.torque / self.moi
        self.a_vel += a_acc
        self.angle += self.a_vel

        self.force = PVector(0, 0)
        self.torque = 0.0
