//
//  Tag.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lecture;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * currentTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Lecture *lecture;

@end
