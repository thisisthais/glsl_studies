#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float sdCircle(vec2 p,float r)
{
  return length(p)-r;
}

float circle(in vec2 _st,in float _radius){
  vec2 l=_st-vec2(.5);
  return 1.-smoothstep(_radius-(_radius*.01),
  _radius+(_radius*.01),
  dot(l,l)*4.);
}

vec2 tile(vec2 _st,float _zoom){
  _st*=_zoom;
  // offset
  // _st.x += step(1., mod(_st.y,2.0)) * 0.5;
  
  // Here is where the motion is happening
  _st+=step(1.,mod(_st.x*_st.y,2.))*.5*u_time;
  _st-=step(1.,mod(_st.x*_st.y+1.,2.))*.5*u_time;
  
  // _st.x+=step(1.,mod(_st.y,2.))*.5*u_time;
  // _st.x-=step(1.,mod(_st.y+1.,2.))*.5*u_time;
  return fract(_st);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.);
  st=tile(st,20.);
  st=(st-.5)*2.;
  
  color=vec3(circle(st,.5));
  
  gl_FragColor=vec4(color,1.);
}