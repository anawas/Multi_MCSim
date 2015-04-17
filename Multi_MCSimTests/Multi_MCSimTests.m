//
//  Multi_MCSimTests.m
//  Multi_MCSimTests
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AccelerationSensor.h"

@interface Multi_MCSimTests : XCTestCase

@end

@implementation Multi_MCSimTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    AccelerationSensor *sensor = [[AccelerationSensor alloc] init];
    NSLog(@"AccelerationSensor stream = %@", [sensor readDataStream]);
    
    for (int i = 0; i < 100; i++) {
        [sensor generateNewData];
        NSLog(@"GSMSensor stream = %@", [sensor readDataStream]);
    }
}

@end
