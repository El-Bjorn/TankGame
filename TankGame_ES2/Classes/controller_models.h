/*
 *  controller_models.h
 *  OC_helloArrow_ES1
 *
 *  Created by Bjorn Chambless on 7/24/11.
 *  Copyright 2011 Built Light. All rights reserved.
 *
 */
#import "modelTypes.h"

// controller strip (old, rectangular)
const Vertex controllerVerts_old[] = {
	{{1.0,0.0},{0.7,0.7,0.7,1}},
	{{1.0,7.0},{0.7,0.7,0.7,1}},
	{{-1.0,7.0},{0.7,0.7,0.7,1}},
	{{-1.0,0.0},{0.7,0.7,0.7,1}},
	{{-1.0,-7.0},{0.7,0.7,0.7,1}},
	{{1.0,-7.0},{0.7,0.7,0.7,1}},
	{{1.0,0.0},{0.7,0.7,0.7,1}}
};

const Vertex sliderVerts[] = {
	{{-2,-1},{0.6,0.6,0.6,0.9}},
	{{2,-1},{0.6,0.6,0.6,0.9}},
	{{2,1},{0.6,0.6,0.6,0.9}},
	{{-2,1},{0.6,0.6,0.6,0.9}}
};

// controller strip (new)
const Vertex controllerVerts[] = {
	{{-1,-7},{0.4,0.4,0.4,1}}, // bottom left
	{{1,-7},{0.4,0.4,0.4,1}},
	{{0,-7},{0.4,0.4,0.4,1}}, // bottom center
	{{0,7},{0.4,0.4,0.4,1}},
	{{1,7},{0.4,0.4,0.4,1}},
	{{-1,7},{0.4,0.4,0.4,1}}
};
