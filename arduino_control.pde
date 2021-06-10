boolean arduinoOn = false; //Arduinoを使用するときはtrueにする。

Serial serialPort;  // Arduinoにデータを送るシリアルポート
boolean firstContact = false;  //Arduinoからのはじめの送信を確認する
byte[] inByte = new byte[3]; // 受信データ用バッファ

int oval1; // サーボ1用変数
int oval2; // サーボ2用変数

//サーボの位置を初期化
void initServo(){
  oval1 = oval2 = 20;
  sendToServo(1, oval1); //ゲートを閉じる
  sendToServo(2, oval2); //ゲートを閉じる 
}

// シリアルポートにデータが受信されると呼び出されるメソッド
void serialEvent(Serial port) {
  inByte = port.readBytes();

  if(firstContact == false) {
    if(inByte[0] == 'C') {
      println("connect!");
      port.clear();
      firstContact = true;
      initServo();
    }
  }
}

// シリアルポートにサーボの値を送るメソッド
void sendToServo(int id, int value){
  if(!firstContact) return;
  int v = value;
  if(v < 15) v = 15; // サーボの最小値。個体差による。
  if(v > 125) v = 125; // サーボの最大値。個体差による。
  serialPort.write((byte)'S');
  serialPort.write((byte)id);
  serialPort.write((byte)v);
}
