import de.looksgood.ani.*;
import processing.serial.*;
int num = 100;
float time = 0;  
float melt_y= height*6;
float portion1 = 0;
float dummy = 0;

boolean flag1 = true;
boolean flag2 = false;
boolean flag3 = false;
boolean flag4 = true;

float s = 0;

color ballColor = color(36, 190, 255);
color hotColor = color(255, 65, 36);

Ball ball1;
Ball ball2;
Ball ball3;

TypoRotation marble1;
TypoFall marble2;
TypoFall marble3;

Spot[] spot = new Spot[num];

AniSequence seq1;
AniSequence seq2;

void setup() {

  fullScreen();
 //c size(800,600);
    //Arduino設定
  if (arduinoOn) {
    printArray(Serial.list()); // 使用可能なシリアルポート一覧の出力。デバッグ用
    String portName = Serial.list()[0]; // 使用するシリアルポート名
    serialPort = new Serial(this, portName, 9600);
    serialPort.buffer(inByte.length); // 読み込むバッファの長さをの指定
    initServo();
  }

  ball1 = new Ball( width/2, -80, 80);
  ball2 = new Ball( -1000, height/2, 4);
  ball3 = new Ball(width/2, height/2, 0);

  marble1 = new TypoRotation("MARBLE", width/2, height/2);
  marble2 = new TypoFall("MARBLE", width/2, -50);
  marble3 = new TypoFall("MARBLE", width/2, -50);

  colorMode(RGB);
  smooth(8);

  Ani.init(this);

  seq1 = new AniSequence(this);
  seq1.beginSequence();
  seq1.add(Ani.to(this.ball1, 1.2, "y", height/2, Ani.BOUNCE_OUT));
  seq1.add(Ani.to(this.ball2, 1.2, "x", width+ball2.ballSize*20, Ani.CUBIC_OUT));
  seq1.endSequence();

  seq2 = new AniSequence(this);
  seq2.beginSequence();

  seq2.add(Ani.to(this, 2.5, "melt_y", 0, Ani.QUINT_OUT, "onEnd:erase"));

  seq2.beginStep();
  seq2.add(Ani.to(this, 1.2, "melt_y", -height/3, Ani.QUINT_OUT, "onStart:drawDrop"));
  seq2.add(Ani.to(this, 1.2, "s", 1.2, Ani.EXPO_OUT));
  seq2.endStep();

  seq2.add(Ani.to(this, 1.2, "melt_y", -height/4*3, Ani.QUINT_OUT, "onEnd:mold"));

  seq2.beginStep();
  seq2.add(Ani.to(this.ball3, 1.5, "ballSize", 80, Ani.QUINT_OUT));
  seq2.add(Ani.to(this, 1.5, "s", 0, Ani.QUINT_OUT));
  seq2.endStep();

  seq2.add(Ani.to(this.ball3, 1.5, "x", width+ball3.ballSize, Ani.BACK_IN, "onEnd:servo1"));

  seq2.beginStep();
  seq2.add(Ani.to(this.ball3, 1.5, 2.8, "x", width/2, Ani.BACK_OUT));
  seq2.add(Ani.to(this, 1.5, 2.8, "portion1", 1.0, Ani.QUINT_IN));
  seq2.endStep();

  seq2.beginStep();
  seq2.add(Ani.to(this.ball3, 3.0, 1.0, "x", width+ball3.ballSize, Ani.QUINT_IN, "onEnd:servo2"));
  seq2.add(Ani.to(this.ball3, 3.0, 1.0, "y", height, Ani.QUINT_IN));
  seq2.endStep();
  
  seq2.add(Ani.to(this , 2.0, "cummy", height, Ani.QUINT_IN, "onEnd:initServo"));
  seq2.endSequence();


}

void mousePressed() {
  seq1.start();
  marble1.init();
  marble2.init();
  for (int i = 0; i < num; i++) {
    PVector loc = new PVector(width/2, height/2);
    PVector vec = new PVector(random(-1, 1)*12, random(-1, 1)*12);
    spot[i] = new Spot(loc, vec, random(20, 40));
  }
  num = 100;
  time = 0;  
  melt_y= height*6;
  portion1 = 0;

  flag1 = true;
  flag2 = false;
  flag3 = false;
  flag4 = true;

  s = 0;

  initServo();
}
void draw() {
  background(255);
  textSize(10);
  stroke(128, 200, 256, 130);
  strokeWeight(3);

  ellipse(ball2.x, ball2.y, ball2.ballSize*30, ball2.ballSize/3);
  if (ball1.x - 80 <= ball2.x ) {
    fill(ballColor);
    marble1.circleDisp();
    for (int i = 0; i < num; i++) {
      spot[i].move();
      spot[i].display();
      spot[i].fade();
    }
    if (ball2.x - 70 <= ball1.x + 90) {
      filter(INVERT);
    }
  } else {
    fill(ballColor);
    noStroke();
    ellipse(ball1.x, ball1.y, ball1.ballSize, ball1.ballSize);
  }
  if (marble1.locate.y<=-200) {
    colorMode(RGB);
    fill(lerpColor(ballColor, hotColor, portion1));
    if (flag4) {
      seq2.start();
      flag4 =false;
    }
    marble2.fallDisp(height/2);
  }
  if (marble2.locates[0].y>=height/2-50&&marble2.locates[5].y>=height/2-5*30) {
    pushMatrix();
    translate(0, melt_y);
    stroke(hotColor, 200);
    float x = marble2.locates[0].x-100;

    while (x < marble2.locates[5].x+100) {
      line(x, 100 + 30 * noise(x / 100, time), x, height/3*2);
      x = x + 1;
    }
    popMatrix();
    if (melt_y>=1) {
      melt_y *= 0.959;
    }
    time = time + 0.02;
    if (marble3.locates[0].y>=height/3*2-100&&marble3.locates[5].y>=height/3*2-100) {
    }
    if (flag1) {
      seq2.start();
      flag1 = false;
    }
    if (flag2) {
      int x2 =width/2;
      int y =height/2;

      pushMatrix();
      translate(x2, y);
      scale(s);
      noStroke();

      fill(hotColor);
      triangle(0, -50, -30, 0, 30, 0);
      arc(0, 10, 63, 60, radians(-30), radians(210), OPEN);
      popMatrix();
    }
    if (flag3) {
      
      fill(lerpColor(hotColor, ballColor, portion1));
      ellipse(ball3.x, ball3.y, ball3.ballSize, ball3.ballSize);
    }
  }
}

void erase() {
  marble2.show = false;
}

void drawDrop() {
  flag2 = true;
}

void mold() {
  flag3 = true;
}
