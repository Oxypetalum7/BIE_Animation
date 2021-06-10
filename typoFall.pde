class TypoFall extends Typo {
  PVector locates[];
  boolean f[];
  boolean show = true;
  PVector d_locate;
  TypoFall(String _word, int _locate_x, int _locate_y) {
    word = _word;
    d_locate = new PVector(_locate_x, _locate_y);
    locates = new PVector[word.length()];
    for (int i= 0; i < word.length(); i++) {
      locates[i] = new PVector(_locate_x, _locate_y);
    }
    if (word.length()%2==0) {
      for (int i = word.length()/2; i > 0; i--) {
        locates[word.length()/2-i].x -= (i-0.5)*50;
        locates[word.length()-i].x += (word.length()/2-i+0.5)*50;
      }
    }
    f = new boolean[word.length()];
    for (int i = 0; i< word.length(); i++) {
      f[i] = true;
    }
  }

  void fallDisp(float point) {
    if (word.length()%2==0) {
      for (int i = 0; i < word.length(); i++) {

        if (show) {

          text(word.charAt(i), locates[i].x, locates[i].y);
        }
        if (f[i]) {
          Ani.to(locates[i], 3.0, 0.1*i+0.5, "y", point-i*20, Ani.QUINT_OUT);
          f[i]= false;
        }
      }
    }
  }
  
  void init() {
    locates = new PVector[word.length()];
    for (int i= 0; i < word.length(); i++) {
      locates[i] = new PVector(d_locate.x, d_locate.y);
      f[i] =true;
    }
    if (word.length()%2==0) {
      for (int i = word.length()/2; i > 0; i--) {
        locates[word.length()/2-i].x -= (i-0.5)*50;
        locates[word.length()-i].x += (word.length()/2-i+0.5)*50;
      }
    }
    show = true;
  }
}
