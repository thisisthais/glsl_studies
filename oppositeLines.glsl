#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float random(in float x){
  return fract(sin(x)*1e4);
}

float randomLines(float x,float t){
  return step(.5,random(floor(t)-fract(x)));
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  st.x*=u_resolution.x/u_resolution.y;
  vec3 color=vec3(0.,0.,0.);
  
  float stepCounter=floor(u_time/2.);
  st*=vec2(1.,2.*min(stepCounter,100.));
  float colTracker=step(1.,mod(st.y,2.));
  
  st.x+=colTracker*u_time/10000.;
  st.x-=(1.-colTracker)*u_time/10000.;
  
  color=vec3(randomLines(st.x,u_time));
  
  gl_FragColor=vec4(color,1.);
}