// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846
#define TWO_PI 6.28318530718

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

float box(vec2 _st,vec2 _size,float _smoothEdges){
  _size=vec2(.5)-_size*.5;
  vec2 aa=vec2(_smoothEdges*.5);
  vec2 uv=smoothstep(_size,_size+aa,_st);
  uv*=smoothstep(_size,_size+aa,vec2(1.)-_st);
  return uv.x*uv.y;
}

float circle(in vec2 _st,in float _radius){
  vec2 l=_st-vec2(.5);
  return 1.-smoothstep(_radius-(_radius*.01),
  _radius+(_radius*.01),
  dot(l,l)*4.);
}

vec3 hsb2rgb(in vec3 c){
  vec3 rgb=clamp(abs(mod(c.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
  rgb=rgb*rgb*(3.-2.*rgb);
  return c.z*mix(vec3(1.),rgb,c.y);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  // Use polar coordinates instead of cartesian
  vec2 toCenter=vec2(.5)-st;
  float angle=atan(toCenter.y,toCenter.x)+mod(u_time,TWO_PI);
  float radius=length(toCenter)*2.;
  
  // Map the angle (-PI to PI) to the Hue (from 0 to 1)
  // and the Saturation to the radius
  vec3 color=hsb2rgb(vec3((angle/TWO_PI)+.5,radius,1.));
  
  // Divide the space in 4
  st=tile(st,4.);
  
  float rotate=mod(u_time,PI);
  st=st-vec2(.5);
  st*=rotate;
  st=st+vec2(.5);
  
  float truncatedBox=1.-(box(rotate2D(st,PI),vec2(.85),.01)*box(rotate2D(st,PI*rotate/2.),vec2(.8),.01));
  color+=vec3(truncatedBox);
  
  gl_FragColor=vec4(color,1.);
}
