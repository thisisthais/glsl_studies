#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 tile(vec2 _st,vec2 _zoom){
  _st*=_zoom;
  return fract(_st);
}

void main(){
  vec2 st=gl_FragCoord.xy/u_resolution;
  vec3 color=vec3(0.);
  
  // find row,col position of pixel
  st*=18.;
  float row=st.x-fract(st.x);
  float col=st.y-fract(st.y);
  
  // make coordinates repeat
  st=fract(st);
  
  // for drawing 6 sections
  st=st*6.;
  
  float rowColSum=row+col;
  
  if(mod(rowColSum,2.)==0.){
    color=vec3(1.-step(1.,mod(st.y,2.)));
  }else{
    color=vec3(1.-step(1.,mod(st.x,2.)));
  }
  
  gl_FragColor=vec4(color,1.);
}