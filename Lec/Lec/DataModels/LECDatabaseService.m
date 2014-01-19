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

+(LECDatabaseService *) databaseServiceForManagedObjectContext:(NSManagedObjectContext *)obcon
{
    LECDatabaseService *service;
    if (service)
    {
        service.managedObjectContext = obcon;
    }
    return service;
}

-(NSMutableArray *) getCourses
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"fr_get_courses"];
    NSError *error;
    NSArray *courses = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"Database exception!" format:@"Oh no"];
    }
    return [NSMutableArray arrayWithArray:courses];
}

// should work!
-(BOOL) addNewCourse:(LECCourseCellViewModel *)newCourse
{
    Course *dbCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    dbCourse.courseDescription = newCourse.subText;
    dbCourse.courseName = newCourse.titleText;
    NSError *error;
    [self.managedObjectContext save:&error];
    return error == NULL;
}

@end
