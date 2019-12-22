class Body(object):

    def __init__(self, pos, angle, mass, moi):
        self.pos = pos
        self.vel = PVector(0, 0)
        self.angle = angle
        self.a_vel = 0

        self.mass = mass
        self.moi = moi
        
    def update(self, force, torque):
        acc = PVector.div(force, self.mass)

        self.vel.add(acc)
        self.pos.add(self.vel)

        a_acc = torque / self.moi
        self.a_vel += a_acc
        self.angle += self.a_vel