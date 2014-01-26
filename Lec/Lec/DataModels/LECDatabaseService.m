//
//  LECDatabaseService.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECDatabaseService.h"
#import "Course.h"

@implementation LECDatabaseService

static LECDatabaseService *sharedInstance = nil;

+ (id) sharedDBService
{
    if (sharedInstance) return sharedInstance;
    
    sharedInstance = [[LECDatabaseService alloc] init];
    if (sharedInstance)
    {
        [sharedInstance setManagedObjectContext:[(id)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    }
    return sharedInstance;
}

- (NSMutableArray *) getCourses
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    NSArray *courses = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"Database exception!" format:@"Oh no"];
    }
    return [NSMutableArray arrayWithArray:[[courses reverseObjectEnumerator] allObjects]];
}

- (Course *) newCourseForAdding
{
    Course *dbCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    return dbCourse;
}

-(Lecture *) newLectureForCourse:(Course *)course
{
    Lecture *dbLecture = [NSEntityDescription insertNewObjectForEntityForName:@"Lecture" inManagedObjectContext:self.managedObjectContext];
    dbLecture.course = course;
    return dbLecture;
}

-(Tag *)newTagForLecture:(Lecture *)lecture
{
    Tag *dbTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    dbTag.lecture = lecture;
    return dbTag;
}

- (BOOL) saveChanges
{
    NSError *error;
    if ([self.managedObjectContext save:&error]) return YES;
    [NSException raise:@"DB I/O" format:@"Save failed: %@", [error localizedDescription]];
    return NO;
}

-(void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
    [self saveChanges];
}

@end
