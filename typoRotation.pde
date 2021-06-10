class TypoRotation extends Typo {
  float velocity = 30;
  PVector temp1;
  float temp2;
  float theta1, theta2 ;
  float radius = 0;
  int frames = 90;
  float Rspeed = 15;
  float t = 0;
  float y = 7;
  TypoRotation(String _word, int _locate_x, int _locate_y) {
    word = _word;
    locate = new PVector(_locate_x, _locate_y);
    temp1 = new PVector(_locate_x, _locate_y);
    temp2 = velocity;
  }

  void circleDisp() {
    for (int i=0; i<word.length(); i++) {
      pushMatrix();
      translate(locate.x, locate.y);
      rotate(theta1+i*TWO_PI/word.length());
      translate(radius, 0);
      rotate(theta2);
      textSize(50);
      textAlign(CENTER, CENTER);
      fill(ballColor);
      text(word.charAt(i), 0, 0);
      popMatrix();
    }
    theta2 += Rspeed*TWO_PI/frames;
    radius += velocity;
    velocity *= 0.78;
    Rspeed *= 0.94;
    if (velocity <= 0.00001&&locate.y>=-200) { 
      up();
    }
  }
  void up() {
    locate.y += y;
    y += t;
    t -= 0.06;
  }
  void init() {
    y = 7;
    t = 0;
    locate = new PVector(temp1.x, temp1.y);
    radius = 0;
    velocity = temp2;
    Rspeed = 15;
  }
}
