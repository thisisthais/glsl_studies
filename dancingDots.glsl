#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float circle(in vec2 _st,in float _radius){
  vec2 l=_st-vec2(.5);
  return 1.-smoothstep(_radius-(_radius*.01),
  _radius+(_radius*.01),
  dot(l,l)*4.);
}

vec2 tile(vec2 st,float _zoom){
  st*=_zoom;
  
  st+=step(1.,mod(st.x*st.y,2.))*.25*u_time;
  st-=step(1.,mod(st.x-st.y+1.,2.))*.25*u_time;
  
  return fract(st);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.);
  st=tile(st,20.);
  
  color=vec3(circle(st,.6));
  
  gl_FragColor=vec4(color,1.);
}