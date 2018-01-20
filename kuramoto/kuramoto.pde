int px = 4;
int dim = 64;

int chartheight = 256;
int chartwidth = 800;

float[][] phases = new float[dim][dim];
float[][] d_phases = new float[dim][dim];
float[][] w = new float[dim][dim];
float k1 = 0.1;

float t = 0;
float dt = 0.01;
int nr = 2;
int nc = (nr + 1) * (nr + 1);
float chart_x = 0;
float prev_avg = 127;

void setup()
{
  size(dim * px + chartwidth, max(dim * px, chartheight));
  background(0);
  colorMode(RGB);
  noStroke();
  
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      phases[i][j] = random(0, 2 * PI);
      w[i][j] = random(1, 16);
    }
  }
}

void draw(){
  float avg = 0;
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      float s = 0;
      for (int x = i - nr; x < i + nr; ++x) {
        for (int y = j - nr; y < j + nr; ++y) {
          int x1 = x;
          int y1 = y;
          if (x < 0) x1 += dim;
          if (y < 0) y1 += dim;
          if (x >= dim) x1 -= dim;
          if (y >= dim) y1 -= dim;
          s += sin(phases[x1][y1] - phases[i][j]);
        }
      }

      d_phases[i][j] = w[i][j] + 15.05 / nc * s;
    }
  }
  noStroke();
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      phases[i][j] += dt * d_phases[i][j];
      float amp = sin(phases[i][j]);
      fill(128 + 127 * amp, 128 + 127 * amp, 0.5 * (128 + 127 * amp));
      avg += 128 + 127 * amp;
      rect(i * px, j * px, px, px);
    }
  }
  avg /= dim * dim;
  stroke(255, 255, 127);
  line(chart_x + dim * px, chartheight - prev_avg, 
       chart_x + dim * px + 1, chartheight - avg);
  prev_avg = avg;
  chart_x++;
  if (chart_x >= chartwidth) {
    fill(0, 0, 0, 192);
    noStroke();
    rect(dim * px, 0, width, height);
    chart_x = 0;
  }
}

