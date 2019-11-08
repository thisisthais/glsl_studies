#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float random(in vec2 _st){
  return fract(sin(dot(_st.xy,
        vec2(12.9898,78.233)))*
      43758.5453123);
    }
    
    float random(in float x){
      return fract(sin(x)*1e4);
    }
    
    void main(void){
      vec2 st=gl_FragCoord.xy/u_resolution.xy;
      vec3 color=vec3(0.,0.,0.);
      
      float numLines=random(st.x);
      st*=vec2(numLines,2.);
      st=vec2(fract(st.x),st.y);
      
      float freq=u_time/100.;
      float colTracker=step(1.,mod(st.y,2.));
      
      st.x-=2.*fract(u_time)*(1.-colTracker)+(1.-freq);
      st.x+=2.*fract(u_time)*colTracker+freq;
      
      color=vec3(step(numLines,mod(st.x,2.)));
      
      gl_FragColor=vec4(color,1.);
    }