#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float random(in vec2 st){
  return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 st){
  vec2 i=floor(st);
  vec2 f=fract(st);
  
  // Four corners in 2D of a tile
  float a=random(i);
  float b=random(i+vec2(1.,0.));
  float c=random(i+vec2(0.,1.));
  float d=random(i+vec2(1.,1.));
  
  // Smooth Interpolation
  
  // Cubic Hermine Curve.  Same as SmoothStep()
  vec2 u=f*f*(3.-2.*f);
  // u = smoothstep(0.,1.,f);
  
  // Mix 4 coorners percentages
  return mix(a,b,u.x)+
  (c-a)*u.y*(1.-u.x)+
  (d-b)*u.x*u.y;
}

float sdBox(in vec2 p,in vec2 b){
  vec2 d=abs(p)-b;
  return length(max(d,vec2(0)))+min(max(d.x,d.y),0.);
}

void main(void){
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  vec3 color=vec3(.3686,.2627,.4);
  
  float bgNoise=noise(st*100.);
  color=mix(color,vec3(.3059,.1765,.3608),bgNoise/2.);
  
  float topBoxFreq=800.;
  float topBoxAmpl=20.;
  vec2 topBoxPos=st-vec2(.53,.89)+noise(st*topBoxFreq)/topBoxAmpl;
  vec2 topBoxDimensions=vec2(.38,.005);
  float topBox=step(.1,sdBox(topBoxPos,topBoxDimensions));
  vec3 topBoxOrange=vec3(1.,.451,0.);
  color=mix(color,topBoxOrange,(1.-topBox)/2.);
  
  vec2 midBoxPos=st-vec2(.53,.515)+noise(st*topBoxFreq)/topBoxAmpl;
  vec2 midBoxDimensions=vec2(.38,.14);
  float midBox=step(.1,sdBox(midBoxPos,midBoxDimensions));
  vec3 midBoxBlack=vec3(.0667,.0627,.0627);
  color=mix(color,midBoxBlack,1.-midBox);
  
  vec2 botBoxPos=st-vec2(.53,.15)+noise(st*topBoxFreq)/topBoxAmpl;
  vec2 botBoxDimensions=vec2(.38,.005);
  float botBox=step(.1,sdBox(botBoxPos,botBoxDimensions));
  color=mix(color,vec3(.0235,.1333,.1529),1.-botBox);
  
  gl_FragColor=vec4(color,1.);
}