//
//  Solver.m
//  xcodegit
//
//  Created by jarthur on 1/6/13.
//
//

#import "Solver.h"

@implementation Solver
@synthesize solution;

-(id) init {
    if (self = [super init])
    {

    }
    return self;
}

-(id) initWithGrid: (Grid*) initGrid {
    if (self = [super init])
    {
        grid = initGrid;
    }
    return self;
}

-(int) getNumSols {
    return [self solveAndSet: false];
}

-(bool) setSolution {
    return [self solveAndSet: true] > 0;
}

-(int) solveAndSet:(bool) setSol {
    bool solved = true;
    for (int y = 0; y<9; ++y)
        for (int x = 0; x<9; ++x) 
            if ([grid getValueAtRow:y andColumn:x] == EMPTY)
                solved = false;
    if (solved) {
        if (setSol) 
            for (int y = 0; y<9; ++y)
                for (int x = 0; x<9; ++x)
                    [grid setSolution:[grid getValueAtRow:y andColumn:x] atRow:y atColumn:x];
        
        return 1;
    }
    
    
    int minIndex = -1;
    NSMutableArray *minPotentials = nil;

    for (int y = 0; y<9; ++y) {
        for (int x = 0; x<9; ++x) {
            if ([grid getValueAtRow:y andColumn:x] == EMPTY) {
                NSMutableArray *potentials = [NSMutableArray array];
                for (int i = 1; i<=9; ++i) 
                    if ([grid isValue:i consistentAtRow:y andColumn:x]) 
                        [potentials addObject:[NSNumber numberWithInt:i]];

                // empty cell with no possible value.. must be no solution
                if ([potentials count] == 0)
                    return 0;
                
                if ( (!minPotentials) || ([potentials count] < [minPotentials count])) {
                    minIndex = 9*y+x;
                    minPotentials = potentials;
                }
            }
        }
    }
    
    int solutions = 0;
    for (NSNumber *value in minPotentials) {
        [grid setMutableValue: [value intValue] atRow:minIndex/9 atColumn:minIndex%9];
        solutions += [self solveAndSet: setSol];
        [grid emptyCellAtRow:minIndex/9 andColumn:minIndex%9];
    }

    return solutions;
}

@end
