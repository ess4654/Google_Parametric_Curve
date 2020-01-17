import ddf.minim.*;

Minim minim;
AudioPlayer player;

float DefaultScale = 0.4;
float FR = 30;
float SampleRate = 6;

boolean running = true;
boolean DEBUGGING = false;
boolean SoundOn = true;

float t = 0;
float scale = DefaultScale;
color transparent = color(0, 0, 0, 0);
color blue  = color(66, 133, 244);
color red = color(234, 67, 53);
color yellow = color(251, 188, 5);
color green = color(52, 168, 83);
color white = color(255, 255, 255);
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Integer> lineColor = new ArrayList<Integer>();
ArrayList<Integer> strokes = new ArrayList<Integer>();

void setup()
{
  fullScreen(P2D);
  //size(800, 800, P2D);
  background(0);
  noFill();
  smooth();
  frameRate(FR);
  
  minim = new Minim(this);
  player = minim.loadFile("Google Song.mp3");
  if(SoundOn)
    player.loop();
}

void keyPressed() {
  if(key == ' ')
    running = !running;
  if(key == 'r')
    reset();
}

void reset()
{
  frameCount = -1;
  t = 0;
  lineColor.clear();
  strokes.clear();
  points.clear();
  minim.stop();
  minim = new Minim(this);
  if(SoundOn)
    player.loop();
  scale = DefaultScale;
}

float updateT(float T)
{
  T += 0.004;
  
  if(T >= 131.925) { //END
    strokes.add(1);
    lineColor.add(color(0, 0, 0));
    return 44 * PI;
  }
  if(T >= 125.665 && T < 131.925) { //e INNER
    strokes.add(3);
    lineColor.add(red);
    return T + 0.004;
  }
  if(T >= 119.379 && T < 125.665) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 125.665;
  }
  if(T >= 113.099 && T < 119.379) { //SECOND O OUTTER
    strokes.add(3);
    lineColor.add(yellow);
    return T;
  }
  if(T >= 106.816 && T < 113.099) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 113.099;
  }
  if(T >= 100.532 && T < 106.816) { //l
    strokes.add(3);
    lineColor.add(green);
    return T + 0.004;
  }
  if(T >= 94.210 && T < 100.532) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 100.532;
  }
  if(T >= 87.970 && T < 94.210) { //g INNER TOP
    strokes.add(3);
    lineColor.add(blue);
    return T + 0.004;
  }
  if(T >= 81.660 && T < 87.970) { //FIRST O INNER
    strokes.add(1);
    lineColor.add(yellow);
    return 87.970;
  }
  if(T >= 75.400 && T < 81.680) { //FIRST O INNER
    strokes.add(3);
    lineColor.add(red);
    return T + 0.004;
  }
  if(T >= 69.101 && T < 75.400) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 75.400;
  }
  if(T >= 62.830 && T < 69.101) { //e OUTER
    strokes.add(3);
    lineColor.add(red);
    return T + 0.004;
  }
  if(T >= 56.543 && T < 62.833) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 62.833;
  }
  if(T >= 50.269 && T < 56.543) { //FIRST O OUTER
    strokes.add(3);
    lineColor.add(red);
    return T + 0.004;
  }
  if(T >= 43.973 && T < 50.269) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 50.269;
  }
  if(T >= 37.703 && T < 43.973) { //SECOND O INNER
    strokes.add(3);
    lineColor.add(yellow);
    return T + 0.004;
  }
  if(T >= 31.384 && T < 37.703) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 37.703;
  }
  if(T >= 25.134 && T < 31.384) { //g INNER BOTTOM
    strokes.add(3);
    lineColor.add(blue);
    return T + 0.004;
  }
  if(T >= 18.850 && T < 25.134) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 25.134;
  }
  if(T >= 12.567 && T < 18.850) { //g OUTER
    strokes.add(3);
    lineColor.add(blue);
    return T;
  }
  if(T >= 6.288 && T < 12.567) { //SKIP
    strokes.add(1);
    lineColor.add(white);
    return 12.567;
  }
  else { //G
    strokes.add(3);
    lineColor.add(blue);
  }
  
  return T;
}

void draw()
{ 
  if(frameCount < FR) return;
  if(t <= 44 * PI && running)
  {
    for(int z = 0; z<SampleRate; z++) {
      t = updateT(t);
      points.add(new PVector(x(t), -y(t)));
      if(DEBUGGING)
        print(t + "\n");
    }
  } else {
    if(!DEBUGGING)
      scale += 0.00053;
  }
  
  translate(width/2 - (550 * (scale/0.4)), height/2 - (140 * (scale/0.4)));
  background(0);
  
  beginShape();
  for(int i = 0; i < points.size(); i++)
  {
    if(points.get(i).x == 0 && points.get(i).y == 0) continue;
    strokeWeight(strokes.get(i));
    stroke(lineColor.get(i));
    point(points.get(i).x * scale, points.get(i).y * scale);
  }
  endShape();
}

float sgn(float x)
{
  if(x == 0) return 0;
  else if(x > 0) return 1;
  else return -1;
}

float theta(float x)
{
  if(x == 0) return 0.5;
  else if(x > 0) return 1;
  else return 0;
}

float SIN(float x)
{
  return sin(x);
}

float x(float t)
{
  return ((-1.0/7*sin(6.0/7 - 13*t) - 3.0/11*sin(14.0/9 - 11*t) - 29.0/7*sin(7.0/12 - 3*t) - 478.0/5*sin(14.0/13 -t) + 87.0/11*sin(2*t + 13.0/5) + 23.0/7*sin(4*t + 21.0/5) + 1.0/4*sin(5*t + 5.0/4) + 8.0/5*sin(6*t + 51.0/11) + 5.0/7*sin(7*t + 17.0/5) + 3.0/11*sin(8*t + 29.0/8) + 11.0/21*sin(9*t + 38.0/9) + 5.0/14*sin(10*t + 25.0/9) + 4.0/11*sin(12*t + 10.0/3) + 1.0/7*sin(14*t + 41.0/12) + 1.0/33*sin(15*t + 37.0/14) + 17530.0/7)*theta(43*PI -t)*theta(t - 39*PI) + (-11.0/7*sin(3.0/7 - 3*t) - 7.0/3*sin(1.0/7 - 2*t) + 8189.0/35*sin(t + 17.0/12) + 17.0/16*sin(4*t + 43.0/10) + 7.0/12*sin(5*t + 32.0/13) + 1.0/3*sin(6*t + 163.0/54) + 3.0/7*sin(7*t + 7.0/6) + 15684.0/11)*theta(39*PI -t)*theta(t - 35*PI) + (-12.0/7*sin(1.0/7 - 12*t) - 44.0/7*sin(7.0/9 - 10*t) - 19.0/2*sin(1.0/2 - 8*t) - 27.0/4*sin(11.0/9 - 7*t) - 129.0/7*sin(3.0/7 - 5*t) + 595.0/19*sin(3*t) + 59.0/7*sin(6*t) + 1689.0/26*sin(t + 1.0/7) + 41.0/11*sin(2*t + 17.0/11) + 104.0/19*sin(4*t + 10.0/13) + 54.0/11*sin(9*t + 19.0/6) + 89.0/15*sin(11*t + 18.0/7) + 27.0/7*sin(13*t + 5.0/2) + 27.0/8*sin(14*t + 21.0/20) + 31.0/15*sin(15*t + 35.0/12) + 24.0/7*sin(16*t + 10.0/11) + 13.0/8*sin(17*t + 27.0/8) + 16.0/9*sin(18*t + 4.0/7) + 15525.0/7)*theta(35*PI -t)*theta(t - 31*PI) + (-5.0/9*sin(3.0/8 - 6*t) - 9.0/8*sin(7.0/11 - 2*t) + 944.0/9*sin(t + 25.0/9) + 29.0/5*sin(3*t + 5.0/4) + 7.0/10*sin(4*t + 1.0/6) + 2.0/5*sin(5*t + 105.0/26) + 20726.0/11)*theta(31*PI -t)*theta(t - 27*PI) + (-1.0/7*sin(9.0/7 - 12*t) - 2.0/11*sin(3.0/7 - 10*t) - 5.0/16*sin(5.0/6 - 6*t) - 4.0/5*sin(5.0/9 - 4*t) - 17.0/11*sin(1.0/7 - 2*t) + 1027.0/7*sin(t + 24.0/11) + 46.0/5*sin(3*t + 27.0/26) + 1.0/5*sin(5*t + 1.0/27) + 4.0/15*sin(7*t + 45.0/17) + 1.0/7*sin(8*t + 5.0/9) + 3.0/11*sin(9*t + 13.0/5) + 2.0/11*sin(11*t + 5.0/7) + 1851.0/2)*theta(27*PI -t)*theta(t - 23*PI) + (-17.0/25*sin(5.0/9 - 20*t) - 2.0/5*sin(17.0/12 - 18*t) - 9.0/8*sin(4.0/13 - 13*t) - 13.0/2*sin(1.0/14 - 7*t) - 103.0/14*sin(7.0/13 - 5*t) + 16.0/11*sin(11*t) + 337.0/4*sin(t + 29.0/8) + 967.0/7*sin(2*t + 18.0/7) + 155.0/4*sin(3*t + 37.0/8) + 22.0/9*sin(4*t + 139.0/46) + 47.0/16*sin(6*t + 74.0/25) + 23.0/5*sin(8*t + 25.0/11) + 16.0/15*sin(9*t + 89.0/30) + 63.0/25*sin(10*t + 4) + 15.0/11*sin(12*t + 32.0/9) + 4.0/13*sin(14*t + 4.0/9) + 16.0/11*sin(15*t + 16.0/11) + 9.0/7*sin(16*t + 42.0/11) + 5.0/8*sin(17*t + 17.0/13) + 4.0/9*sin(19*t + 22.0/7) + 32765.0/13)*theta(23*PI -t)*theta(t - 19*PI) + (11107.0/12 - 3277.0/14*sin(33.0/34 -t))*theta(19*PI -t)*theta(t - 15*PI) + (-2.0/9*sin(4.0/5 - 12*t) - 1.0/5*sin(7.0/9 - 10*t) - 7.0/10*sin(1.0/11 - 4*t) - 190.0/21*sin(13.0/10 - 3*t) - 47.0/20*sin(4.0/5 - 2*t) + 587.0/4*sin(t + 4) + 6.0/13*sin(5*t + 34.0/9) + 9.0/13*sin(6*t + 15.0/14) + 5.0/16*sin(7*t + 49.0/12) + 1.0/9*sin(8*t + 5.0/4) + 3.0/10*sin(9*t + 24.0/7) + 1.0/9*sin(11*t + 17.0/4) + 12809.0/9)*theta(15*PI -t)*theta(t - 11*PI) + (-5.0/14*sin(3.0/8 - 10*t) - 14.0/9*sin(7.0/9 - 4*t) + 1012.0/7*sin(t + 11.0/5) + 17.0/11*sin(2*t + 1.0/4) + 48.0/7*sin(3*t + 18.0/5) + 1.0/9*sin(5*t + 49.0/13) + 5.0/6*sin(6*t + 57.0/13) + 5.0/9*sin(7*t + 33.0/8) + 3.0/10*sin(8*t + 14.0/13) + 11.0/17*sin(9*t + 56.0/19) + 1.0/4*sin(11*t + 45.0/46) + 24548.0/13)*theta(11*PI -t)*theta(t - 7*PI) + (-35.0/34*sin(2.0/7 - 24*t) - 34.0/35*sin(5.0/6 - 21*t) - 5.0/8*sin(1.0/5 - 18*t) - 53.0/16*sin(1.0/5 - 13*t) - 23.0/9*sin(1.0/2 - 10*t) - 71.0/5*sin(7.0/5 - 7*t) - 1189.0/44*sin(1.0/6 - 2*t) + 521.0/3*sin(t + 2.0/5) + 2495.0/24*sin(3*t + 3.0/2) + 139.0/8*sin(4*t + 29.0/8) + 94.0/7*sin(5*t + 1.0/16) + 203.0/13*sin(6*t + 2.0/7) + 87.0/10*sin(8*t + 37.0/11) + 37.0/5*sin(9*t + 23.0/14) + 17.0/5*sin(11*t + 53.0/15) + 26.0/9*sin(12*t + 9.0/8) + 87.0/25*sin(14*t + 39.0/10) + 9.0/14*sin(15*t + 23.0/10) + 13.0/8*sin(16*t + 8.0/9) + 10.0/7*sin(17*t + 47.0/12) + 34.0/23*sin(19*t + 35.0/34) + 9.0/10*sin(20*t + 23.0/6) + 11.0/13*sin(22*t + 91.0/46) + 5.0/6*sin(23*t + 35.0/11) + 32282.0/17)*theta(7*PI -t)*theta(t - 3*PI) + (-3.0/8*sin(4.0/3 - 26*t) - 13.0/5*sin(1.0/8 - 19*t) - 7.0/5*sin(3.0/8 - 18*t) - 16.0/9*sin(1.0/9 - 16*t) - 60.0/7*sin(7.0/5 - 10*t) - 55.0/2*sin(7.0/9 - 5*t) - 386.0/11*sin(1.0/4 - 4*t) - 5041.0/21*sin(1.0/8 - 2*t) + 473.0/5*sin(t + 1.0/8) + 615.0/8*sin(3*t + 15.0/8) + 125.0/6*sin(6*t + 31.0/8) + 201.0/13*sin(7*t + 3) + 193.0/16*sin(8*t + 9.0/8) + 29.0/6*sin(9*t + 1.0/2) + 20.0/7*sin(11*t + 39.0/10) + 95.0/16*sin(12*t + 3) + 3.0/4*sin(13*t + 35.0/18) + 29.0/7*sin(14*t + 3.0/2) + 15.0/11*sin(15*t + 42.0/11) + 18.0/7*sin(17*t + 29.0/14) + 14.0/5*sin(20*t + 38.0/9) + 37.0/14*sin(21*t + 29.0/7) + 23.0/9*sin(22*t + 23.0/10) + 4.0/5*sin(23*t + 11.0/4) + 13.0/10*sin(24*t + 3.0/13) + 28.0/29*sin(25*t + 3) + 2.0/5*sin(27*t + 11.0/10) + 5.0/12*sin(28*t + 77.0/17) + 5.0/16*sin(29*t + 29.0/8) + 3.0/7*sin(30*t + 8.0/3) + 1.0/34*sin(31*t + 5.0/3) + 2.0/9*sin(32*t + 12.0/5) + 2.0/7*sin(33*t + 9.0/11) + 2392.0/7)*theta(3*PI -t)*theta(t +PI))*theta(sqrt(sgn(sin(t/2))));
}

float y(float t)
{
  return ((-298.0/27*sin(31.0/32 - 2*t) + 639.0/8*sin(t + 127.0/32) + 15.0/2*sin(3*t + 41.0/10) + 10.0/7*sin(4*t + 23.0/6) + 29.0/13*sin(5*t + 40.0/9) + 14.0/9*sin(6*t + 32.0/9) + 6.0/11*sin(7*t + 165.0/41) + 8.0/11*sin(8*t + 32.0/9) + 9.0/13*sin(9*t + 31.0/10) + 1.0/5*sin(10*t + 26.0/7) + 7.0/15*sin(11*t + 29.0/9) + 1.0/7*sin(12*t + 47.0/19) + 1.0/5*sin(13*t + 3) + 3.0/11*sin(14*t + 11.0/4) + 1.0/5*sin(15*t + 25.0/9) - 3179.0/9)*theta(43*PI -t)*theta(t - 39*PI) + (-4.0/7*sin(10.0/11 - 7*t) - 1.0/19*sin(1.0/2 - 6*t) - 28.0/13*sin(3.0/4 - 3*t) - 1823.0/8*sin(1.0/7 -t) + 29.0/12*sin(2*t + 123.0/31) + 9.0/7*sin(4*t + 26.0/11) + 18.0/17*sin(5*t + 3.0/7) - 1857.0/4)*theta(39*PI -t)*theta(t - 35*PI) + (-2.0/5*sin(4.0/5 - 18*t) - 2.0/7*sin(9.0/8 - 17*t) - 11.0/23*sin(1.0/5 - 15*t) - 19.0/11*sin(10.0/11 - 10*t) - 102.0/29*sin(1.0/9 - 8*t) - 179.0/36*sin(8.0/13 - 3*t) + 1021.0/3*sin(t + 32.0/7) + 153.0/10*sin(2*t + 43.0/10) + 89.0/14*sin(4*t + 27.0/7) + 49.0/5*sin(5*t + 2.0/5) + 5.0/4*sin(6*t + 4.0/7) + 7.0/3*sin(7*t + 1.0/14) + 11.0/5*sin(9*t + 23.0/9) + 17.0/7*sin(11*t + 63.0/32) + 14.0/11*sin(12*t + 38.0/13) + 6.0/5*sin(13*t + 9.0/8) + 9.0/5*sin(14*t + 45.0/23) + 35.0/34*sin(16*t + 14.0/13) - 8149.0/25)*theta(35*PI -t)*theta(t - 31*PI) + (-4.0/9*sin(4.0/13 - 5*t) - 3.0/4*sin(10.0/7 - 4*t) - 37.0/8*sin(3.0/11 - 3*t) + 129*sin(t + 20.0/19) + 25.0/13*sin(2*t + 25.0/9) + 4.0/9*sin(6*t + 26.0/9) - 3719.0/9)*theta(31*PI -t)*theta(t - 27*PI) + (-1.0/8*sin(12.0/23 - 12*t) - 5.0/12*sin(1.0/9 - 8*t) + 2466.0/13*sin(t + 27.0/7) + 9.0/8*sin(2*t + 4.0/5) + 20.0/3*sin(3*t + 13.0/5) + 6.0/7*sin(4*t + 7.0/12) + 5.0/12*sin(5*t + 79.0/17) + 1.0/2*sin(6*t + 2.0/3) + 4.0/9*sin(7*t + 13.0/4) + 1.0/7*sin(9*t + 13.0/9) + 2.0/5*sin(10*t + 1.0/6) + 3.0/10*sin(11*t + 30.0/11) - 3235.0/7)*theta(27*PI -t)*theta(t - 23*PI) + (-2.0/5*sin(7.0/10 - 16*t) - 7.0/15*sin(1.0/3 - 15*t) - 37.0/10*sin(1.0/20 - 9*t) - 13.0/7*sin(5.0/4 - 7*t) - 61.0/10*sin(13.0/11 - 5*t) + 2284.0/11*sin(t + 25.0/13) + 388.0/9*sin(2*t + 9.0/8) + 609.0/38*sin(3*t + 3.0/8) + 189.0/11*sin(4*t + 13.0/5) + 85.0/21*sin(6*t + 32.0/13) + 13.0/6*sin(8*t + 31.0/8) + 22.0/13*sin(10*t + 13.0/5) + 7.0/13*sin(11*t + 10.0/9) + 11.0/16*sin(12*t + 159.0/40) + 22.0/21*sin(13*t + 14.0/11) + 10.0/7*sin(14*t + 29.0/8) + 9.0/11*sin(17*t + 11.0/7) + 7.0/13*sin(18*t + 13.0/3) + 7.0/13*sin(19*t + 7.0/6) + 2.0/11*sin(20*t + 163.0/41) - 6265.0/13)*theta(23*PI -t)*theta(t - 19*PI) + (1367.0/6*sin(t + 15.0/4) - 2308.0/5)*theta(19*PI -t)*theta(t - 15*PI) + (-3.0/14*sin(1.0/5 - 12*t) - 9.0/13*sin(5.0/6 - 6*t) + 3979.0/21*sin(t + 7.0/3) + 28.0/11*sin(2*t + 48.0/11) + 103.0/14*sin(3*t + 44.0/13) + 15.0/16*sin(4*t + 1.0/6) + 11.0/21*sin(5*t + 5.0/8) + 7.0/9*sin(7*t + 25.0/8) + 1.0/5*sin(8*t + 13.0/14) + 3.0/14*sin(9*t + 25.0/7) + 2.0/9*sin(10*t + 5.0/9) + 1.0/5*sin(11*t + 29.0/9) - 3243.0/7)*theta(15*PI -t)*theta(t - 11*PI) + (-12.0/5*sin(2.0/7 - 2*t) + 1529.0/13*sin(t + 4.0/7) + 49.0/9*sin(3*t + 17.0/10) + 27.0/16*sin(4*t + 14.0/3) + 11.0/9*sin(5*t + 30.0/7) + 6.0/7*sin(6*t + 23.0/6) + 1.0/2*sin(7*t + 4) + 4.0/9*sin(8*t + 65.0/22) + 1.0/4*sin(9*t + 4.0/3) + 1.0/4*sin(10*t + 19.0/8) + 6.0/17*sin(11*t + 3.0/8) - 7346.0/9)*theta(11*PI -t)*theta(t - 7*PI) + (-7.0/12*sin(5.0/6 - 22*t) - 16.0/17*sin(3.0/10 - 19*t) -sin(21.0/20 - 16*t) - 115.0/57*sin(3.0/5 - 13*t) - 2*sin(31.0/21 - 10*t) - 63.0/11*sin(1 - 7*t) - 131.0/22*sin(23.0/22 - 5*t) - 17577.0/52*sin(10.0/11 -t) + 2729.0/88*sin(3*t) + 341.0/9*sin(2*t + 40.0/9) + 35.0/3*sin(4*t + 11.0/9) + 161.0/18*sin(6*t + 60.0/17) + 41.0/11*sin(8*t + 4.0/5) + 17.0/7*sin(9*t + 39.0/10) + 37.0/11*sin(11*t + 31.0/16) + 9.0/8*sin(12*t + 35.0/11) + 19.0/11*sin(14*t + 23.0/14) + 7.0/9*sin(15*t + 32.0/7) + 9.0/7*sin(17*t + 26.0/11) + 1.0/45*sin(18*t + 7.0/8) + 9.0/19*sin(20*t + 23.0/9) + 1.0/3*sin(21*t + 1.0/23) + 9.0/17*sin(23*t + 51.0/14) + 6.0/17*sin(24*t + 24.0/11) - 4147.0/7)*theta(7*PI -t)*theta(t - 3*PI) + (-5.0/9*sin(13.0/10 - 28*t) - 1.0/2*sin(3.0/4 - 26*t) - 1.0/4*sin(3.0/4 - 23*t) - 16.0/9*sin(4.0/7 - 13*t) - 44.0/9*sin(9.0/13 - 11*t) - 129.0/26*sin(3.0/4 - 10*t) - 1332.0/13*sin(7.0/6 - 3*t) - 715.0/7*sin(8.0/17 - 2*t) + 3719.0/13*sin(t + 31.0/8) + 231.0/8*sin(4*t + 26.0/11) + 283.0/21*sin(5*t + 15.0/4) + 118.0/11*sin(6*t + 11.0/14) + 83.0/8*sin(7*t + 37.0/12) + 29.0/7*sin(8*t + 1) + 115.0/11*sin(9*t + 6.0/5) + 37.0/10*sin(12*t + 35.0/11) + 5.0/3*sin(14*t + 4.0/15) + 183.0/46*sin(15*t + 57.0/14) + 9.0/8*sin(16*t + 29.0/9) + 43.0/14*sin(17*t + 23.0/11) + 29.0/19*sin(18*t + 1.0/8) + 12.0/11*sin(19*t + 1.0/4) + 4.0/3*sin(20*t + 35.0/9) + 1.0/8*sin(21*t + 37.0/11) + 11.0/10*sin(22*t + 5.0/3) + 5.0/6*sin(24*t + 8.0/9) + 3.0/8*sin(25*t + 43.0/10) + 1.0/13*sin(27*t + 14.0/3) + 1.0/5*sin(29*t + 19.0/14) + 6.0/11*sin(30*t + 31.0/9) + 3.0/11*sin(31*t + 43.0/14) + 5.0/14*sin(32*t + 11.0/6) + 3.0/10*sin(33*t + 131.0/33) - 2341.0/6)*theta(3*PI -t)*theta(t +PI))*theta(sqrt(sgn(sin(t/2))));
}
