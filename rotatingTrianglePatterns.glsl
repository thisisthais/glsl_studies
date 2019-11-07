#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;

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

vec2 rotateTilePattern(vec2 _st){
  
  //  Scale the coordinate system by 2x2
  _st*=2.;
  
  //  Give each cell an index number
  //  according to its position
  float index=0.;
  index+=step(1.,mod(_st.x,2.));
  index+=step(1.,mod(_st.y,2.))*2.;
  
  //      |
  //  2   |   3
  //      |
  //--------------
  //      |
  //  0   |   1
  //      |
  
  // Make each cell between 0.0 - 1.0
  _st=fract(_st);
  
  // Rotate each cell according to the index
  // 0 rotates 0
  if(index==1.){
    //  Rotate cell 2 by -90 degrees
    _st=rotate2D(_st,PI*-.5);
  }else if(index==2.){
    //  Rotate cell 1 by 90 degrees
    _st=rotate2D(_st,PI*.5);
  }else if(index==3.){
    //  Rotate cell 3 by 180 degrees
    _st=rotate2D(_st,PI);
  }
  
  return _st;
}

// http://www.iquilezles.org/www/articles/palettes/palettes.htm
// As t runs from 0 to 1 (our normalized palette index or domain),
//the cosine oscilates c times with a phase of d.
//The result is scaled and biased by a and b to meet the desired constrast and brightness.
vec3 cosPalette(float t,vec3 a,vec3 b,vec3 c,vec3 d)
{
  return a+b*cos(6.28318*(c*t+d));
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  
  st=tile(st,3.);
  st=rotateTilePattern(st);
  
  // Make more interesting combinations
  st=tile(st,4.);
  st=rotate2D(st,-PI*u_time*.15);
  //st = rotateTilePattern(st*2.);
  // st = rotate2D(st,PI*u_time*0.25);
  
  vec3 color=cosPalette(u_time/10.,vec3(.8),vec3(.3),vec3(1.),vec3(u_time*.01,u_time*.1,u_time*.2));
  // step(st.x,st.y) just makes a b&w triangles
  // but you can use whatever design you want.
  gl_FragColor=vec4(vec3(step(st.x,st.y))*color,1.);
}
