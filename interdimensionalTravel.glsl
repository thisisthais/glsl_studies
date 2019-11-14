#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;

vec2 random2(vec2 st){
  st=vec2(dot(st,vec2(127.1,311.7)),dot(st,vec2(269.5,183.3)));
  return-1.+2.*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st){
  vec2 i=floor(st);
  vec2 f=fract(st);
  
  vec2 u=f*f*(3.-2.*f);
  
  return mix(mix(dot(random2(i+vec2(0.,0.)),f-vec2(0.,0.)),
  dot(random2(i+vec2(1.,0.)),f-vec2(1.,0.)),u.x),
  mix(dot(random2(i+vec2(0.,1.)),f-vec2(0.,1.)),
  dot(random2(i+vec2(1.,1.)),f-vec2(1.,1.)),u.x),u.y);
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

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.yy;
  vec3 color=vec3(0.);
  float t=abs(1.-sin(u_time))*10.;
  
  float circleFreq=50.;
  float circleAmpl=10.;
  float circleShapeNoise=noise(st*circleFreq)/circleAmpl;
  float circleRadius=.3*abs(sin(u_time/3.)+.5);
  float circle=circle(st+circleShapeNoise,circleRadius);
  color+=circle;
  
  vec2 startRotation=rotate2D(st,mod(u_time,2.*PI));
  float circleStars=smoothstep(.35,.37,noise(startRotation*200.));
  color*=circleStars;
  
  t=abs(1.-sin(u_time*.1))*10.;
  st+=noise(st*5.)*t;
  
  float blackSplatter=smoothstep(.15,.17,noise(st*10.));
  color=mix(color,vec3(blackSplatter),1.-circle);
  
  gl_FragColor=vec4(color,1.);
}