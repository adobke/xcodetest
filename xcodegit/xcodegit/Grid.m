//
//  Grid.m
//  Prototype
//
//  Created by Travis Athougies on 9/18/12.
//  Copyright (c) 2012 com.adobke.tathougies. All rights reserved.
//

#import "Grid.h"
#import "Solver.h"


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

-(id) initWithGrid: (Grid*) grid
{
    if (self = [super init]) {
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

-(id) initWithString: (NSString*) gridString
{
    if (self = [super init]) {
        assert([gridString length] == 81);
        for (int i = 0; i < GRID_SIZE; ++i) {
            for (int j = 0; j < GRID_SIZE; ++j) {
                int val = [gridString characterAtIndex:GRID_SIZE*i+j]-48;
                if ( (val >= 1) && (val <= GRID_SIZE)) {
                    [self setImmutableValue:val atRow:i atColumn:j];
                    //_data[j][i] = val;
                    //_mutable[i][j] = false;
                } else {
                    [self emptyCellAtRow:i andColumn:j];
                    //_data[j][i] = EMPTY;
                    //_mutable[i][j] = true;
                }
            }
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
    Solver *solver = [[Solver alloc] init];
    //SudokuGenerator *generator = [[SudokuGenerator alloc] init];
    
   // [generator generateNewGrid];
   // [generator copyIntoGrid:self];
    
    
    
    
}

-(void) emptyGridCells:(int) cellCount
{
    /* Takes a completely filled in Sudoku grid and empties the specified amount of cells, while ensuring there is still a unique solution */
    int retries = 0;
    int cellsEmptied = 0;
    Solver *solver = [[Solver alloc] init];
    
    while (cellsEmptied < cellCount && retries < 5) {
        int row = arc4random() % 9;
        int col = arc4random() % 9;
        int oldValue = [self getValueAtRow:row andColumn:col];
        
        [self emptyCellAtRow:row andColumn:col];
        
        if (cellsEmptied > 3) {
            /* We can always empty 3 cells, without needing to check that the solutions are unique */
            
            BOOL uniqueSolution = YES;
            
            //for (int i = 1; i <= 9; ++i) {
            //    if (i == oldValue) continue; /* Skip the old value */
           //     if (![self isValue:i consistentAtRow:row andColumn:col]) continue; /* Don't try values that don't work for sure */
                
           //     [self setValue:i atRow:row atColumn:col];
                
                if ([solver getNumSolsFor: self] > 1) { /* If the grid has a solution here, the solution is not unique, so we can't remove oldValue */
                    uniqueSolution = NO;
                    [self setValue:oldValue atRow:row atColumn:col];
                    //break;
                }
           // }
            
            if (uniqueSolution) {
                cellsEmptied++;
                retries = 0;
                [self emptyCellAtRow:row andColumn:col];
                //printf("Emptied: %d\n", cellsEmptied);
                //[grid printGrid];
            } else {
                [self setValue:oldValue atRow:row atColumn:col];
                retries++;
            }
        } else {
            cellsEmptied ++;
            //[grid printGrid];
        }
    }
}


-(BOOL) generateGridStartingAtRow:(int) row andColumn: (int) column
{
    int* count = malloc(sizeof(int));
    *count = 0;
    return [self generateGridStartingAtRow:row andColumn:column rCount: count];
}

-(BOOL) generateGridStartingAtRow:(int) row andColumn: (int) column rCount:(int*) rc
{
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int numLength = 9;
    
    if ((*rc)++ > 10000000)
        return NO;

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
            
            if ([self generateGridStartingAtRow:newRow andColumn:newColumn rCount:rc])
                return YES;
            
            
            /* If the number was inconsistent, re-empty the cell */
            [self emptyCellAtRow:row andColumn:column];
        }
    }
    
    /* If no number works, then there is no grid in this direction, return false */
    return NO;
}

-(const char*) toString
{
    NSMutableString* string = [[NSMutableString alloc] init];
    for (int i = 0; i < GRID_SIZE; ++i) {
        for (int j = 0; j < GRID_SIZE; ++j) {
            
            if (_data[i][j] != EMPTY)
                [string appendFormat:@"%i", _data[i][j]];
            else
                [string appendString:@"."];
        }
    }
    return [string UTF8String];
}

int main(int argc, const char* argv []) {
    printf("Begin\n");
    FILE *fp = fopen("outputSudokus.txt","r");
    
    
    
     char board[82];
    Grid* grid = [[Grid alloc] init];
    Solver* solver = [[Solver alloc] init];
    while (fgets (board,sizeof board,fp) != NULL)
    {
        [grid initWithString: [NSString stringWithCString:board length:81]];
        [solver getNumSolsFor:grid];
    }
     
    /*
    Grid* grid = [[Grid alloc] init];
    
    for(int i = 0; i < 29999; ++i)
    {
        //printf("Generating\n");
        if(![grid generateGridStartingAtRow:0 andColumn:0]) {
            i--;
            continue;
        }
        //printf("%s\n",[grid toString]);
        //printf("Emptying\n");
        [grid emptyGridCells:80];
        fprintf(fp,"%s\n",[grid toString]);
        //printf("%s\n",[grid toString]);

        if( (i % 10) == 0)
            printf("%i\n",i);
    }
     */
    fclose(fp);
    return 0;
}
@end
