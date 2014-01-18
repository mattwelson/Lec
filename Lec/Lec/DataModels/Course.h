//
//  Course.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSSet *lectures;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addLecturesObject:(NSManagedObject *)value;
- (void)removeLecturesObject:(NSManagedObject *)value;
- (void)addLectures:(NSSet *)values;
- (void)removeLectures:(NSSet *)values;

@end
