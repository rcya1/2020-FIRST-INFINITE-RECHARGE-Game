vectorA = []
vectorB = []

def drawPVector(pos, vector):
    vectorA.append(pos)
    vectorB.append(vector)

def drawPVectors():
    for i in range(len(vectorA)):
        pos = vectorA[i]
        vector = vectorB[i]

        stroke(0)
        strokeWeight(5)
        point(pos.x, pos.y)
        end = PVector.add(pos, vector)
        point(end.x, end.y)

        strokeWeight(2)
        line(pos.x, pos.y, end.x, end.y)

def resetDebug():
    for i in range(len(vectorA)):
        vectorA.pop()
        vectorB.pop()
