import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.opengl.PGraphics2D;
import processing.opengl.PGraphics3D;

DwPixelFlow context;
DwFilter filter;
PGraphics2D tex;

void bloomSetup() {
  tex = (PGraphics2D) createGraphics(sW, sH, P2D);
  tex.noSmooth();
  
  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  //filter.bloom.setBlurLayers(10);
  filter.bloom.param.mult = 0.3; //3.5; // 0.0-10.0
  filter.bloom.param.radius = 0.5; //0.5; // 0.0-1.0
}

void bloomDraw() {
  if (doBloom) filter.bloom.apply(tex);
  image(tex, 0, 0, width, height);
}
