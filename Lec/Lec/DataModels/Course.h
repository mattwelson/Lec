//
//  Course.h
//  Lec
//
//  Created by Julin Le-Ngoc on 14/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lecture;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * courseIndex;
@property (nonatomic, retain) NSSet *lectures;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addLecturesObject:(Lecture *)value;
- (void)removeLecturesObject:(Lecture *)value;
- (void)addLectures:(NSSet *)values;
- (void)removeLectures:(NSSet *)values;

@end
