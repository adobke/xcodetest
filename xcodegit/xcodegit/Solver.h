//
//  Solver.h
//  xcodegit
//
//  Created by jarthur on 1/6/13.
//
//

#import <Foundation/Foundation.h>
#import "Grid.h"

@interface Solver : NSObject {
    Grid* grid;
}
@property (readonly) Grid *solution;


-(id) initWithGrid: (Grid*) initGrid;

-(int) getNumSols;
-(bool) setSolution;

@end
