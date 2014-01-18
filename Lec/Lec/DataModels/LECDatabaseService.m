//
//  LECDatabaseService.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECDatabaseService.h"

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

@end
