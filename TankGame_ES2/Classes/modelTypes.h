// modelTypes.h
//    stuff all the openGL vertex models need


typedef struct {
    float Position[2];
        float Color[4];
	} Vertex;

static int vertStride = sizeof(Vertex);

#define TANK_COL_TYPE 1
#define SHELL_COL_TYPE 2