#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;

float rand(in float n){
  return fract(sin(n)*1e4);
}

float randRange(in float seed,in float min,in float max){
  return rand(seed)*(max-min)+min;
}

float noise(float x){
  float i=floor(x);
  float f=fract(x);
  float u=f*f*(3.-2.*f);
  return mix(rand(i),rand(i+1.),u/.8);
}

float circle(in vec2 _st,in float _radius){
  vec2 l=_st-vec2(.5);
  return 1.-smoothstep(_radius-(_radius*.01),
  _radius+(_radius*.01),
  dot(l,l)*4.);
}

vec2 rotate2D(vec2 _st,float _angle){
  _st-=.5;
  _st=mat2(cos(_angle),-sin(_angle),
  sin(_angle),cos(_angle))*_st;
  _st+=.5;
  return _st;
}

vec2 tile(vec2 _st,float _zoom){
  _st*=_zoom;
  return fract(_st);
}

void main(void){
  // not sure which coord normalization i like better for coding in vscode
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.);
  
  st.x+=.01;
  st=tile(vec2(noise(st.x),noise(st.y)),10.);
  st=rotate2D(vec2(noise(st.x),noise(st.y)),-PI*u_time*.25);
  color=vec3(circle(vec2(noise(st.x),noise(st.y)),.1));
  st.x+=.3;
  color+=vec3(circle(vec2(noise(st.x),noise(st.y)),.1));
  
  gl_FragColor=vec4(color,1.);
}