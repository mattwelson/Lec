//
//  Lecture.h
//  Lec
//
//  Created by Matt Welson on 26/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Tag;

@interface Lecture : NSManagedObject

@property (nonatomic, retain) NSNumber * lectureNumber;
@property (nonatomic, retain) NSString * lectureName;
@property (nonatomic, retain) NSString * recordingPath;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Lecture (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
