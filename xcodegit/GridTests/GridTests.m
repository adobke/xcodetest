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
@end
