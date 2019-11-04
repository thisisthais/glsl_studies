#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float box(vec2 _st,vec2 _size,float _smoothEdges){
  _size=vec2(.5)-_size*.5;
  vec2 aa=vec2(_smoothEdges*.5);
  vec2 uv=smoothstep(_size,_size+aa,_st);
  uv*=smoothstep(_size,_size+aa,vec2(1.)-_st);
  return uv.x*uv.y;
}

float plot(vec2 _st,float pct){
  return smoothstep(pct-.005,pct,_st.y)-
  smoothstep(pct,pct+.005,_st.y);
}

float boxOutline(vec2 _st,vec2 _size,float _smoothEdges){
  return box(_st,_size,_smoothEdges)-box(_st,_size-vec2(.01),_smoothEdges);
}

float XOR(float a,float b){
  return(a+b)*(2.-a-b);
}

float frame(vec2 _st,vec2 _size){
  vec2 bl=step(_size,_st);
  vec2 tr=step(_size,1.-_st);
  
  return bl.x*bl.y*tr.x*tr.y;
}

vec2 tile(vec2 _st,float _zoom){
  _st*=_zoom;
  return fract(_st);
}

float corners(vec2 _st,vec2 _size){
  vec2 bl=step(_size,_st);
  vec2 tr=step(_size,1.-_st);
  
  return 1.-XOR(tr.y,XOR(tr.x,XOR(bl.x,bl.y)));
}

void main(){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(0.,0.,0.);
  
  //st=tile(st,10.);
  
  color=vec3(corners(st,vec2(.1)));
  // color*=1.-plot(st,st.x+.9);
  
  gl_FragColor=vec4(color,1.);
}