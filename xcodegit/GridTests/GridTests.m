//
//  GridTests.m
//  GridTests
//
//  Created by jarthur on 12/29/12.
//
//

#import "GridTests.h"

@implementation GridTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEmptyGrid
{
    Grid* testGrid = [[Grid alloc] init];
    for (int i = 0; i< GRID_SIZE; ++i) {
        for (int j = 0; j< GRID_SIZE; ++j) {
            STAssertEquals( [testGrid getValueAtRow:i andColumn:j], EMPTY, @"Test if grid is empty on it");
        }
    }
    
    for (int i = 0; i< GRID_SIZE; ++i) {
        for (int j = 0; j< GRID_SIZE; ++j) {
            for(int x = 0; x<GRID_SIZE; ++x) {
                STAssertTrue([testGrid isValue:x consistentAtRow:i andColumn:j], @"All values are consistent everywhere at first");
            }
        }
    }
}

- (void)testCopy
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid setValue:4 atRow:4 atColumn:2];
    STAssertEquals([testGrid getValueAtRow:4 andColumn:2], 4, @"Copy value pre check");
    Grid* testGridCopy = [[Grid alloc] initWithGrid: testGrid];
    STAssertEquals([testGridCopy getValueAtRow:4 andColumn:2], 4, @"Copy value check");
    [testGridCopy setValue: 5 atRow:4 atColumn:2];
    STAssertEquals([testGridCopy getValueAtRow:4 andColumn:2], 5, @"Copy value mutated check");
    STAssertEquals([testGrid getValueAtRow:4 andColumn:2], 4, @"Copy value mutated original check");
}

- (void)testCopySelf
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid setValue:4 atRow:4 atColumn:2];
    STAssertEquals([testGrid getValueAtRow:4 andColumn:2], 4, @"Copy value pre check");
    testGrid = [[Grid alloc] initWithGrid: testGrid];
    STAssertEquals([testGrid getValueAtRow:4 andColumn:2], 4, @"Copy value check");
    [testGrid setValue: 5 atRow:4 atColumn:2];
    STAssertEquals([testGrid getValueAtRow:4 andColumn:2], 5, @"Copy value mutated check");
}

-(void) testFillGrid
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    for (int i = 0; i< GRID_SIZE; ++i) {
        for (int j = 0; j< GRID_SIZE; ++j) {
            STAssertTrue([testGrid getValueAtRow:i andColumn:j] != EMPTY , @"generateGrid fills up everything");
        }
    }
}

-(void) testConsistancyTrivial
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    int value = [testGrid getValueAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:0];
    STAssertEquals(EMPTY, [testGrid getValueAtRow:0 andColumn: 0], @"sanity");
    STAssertTrue([testGrid isValue:value consistentAtRow:0 andColumn:0], @"Reinserting value should be allowed");
    [testGrid setValue:value atRow:0 atColumn:0];
    STAssertEquals(value, [testGrid getValueAtRow:0 andColumn: 0], @"sanity");
}

-(void) testSolverFull
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];
    STAssertEquals(1, [solver getNumSols], @"solver can solve an already solved grid");
}

-(void) testSolverTrivial
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:0];
    STAssertEquals(EMPTY, [testGrid getValueAtRow:0 andColumn: 0], @"sanity");
    STAssertTrue( [testGrid isMutableAtRow:0 andColumn:0], @"sanity");
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];
    STAssertEquals(1, [solver getNumSols], @"solver can solve a trivial grid");
}

-(void) testSolverSimple
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:9 andColumn:9];
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];
    STAssertEquals(1, [solver getNumSols], @"solver can solve a simple grid");
}

-(void) testSolverImpossible
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    int value = [testGrid getValueAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:0];
    [testGrid setValue:value atRow:1 atColumn:0];
    STAssertEquals(value, [testGrid getValueAtRow:1 andColumn: 0], @"sanity");
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];
    STAssertEquals(0, [solver getNumSols], @"solver cannot solve an impossible grid");
    STAssertFalse([solver setSolution], @"solver cannot solve an impossible grid");

}

-(void) testNotSure
{
    Grid* testGrid = [[Grid alloc] init];
    [testGrid generateGridStartingAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:0];
    [testGrid emptyCellAtRow:0 andColumn:1];
    [testGrid emptyCellAtRow:0 andColumn:2];
    [testGrid emptyCellAtRow:1 andColumn:0];
    [testGrid emptyCellAtRow:1 andColumn:1];
    [testGrid emptyCellAtRow:1 andColumn:2];
    [testGrid emptyCellAtRow:2 andColumn:0];
    [testGrid emptyCellAtRow:2 andColumn:1];
    [testGrid emptyCellAtRow:2 andColumn:2];
    
    [testGrid emptyCellAtRow:6 andColumn:6];
    [testGrid emptyCellAtRow:6 andColumn:7];
    [testGrid emptyCellAtRow:6 andColumn:8];
    [testGrid emptyCellAtRow:7 andColumn:6];
    [testGrid emptyCellAtRow:7 andColumn:7];
    [testGrid emptyCellAtRow:7 andColumn:8];
    [testGrid emptyCellAtRow:8 andColumn:6];
    [testGrid emptyCellAtRow:8 andColumn:7];
    [testGrid emptyCellAtRow:8 andColumn:8];
    
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];

    NSLog(@"num sols: %i", [solver getNumSols]);
}

-(void) testAKnownGrid
{
    Grid* testGrid = [[Grid alloc] init];

    /* Creates a hardcoded grid */
    [testGrid setImmutableValue:5 atRow:0 atColumn:0];
    [testGrid setImmutableValue:3 atRow:0 atColumn:1];
    [testGrid setImmutableValue:7 atRow:0 atColumn:4];
    [testGrid setImmutableValue:6 atRow:1 atColumn:0];
    [testGrid setImmutableValue:1 atRow:1 atColumn:3];
    
    [testGrid setImmutableValue:9 atRow:1 atColumn:4];
    [testGrid setImmutableValue:5 atRow:1 atColumn:5];
    [testGrid setImmutableValue:9 atRow:2 atColumn:1];
    [testGrid setImmutableValue:8 atRow:2 atColumn:2];
    [testGrid setImmutableValue:6 atRow:2 atColumn:7];
    
    [testGrid setImmutableValue:8 atRow:3 atColumn:0];
    [testGrid setImmutableValue:6 atRow:3 atColumn:4];
    [testGrid setImmutableValue:3 atRow:3 atColumn:8];
    [testGrid setImmutableValue:4 atRow:4 atColumn:0];
    [testGrid setImmutableValue:8 atRow:4 atColumn:3];
    
    [testGrid setImmutableValue:3 atRow:4 atColumn:5];
    [testGrid setImmutableValue:1 atRow:4 atColumn:8];
    [testGrid setImmutableValue:7 atRow:5 atColumn:0];
    [testGrid setImmutableValue:2 atRow:5 atColumn:4];
    [testGrid setImmutableValue:6 atRow:5 atColumn:8];
    
    [testGrid setImmutableValue:6 atRow:6 atColumn:1];
    [testGrid setImmutableValue:2 atRow:6 atColumn:6];
    [testGrid setImmutableValue:8 atRow:6 atColumn:7];
    [testGrid setImmutableValue:4 atRow:7 atColumn:3];
    [testGrid setImmutableValue:1 atRow:7 atColumn:4];
    
    [testGrid setImmutableValue:9 atRow:7 atColumn:5];
    [testGrid setImmutableValue:5 atRow:7 atColumn:8];
    [testGrid setImmutableValue:8 atRow:8 atColumn:4];
    [testGrid setImmutableValue:7 atRow:8 atColumn:7];
    [testGrid setImmutableValue:9 atRow:8 atColumn:8];
    
    Solver* solver = [[Solver alloc] initWithGrid:testGrid];
    STAssertTrue([solver setSolution], @"solver can solve a known grid");
    for (int i = 0; i< GRID_SIZE; ++i) {
        for (int j = 0; j< GRID_SIZE; ++j) {
            STAssertTrue([testGrid solutionAtRow:i andColumn:j] != EMPTY , @"solution finder fills up everything");
        }
    }
}

@end
