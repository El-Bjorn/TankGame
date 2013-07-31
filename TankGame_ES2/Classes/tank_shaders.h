/*  tank_shaders.h */


/* ----------------- shaders -----------------*/
const char SimpleVertexShader[] =
"attribute vec4 Position;                             \n"
"attribute vec4 SourceColor;                          \n"
"varying vec4 DestinationColor;                       \n"
"uniform mat4 Projection;                             \n"
"uniform mat4 Modelview;                              \n"
"void main(void){                                     \n"
"    DestinationColor = SourceColor;                  \n"
"    gl_Position = Projection * Modelview * Position; \n"
"}                                                    \n";

const char SimpleFragmentShader[] =
"varying lowp vec4 DestinationColor;                  \n"
"void main(void) {                                    \n"
"    gl_FragColor = DestinationColor;                 \n"
"}                                                    \n";




