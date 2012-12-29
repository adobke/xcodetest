//
//  Grid.m
//  Prototype
//
//  Created by Travis Athougies on 9/18/12.
//  Copyright (c) 2012 com.adobke.tathougies. All rights reserved.
//

#import "Grid.h"

@implementation Grid

-(id) init {
    if (self = [super init])
    {
        /* Initialize the grid to be completely mutable and completely empty */
        for (int i = 0; i < GRID_SIZE; ++i)
            for (int j = 0; j < GRID_SIZE; ++j) {
                _data[i][j] = EMPTY;
                _mutable[i][j] = YES;
            }
    }
    return self;
}

-(id) initWithGrid: (Grid*) grid {
    if (self = [super init])
    {
        /* Initialize the grid to be completely mutable and completely empty */
        for (int i = 0; i < GRID_SIZE; ++i)
            for (int j = 0; j < GRID_SIZE; ++j) {
                _data[i][j] = grid->_data[i][j];
                _mutable[i][j] = grid->_mutable[i][j];
                _solution[i][j] = grid->_solution[i][j];
            }
    }
    return self;
}

-(void) printGrid {
    printf("+-------+-------+-------+\n");
    
    for (int i = 0; i < 9; ++i) {
        printf("| ");
        for (int j = 0; j < 9; ++j) {
            if ([self isEmptyAtRow:i andColumn:j])
                printf("  ");
            else
                printf("%d ", [self getValueAtRow:i andColumn:j]);
            if ((j + 1) % 3 == 0)
                printf("| ");
        }
        printf("\n");
        if ((i + 1) % 3 == 0)
            printf("+-------+-------+-------+\n");
    }
}

-(void) setValue:(int) value atRow:(int) row atColumn:(int) column {
    /* Set a cell to a value, without checking for consistency */
    _data[row][column] = value;
}

-(void) setSolution:(int) value atRow:(int) row atColumn:(int) column {
    /* Set a cell to a value, without checking for consistency */
    _solution[row][column] = value;
}

-(void) setImmutableValue:(int) value atRow:(int) row atColumn:(int) column {
    /* Set a cell to a value and make the cell immutable */
    _data[row][column] = value;
    _mutable[row][column] = NO;
}

-(void) setMutableValue:(int) value atRow:(int) row atColumn:(int) column {
    /* Set a cell to a value and make the cell mutable */
    _data[row][column] = value;
    _mutable[row][column] = YES;
}

-(void) emptyCellAtRow:(int) row andColumn:(int) column {
    /* Make a cell empty and mutable */
    _data[row][column] = EMPTY;
    _mutable[row][column] = YES;
}

-(int) getValueAtRow:(int) row andColumn:(int) column {
    /* Get the value of the specified cell */
    return _data[row][column];
}

-(int) solutionAtRow:(int) row andColumn:(int) column {
    /* Get the value of the specified cell */
    return _solution[row][column];
}

-(bool) isEmptyAtRow:(int)row andColumn:(int)column {
    /* Determine if the cell at row and column is empty */
    return _data[row][column] == EMPTY;
}

-(bool) isMutableAtRow:(int)row andColumn:(int)column {
    /* Determine if the cell at row and column is mutable */
    return _mutable[row][column];
}

-(bool) isValue:(int)value consistentAtRow:(int)row andColumn:(int)column {
    /* Runs all validation checks for the given value at the given row and column */
    if ([self getValueAtRow:row andColumn:column] == value)
        return YES;
    
    int block = [self getBlockForRow:row andColumn:column];
    return [self isValue:value consistentInRow:row] &&
    [self isValue:value consistentInColumn:column] &&
    [self isValue:value consistentInBlock:block];
}

-(bool) isValue:(int)value consistentInRow:(int)row {
    /* Checks if the value is consistent in the given row */
    for (int i = 0; i < GRID_SIZE; ++i) {
        if (_data[row][i] == value)
            return NO;
    }
    return YES;
}

-(bool) isValue:(int)value consistentInColumn:(int)column {
    /* Checks if the value is consistent in the given column */
    for (int i = 0; i < GRID_SIZE; ++i) {
        if (_data[i][column] == value)
            return NO;
    }
    return YES;
}

-(bool) isValue:(int)value consistentInBlock:(int)block {
    /* Checks if value is consistent in the given block. We number blocks according to the following layout:
     
     +-----+-----+-----+
     |     |     |     |
     |  0  |  1  |  2  |
     |     |     |     |
     +-----+-----+-----+
     |     |     |     |
     |  3  |  4  |  5  |
     |     |     |     |
     +-----+-----+-----+
     |     |     |     |
     |  6  |  7  |  8  |
     |     |     |     |
     +-----+-----+-----+
     
     */
    for (int i = 0; i < BLOCK_SIZE; ++i) {
        if ([self getValueAtBlock:block forIndex: i] == value)
            return NO;
    }
    return YES;
}

-(int) getValueAtBlock:(int)block forIndex:(int)i {
    /* Allows the programmer to iterate through the entire block. Valid values for i are in [0,8] */
    
    int rowInBlock = i / BLOCK_WIDTH;
    int colInBlock = i % BLOCK_WIDTH;
    
    int blockBaseRow = [self getBlockBaseRow: block];
    int blockBaseColumn = [self getBlockBaseColumn: block];
    
    return _data[blockBaseRow + rowInBlock][blockBaseColumn + colInBlock];
}

-(int) getBlockForRow:(int)row andColumn:(int)column
{
    /* Gets the block number for the cell at row and column */
    int blockRow = row / BLOCK_WIDTH;
    int blockColumn = column / BLOCK_WIDTH;
    
    return blockRow * BLOCK_WIDTH + blockColumn;
}

-(int) getBlockBaseRow: (int) block
{
    /* Gets the first row for the given block */
    int blockRow = block / BLOCK_WIDTH;
    return blockRow * BLOCK_WIDTH;
}

-(int) getBlockBaseColumn: (int) block
{
    /* Gets the first column for the given block */
    int blockColumn = block % BLOCK_WIDTH;
    return blockColumn * BLOCK_WIDTH;
}

-(void) getNewGrid {
    for (int i = 0; i < 9; i++)
        for (int j = 0; j < 9; j++)
            [self emptyCellAtRow:i andColumn:j];
    
    //SudokuGenerator *generator = [[SudokuGenerator alloc] init];
    
   // [generator generateNewGrid];
   // [generator copyIntoGrid:self];
}

-(BOOL) generateGridStartingAtRow:(int) row andColumn: (int) column
{
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int numLength = 9;
    
    while (numLength > 0) {
        /* Choose random, unchosen number */
        int index = arc4random() % numLength;
        int number = numbers[index];
        
        /* "Delete" number from list */
        numbers[index] = numbers[numLength - 1];
        numLength --;
        
        if ([self isValue: number consistentAtRow:row andColumn:column]) {
            [self setImmutableValue:number atRow:row atColumn:column];
            _solution[row][column] = number;
            
            if (row == 8 && column == 8) {
                /* Base case, we've found a fully consistent grid ! */
                return YES;
            }
            
            /* Recurse to search for more solutions in this direction */
            int newRow = column == 8 ? row + 1 : row;
            int newColumn = (column + 1) % 9;
            
            if ([self generateGridStartingAtRow:newRow andColumn:newColumn]) 
                return YES;
            
            
            /* If the number was inconsistent, re-empty the cell */
            [self emptyCellAtRow:row andColumn:column];
        }
    }
    
    /* If no number works, then there is no grid in this direction, return false */
    return NO;
}
@end
