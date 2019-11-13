#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float random(in float x){
  return fract(sin(x)*1e4);
}

float randomLines(float x,float freq,float t){
  return step(.2,random(floor(x*freq)-floor(t)));
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  st.x*=u_resolution.x/u_resolution.y;
  vec3 color=vec3(0.,0.,0.);
  
  float freq=random(floor(u_time))+random(floor(st.y));
  float movement=u_time*(1.-freq)*20.;
  
  // make two rows
  st.y*=2.;
  // direction is 0 or 1
  float direction=step(1.,mod(st.y,2.));
  // direction is -1 or 1
  direction=(direction-.5)*2.;
  
  movement*=direction;
  
  float randCol=random(u_time*st.y);
  color=vec3(
    randomLines(st.x,freq*100.,movement-.25),
    randomLines(st.x,freq*100.,movement),
    randomLines(st.x,freq*100.,movement+.025)
  );
  
  gl_FragColor=vec4(1.-color,1.);
}