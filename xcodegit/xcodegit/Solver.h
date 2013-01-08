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
    NSMutableSet *searchSpace[9][9];
}

-(int) getNumSolsFor: (Grid*) grid;
-(bool) setSolutionFor: (Grid*) grid;
-(int) solveAndSet:(bool) setSol grid: (Grid*) grid;

@end
