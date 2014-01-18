//
//  LECDummyCourse.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LECDummyCourse : NSObject

@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSSet *lectures;

+(LECDummyCourse *)dummyCourse:(NSString *)title;

@end
