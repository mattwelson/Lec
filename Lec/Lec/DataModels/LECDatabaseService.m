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
    return [NSMutableArray arrayWithArray:courses];
}

// should work!
- (Course *) newCourseForAdding
{
    Course *dbCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    return dbCourse;
}

- (BOOL) saveChanges
{
    NSError *error;
    if ([self.managedObjectContext save:&error]) return YES;
    [NSException raise:@"DB I/O" format:@"Save failed: %@", [error localizedDescription]];
    return NO;
}

@end
