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
    
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"courseIndex"
                                ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *courses = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        [NSException raise:@"Database exception!" format:@"Oh no"];
    }
    return [NSMutableArray arrayWithArray:courses];
    
//  return [NSMutableArray arrayWithArray:[[courses reverseObjectEnumerator] allObjects]];
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
    if ([object isKindOfClass:[Lecture class]]) {
        [self deleteLectureFile:(Lecture *)object];
    }
    [self.managedObjectContext deleteObject:object];
    [self saveChanges];
}

-(void) deleteLectureFile:(Lecture *)lecture
{
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    NSError *error;
//
//    NSURL *documentFolderURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:Nil create:NO error:&error];
//    NSURL *fileURL = [documentFolderURL URLByAppendingPathComponent:lecture.recordingPath];
//    NSString *filePath = [fileURL absoluteString];
//    NSLog(@"FIle path %@", filePath);
//    if ([fileManager fileExistsAtPath:filePath]) {
//        NSError* deletionError;
//        [fileManager removeItemAtPath:filePath error:&deletionError];
//    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSURL *documentFolderURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:Nil create:NO error:&error];
    NSURL *fileURL = [documentFolderURL URLByAppendingPathComponent:lecture.recordingPath];
    if ([fileURL checkResourceIsReachableAndReturnError:&error]) {
        NSError* deletionError;
        [fileManager removeItemAtURL:fileURL error:&deletionError];
    }
}


@end
