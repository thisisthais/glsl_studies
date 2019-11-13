#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float lines(float thickness,float num){
  return step(thickness,abs(sin(num)));
}

vec2 rotate2D(vec2 _st,float _angle){
  _st-=.5;
  _st=mat2(cos(_angle),-sin(_angle),
  sin(_angle),cos(_angle))*_st;
  _st+=.5;
  return _st;
}

float random(in vec2 st){
  return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 st){
  vec2 i=floor(st);
  vec2 f=fract(st);
  
  // Four corners in 2D of a tile
  float a=random(i);
  float b=random(i+vec2(1.,0.));
  float c=random(i+vec2(0.,1.));
  float d=random(i+vec2(1.,1.));
  
  // Smooth Interpolation
  
  // Cubic Hermine Curve.  Same as SmoothStep()
  vec2 u=f*f*(3.-2.*f);
  // u = smoothstep(0.,1.,f);
  
  // Mix 4 coorners percentages
  return mix(a,b,u.x)+
  (c-a)*u.y*(1.-u.x)+
  (d-b)*u.x*u.y;
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec2 norm_mouse=u_mouse/u_resolution;
  vec3 color=vec3(0.,0.,0.);
  
  float timeSin=abs(sin(u_time/5.));
  float timeCos=abs(cos(u_time/5.));
  float swirlFreq=10.*(timeSin)+5.;
  float swirlAmpl=10.*(timeCos)+5.;
  float rotateAngle=mod(u_time/10.,2.*PI);
  
  st=rotate2D(st+noise(st*swirlFreq)/swirlAmpl,rotateAngle);
  color=vec3(lines(.7,st.y*u_resolution.y/5.));
  
  gl_FragColor=vec4(color,1.);
}