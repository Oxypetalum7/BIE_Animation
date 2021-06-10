class Ball {
  int x;
  int y;
  int ballSize;
  Ball(int _x, int _y, int _ballSize) {
    this.x = _x;
    this.y = _y;
    this.ballSize = _ballSize;
  }
  void servo1() {
    if (arduinoOn) {
      oval1 = 120;
      sendToServo(1, oval1);
    }
  }

  void servo2() {
    if (arduinoOn) {
      oval2 = 120;
      sendToServo(2, oval2);
    }
  }
}
