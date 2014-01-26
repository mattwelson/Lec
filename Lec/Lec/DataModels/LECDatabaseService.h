//
//  LECDatabaseService.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Lecture.h"
#import "Tag.h"

@interface LECDatabaseService : NSObject

@property NSManagedObjectContext *managedObjectContext;

+ (LECDatabaseService *) sharedDBService;

#pragma mark Course Operations
- (NSMutableArray *) getCourses;
- (Course *) newCourseForAdding;

#pragma mark Lecture Operations
- (Lecture *) newLectureForCourse:(Course *)course;

#pragma mark Tag Operations
-(Tag *) newTagForLecture:(Lecture *)lecture;

#pragma mark General Operations
- (BOOL) saveChanges;
- (void) deleteObject:(NSManagedObject *)object;

@end
