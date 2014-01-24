//
//  LECDatabaseService.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"


@interface LECDatabaseService : NSObject

@property NSManagedObjectContext *managedObjectContext;

+ (LECDatabaseService *) sharedDBService;

#pragma mark Course Operations
- (NSMutableArray *) getCourses;
- (Course *) newCourseForAdding;
- (BOOL) saveChanges;

- (void) deleteObject:(NSManagedObject *)object;

@end
