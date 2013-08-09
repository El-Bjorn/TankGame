/*  coordsTrans.c 
*/
#import <QuartzCore/QuartzCore.h>

//#define MIN_PHYS_X -14.0
#define MIN_PHYS_X -13.5 // better
#define MAX_PHYS_X 13.5
//#define MIN_PHYS_Y -21.0
#define MIN_PHYS_Y -20.0 // better
#define MAX_PHYS_Y 20.0
#define PHYS_X_SZ (MAX_PHYS_X-MIN_PHYS_X)
#define PHYS_Y_SZ (MAX_PHYS_Y-MIN_PHYS_Y)

#define MIN_SCREEN_X 0
#define MAX_SCREEN_X 768
#define MIN_SCREEN_Y 0
#define MAX_SCREEN_Y 1024
#define SCREEN_X_SZ (MAX_SCREEN_X-MIN_SCREEN_X)
#define SCREEN_Y_SZ (MAX_SCREEN_Y-MIN_SCREEN_Y)

CGPoint physToScreen(CGPoint physPt){
	physPt.y *= -1; // flip y coords
	physPt.y += MAX_PHYS_Y; // move to origin
	physPt.x -= MIN_PHYS_X; // move to origin
	// scaling
	physPt.x *= (SCREEN_X_SZ/PHYS_X_SZ);
	physPt.y *= (SCREEN_Y_SZ/PHYS_Y_SZ);

	return physPt;
}

CGPoint screenToPhys(CGPoint scrnPt){
	// do scaling
    //CGPoint physPt = scrnPt;
	scrnPt.x *= (PHYS_X_SZ/SCREEN_X_SZ);
	scrnPt.y *= (PHYS_Y_SZ/SCREEN_Y_SZ);
	scrnPt.y -= MAX_PHYS_Y;
	scrnPt.y *= -1; // flip coords
	scrnPt.x += MIN_PHYS_X;

	return scrnPt;
}
