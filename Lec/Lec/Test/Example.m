//
//  Example.m
//  Lec
//
//  Created by Matt Welson on 26/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "Example.h"

@implementation Example

+(void)addCoursePopulated
{
    LECDatabaseService *dbService = [LECDatabaseService sharedDBService];
    // Create new course
    Course *newCourse = [dbService newCourseForAdding];
    newCourse.courseName = @"Test101";
    newCourse.courseDescription = @"An introduction to testing";
    newCourse.colour = @"Red";
    newCourse.icon = @"cs";
    [dbService saveChanges];
    
    // Add lecture
    Lecture *newLecture = [dbService newLectureForCourse:newCourse];
    newLecture.lectureName = @"The first lecture ever";
    newLecture.lectureNumber = [NSNumber numberWithShort:1];
    
    // Add Tags
    Tag *tag;
    NSArray *names = [NSArray arrayWithObjects:@"Hello", @"Friend", @"How", @"Are", @"You", nil];
    for (NSString *name in names)
    {
        tag = [dbService newTagForLecture:newLecture];
        tag.name = name;
    }
    [dbService saveChanges];
}

// Stuff below will not work in this setting without modifications
-(void)simpleDataTest
{
    //[self directInteraction];
    [self dbService];
}

-(void)directInteraction
{
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    course.courseName = @"Hi Mom!";
    course.courseDescription = @"Different description!";
    course.colour = @"Purply-pink!";
    course.icon = @"Jolly roger";
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"GODDAMMIT! %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error) NSLog(@"Fetching failed");
    for (Course *c in fetchedObjects){
        NSLog(@"%@: %@", c.courseName, c.courseDescription);
    }
}

-(void)dbService
{
    /* Done in init of view model or else stored in app delegate globally */
    LECDatabaseService *dbService = [LECDatabaseService sharedDBService];
    
    /* Retrieves an empty course ready to be editted */
    Course *course = [dbService newCourseForAdding];
    
    /* Looks chunky but will be done through direct user editting (and perhaps defaults ) */
    course.courseName = @"Hi Shared Service!";
    course.courseDescription = @"Different description!";
    course.colour = @"Purple";
    course.icon = @"Jolly roger";
    
    /* Saves changes with error handling */
    [dbService saveChanges];
    
    /* Just prints out the retrieved objects from db */
    NSArray *fetchedObjects = [dbService getCourses];
    for (Course *c in fetchedObjects){
        NSLog(@"%@: %@", c.courseName, c.courseDescription);
    }
}

@end
