//
//  Grid.h
//  Prototype
//
//  Created by Travis Athougies on 9/18/12.
//  Copyright (c) 2012 com.adobke.tathougies. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GRID_SIZE 9
#define BLOCK_SIZE 9
#define BLOCK_WIDTH 3
#define EMPTY -1

@interface Grid : NSObject {
    int _data[GRID_SIZE][GRID_SIZE];
    bool _mutable[GRID_SIZE][GRID_SIZE];
    int _solution[GRID_SIZE][GRID_SIZE];
}

-(id) initWithGrid:(Grid*) grid;
-(id) initWithString: (NSString*) gridString;
-(void) printGrid;
-(void) getNewGrid;
-(void) setValue:(int) value atRow:(int) row atColumn:(int) column;
-(int)  getValueAtRow:(int) row andColumn:(int) column;
-(bool) isEmptyAtRow:(int) row andColumn:(int) column;
-(bool) isMutableAtRow:(int) row andColumn:(int) column;
-(bool) isValue:(int) value consistentAtRow:(int) row andColumn:(int) column;

-(void) setImmutableValue:(int) value atRow:(int) row atColumn:(int) column;
-(void) setMutableValue:(int) value atRow:(int) row atColumn:(int) column;
-(void) setSolution:(int) value atRow:(int) row atColumn:(int) column;
-(int) solutionAtRow:(int) row andColumn:(int) column;
-(void) emptyCellAtRow:(int) row andColumn:(int) column;
-(bool) isValue:(int)value consistentInRow:(int)row;
-(bool) isValue:(int)value consistentInColumn:(int)column;
-(bool) isValue:(int)value consistentInBlock:(int)block;
-(int) getValueAtBlock:(int) block forIndex: (int) i;
-(int) getBlockBaseRow: (int) block;
-(int) getBlockBaseColumn: (int) block;
-(int) getBlockForRow: (int) row andColumn:(int) column;
-(BOOL) generateGridStartingAtRow:(int) row andColumn:(int) column;

@end
