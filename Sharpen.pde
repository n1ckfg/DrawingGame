PShader shaderSharpen;

void sharpenSetup() {
  shaderSharpen = loadShader("shaders/sharpen.glsl");
  shaderSharpen.set("iResolution", float(pg.width), float(pg.height), 1.0);
  shaderSharpen.set("tex0", pg);
}
