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

+(LECDatabaseService *) databaseServiceForManagedObjectContext:(NSManagedObjectContext *)obcon;

-(NSMutableArray *) getCourses;

-(Course *) newCourseForAdding;
-(BOOL) saveChanges;

@end
