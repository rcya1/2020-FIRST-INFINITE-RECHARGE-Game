def drawPVector(pos, vector):
    stroke(0)
    strokeWeight(5)
    point(pos.x, pos.y)
    end = PVector.add(pos, vector)
    point(end.x, end.y)

    strokeWeight(2)
    line(pos.x, pos.y, end.x, end.y)
