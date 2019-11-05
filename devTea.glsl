#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846
#define TWO_PI 6.28318530718

// http://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
float equiTri(vec2 p){
  float side=sqrt(3.);
  p.x=abs(p.x)-1.;
  p.y=p.y+1./side;
  if(p.x+side*p.y>0.){
    p=vec2(p.x-side*p.y,-side*p.x-p.y)/2.;
  }
  p.x-=clamp(p.x,-2.,0.);
  return-length(p)*sign(p.y);
}

float sdCircle(vec2 p,float r)
{
  return length(p)-r;
}

float sdPentagon(in vec2 p,in float r)
{
  const vec3 k=vec3(.809016994,.587785252,.726542528);
  p.x=abs(p.x);
  p-=2.*min(dot(vec2(-k.x,k.y),p),0.)*vec2(-k.x,k.y);
  p-=2.*min(dot(vec2(k.x,k.y),p),0.)*vec2(k.x,k.y);
  return length(p-vec2(clamp(p.x,-r*k.z,r*k.z),r))*sign(p.y-r);
}

// http://www.iquilezles.org/www/articles/palettes/palettes.htm
// As t runs from 0 to 1 (our normalized palette index or domain),
//the cosine oscilates c times with a phase of d.
//The result is scaled and biased by a and b to meet the desired constrast and brightness.
vec3 cosPalette(float t,vec3 a,vec3 b,vec3 c,vec3 d)
{
  return a+b*cos(6.28318*(c*t+d));
}

// Rotate around a coordinate axis (i.e. in a plane perpendicular to that axis) by angle <a>.
// Read like this: R(p.xz, a) rotates "x towards z".
// This is fast if <a> is a compile-time constant and slower (but still practical) if not.
void pR(inout vec2 p,float a){
  p=cos(a)*p+sin(a)*vec2(p.y,-p.x);
}

vec2 tile(vec2 _st,float _zoom){
  _st*=_zoom;
  // _st.x += step(1., mod(_st.y,2.0)) * 0.5;
  return fract(_st+u_time);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.);
  st=tile(st,4.);
  // normalize the coordinate space
  st-=vec2(.5);
  st*=2.;
  pR(st,mod(u_time,TWO_PI));
  
  // distance metric
  float triangle=equiTri(st*vec2(3.));
  float circle=sdCircle(st*vec2(3.),.5);
  float pentagon=sdPentagon(st*vec2(3.),.5);
  float changingShape=sin(u_time)*(triangle-circle)+circle;
  // this makes a flying squirrel
  changingShape=sin(u_time)*(changingShape-pentagon)+pentagon;
  
  vec3 col=cosPalette(.5,vec3(.5),vec3(.5),vec3(1.),vec3(u_time*.01,u_time*.1,u_time*.2));
  
  // lighting: darken at the center
  col=vec3(changingShape)*col;
  
  // output: pixel color
  gl_FragColor=vec4(col.rgb,1.);
}