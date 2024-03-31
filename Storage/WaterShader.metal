
#include <metal_stdlib>
#include <RealityKit/RealityKit.h>

using namespace metal;

[[visible]]
void waveSurface(realitykit::surface_parameters params)
{
  auto surface = params.surface();
  float maxAmp = 0.03;
  half3 oceanBlue = half3(0, 0.412, 0.58);
  float waveHeight = (
    params.geometry().model_position().y + maxAmp
  ) / (maxAmp * 2);

  surface.set_base_color(
    oceanBlue + min(1.0f, pow(waveHeight, 8)) * (1 - oceanBlue)
  );
}
