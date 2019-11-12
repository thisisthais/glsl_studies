#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;

vec2 random2D(vec2 st){
  st=vec2(dot(st,vec2(127.1,311.7)),dot(st,vec2(269.5,183.3)));
  return-1.+2.*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st){
  vec2 i=floor(st);
  vec2 f=fract(st);
  // mixing function
  vec2 u=f*f*(3.-2.*f);
  
  return mix(mix(dot(random2D(i+vec2(0.,0.)),f-vec2(0.,0.)),
  dot(random2D(i+vec2(1.,0.)),f-vec2(1.,0.)),u.x),
  mix(dot(random2D(i+vec2(0.,1.)),f-vec2(0.,1.)),
  dot(random2D(i+vec2(1.,1.)),f-vec2(1.,1.)),u.x),u.y);
}

float circle(in vec2 _st,in float _radius){
  vec2 l=_st-vec2(.5);
  return 1.-smoothstep(_radius-(_radius*.01),
  _radius+(_radius*.01),
  dot(l,l)*4.);
}

float shape(vec2 st,float radius){
  st=st-vec2(.5);
  float r=length(st)*2.;
  float a=atan(st.y,st.x);
  float m=abs(mod(2.*u_time,2.*PI)-PI)/a*2.2;
  float f=radius;
  
  // stripeys, where they coming from, idk
  m+=noise(st+u_time*.3)*50.;
  st-=.9;
  m+=noise(st+u_time*.3)*50.;
  st.y+=.4;
  m+=noise(st+u_time*.3)*50.;
  
  f+=sin(a*100.)*noise(st+u_time*.2)*.1;
  f+=(sin(a*100.)*.1*pow(m,2.));
  return smoothstep(f,f+.007,r);
}

float shapeBorder(vec2 st,float radius,float width){
  return shape(st,radius)-shape(st,radius-width);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.);
  color=vec3(shape(st,.5));
  color+=circle(st,.005*(sin(u_time)+1.1));
  
  gl_FragColor=vec4(color,1.);
}