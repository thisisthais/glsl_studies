#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846
#define TWO_PI 6.28318530718

float box(vec2 _st,vec2 _size,float _smoothEdges){
  _size=vec2(.5)-_size*.5;
  vec2 aa=vec2(_smoothEdges*.5);
  vec2 uv=smoothstep(_size,_size+aa,_st);
  uv*=smoothstep(_size,_size+aa,vec2(1.)-_st);
  return uv.x*uv.y;
}

float plot(vec2 _st,float pct){
  return smoothstep(pct-.04,pct,_st.y)-
  smoothstep(pct,pct+.04,_st.y);
}

vec2 tile(vec2 _st,float _zoom){
  _st*=_zoom;
  return fract(_st);
}

float truncatedFrame(vec2 _st,vec2 _size){
  // normal use of step to make canvas frame
  vec2 bl=step(_size,_st);
  vec2 tr=step(_size,1.-_st);
  
  // make boxes that cover corner spots
  float blBox=box(_st+vec2(.41,.41),vec2(.2),.01);
  float trBox=box(_st-vec2(.41,.41),vec2(.2),.01);
  float tlBox=box(_st+vec2(.41,-.41),vec2(.2),.01);
  float brBox=box(_st+vec2(-.41,.41),vec2(.2),.01);
  
  // doing * is like AND, doing + is like OR
  // so this is like doing frame OR not box
  // (not because the box colors are inverted from the frame colors, i think)
  return bl.x*bl.y*tr.x*tr.y+blBox+trBox+tlBox+brBox;
  
}

void main(){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.,0.,0.);
  
  st=tile(st,10.);
  
  // float rotate=mod(u_time,PI);
  // st=st-vec2(.5);
  // st*=rotate;
  // st=st+vec2(.5);
  
  color=vec3(truncatedFrame(st,vec2(.02)));
  color*=vec3(1.-plot(st-vec2(.8),st.x));
  color*=vec3(1.-plot(st-vec2(.2),-st.x));
  color*=vec3(1.-plot(st-vec2(.8),1.-st.x));
  color*=vec3(1.-plot(st+vec2(.8),st.x));
  
  gl_FragColor=vec4(color,1.);
}