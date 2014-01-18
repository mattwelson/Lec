//
//  Lecture.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Lecture : NSManagedObject

@property (nonatomic, retain) NSString * lectureDescription;
@property (nonatomic, retain) NSString * lectureName;
@property (nonatomic, retain) NSString * recordingPath;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Lecture (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
