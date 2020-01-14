// NOTE: All function names here are deliberately shortened in order to increase code readability
// cw - convertWidth
// ch - convertHeight
// cx - convertX
// cy - convertY

// converts ratio of total width to pixels 
public float cw(float ratio) {
    return width * ratio;
}

// converts ratio of total height to pixels 
public float ch(float ratio) {
    return height * ratio;
}

// converts ratio of total width to pixels while considering padding
public float cx(float ratio) {
    if(topPadding) {
        return width * ratio;
    }
    else {
        int paddingWidth = (width - field.width) / 2;
        return (width - paddingWidth * 2) * ratio + paddingWidth;
    }
}

// converts ratio of total height to pixels while considering padding
public float cy(float ratio) {
    if(topPadding) {
        int paddingHeight = (height - field.height) / 2;
        return (height - paddingHeight * 2) * ratio + paddingHeight;
    }
    else {
        return height * ratio;
    }
}

public float getXRatio(float x) {
    if(topPadding) {
        return x / width;
    }
    else {
        int paddingWidth = (width - field.width) / 2;
        return (x - paddingWidth) / (width - paddingWidth * 2);
    }
}

public float getYRatio(float y) {
    if(topPadding) {
        int paddingHeight = (height - field.height) / 2;
        return (y - paddingHeight) / (height - paddingHeight * 2);
    }
    else {
        return y / height;
    }
}

public float getWRatio(float w) {
    return w / width;
}

public float getHRatio(float h) {
    return h / height;
}

int pressMouseX = 0, pressMouseY = 0;

void mousePressed() {
    println("Press X: ", getXRatio(mouseX), "Press Y: ", getYRatio(mouseY));
    float d = dist(mouseX, mouseY, pressMouseX, pressMouseY);
    println("Width: ", getWRatio(d), "Height: ", getHRatio(d));

    pressMouseX = mouseX;
    pressMouseY = mouseY;
}
