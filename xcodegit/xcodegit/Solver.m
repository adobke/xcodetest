//
//  Solver.m
//  xcodegit
//
//  Created by jarthur on 1/6/13.
//
//

#import "Solver.h"

@implementation Solver

-(id) init {
    if (self = [super init])
    {
        for (int i = 0; i < 9; ++i)
            for (int j = 0; j < 9; ++j)
                searchSpace[i][j] = [[NSMutableSet alloc] init];
    }
    return self;
}

-(int) getNumSolsFor: (Grid*) initGrid {
    return [self solveAndSet: false grid: initGrid];
}

-(bool) setSolutionFor: (Grid*) initGrid {
    return [self solveAndSet: true grid: initGrid] > 0;
}

-(void) eliminateValue:(int)value atRow:(int)row andColumn:(int)column usingGrid:(Grid*)newGrid {
    NSNumber *numberValue = [NSNumber numberWithInt:value];
    
    /* Do row elimination */
    for (int i = 0; i < 9; ++i)
        if ([newGrid isEmptyAtRow:row andColumn:i])
            [searchSpace[row][i] removeObject:numberValue];
    
    /* column elimination */
    for (int i = 0; i < 9; ++i)
        if ([newGrid isEmptyAtRow:i andColumn:column])
            [searchSpace[i][column] removeObject: numberValue];
    
    /* block elimination */
    int block = [newGrid getBlockForRow:row andColumn:column];
    int block_row_start = [newGrid getBlockBaseRow: block];
    int block_col_start = [newGrid getBlockBaseColumn: block];
    for (int i = 0; i < 3; ++i)
        for (int j = 0; j < 3; ++j)
            if ([newGrid isEmptyAtRow: block_row_start+i andColumn: block_col_start + j])
                [searchSpace[block_row_start+i][block_col_start + j] removeObject: numberValue];
}


-(void) populateSpace: (Grid*) grid
{
    for (int y = 0; y<9; ++y) {
        for (int x = 0; x<9; ++x) {
            if ([grid getValueAtRow:y andColumn:x] == EMPTY) {
                NSMutableArray *potentials = [NSMutableArray array];
                for (int i = 1; i<=9; ++i)
                    if ([grid isValue:i consistentAtRow:y andColumn:x]) {
                        //[potentials addObject:[NSNumber numberWithInt:i]];
                        [searchSpace[y][x] addObject: [NSNumber numberWithInt: i]];
                    }
                
                // empty cell with no possible value.. must be no solution
                //if ([potentials count] == 0)
                //    return 0;
            }
        }
    }
}

-(int) solveAndSet:(bool) setSol grid: (Grid*) grid {
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
    static NSMutableSet *minPotentials = nil;

    for (int y = 0; y<9; ++y) {
        for (int x = 0; x<9; ++x) {
            if ([grid getValueAtRow:y andColumn:x] == EMPTY) {
                NSMutableArray *potentials = [NSMutableArray array];
                for (int i = 1; i<=9; ++i) 
                    if ([grid isValue:i consistentAtRow:y andColumn:x]) {
                        //[potentials addObject:[NSNumber numberWithInt:i]];
                        [searchSpace[y][x] addObject: [NSNumber numberWithInt: i]];
                    }

                // empty cell with no possible value.. must be no solution
                if ([potentials count] == 0)
                    return 0;
                
                if ( (!minPotentials) || ([potentials count] < [minPotentials count])) {
                    minIndex = 9*y+x;
                    minPotentials = searchSpace[y][x];
                }
            }
        }
    }
    
    int solutions = 0;
    for (NSNumber *value in minPotentials) {
        [grid setMutableValue: [value intValue] atRow:minIndex/9 atColumn:minIndex%9];
        solutions += [self solveAndSet: setSol grid: grid];
        [grid emptyCellAtRow:minIndex/9 andColumn:minIndex%9];
    }

    return solutions;
}

@end
