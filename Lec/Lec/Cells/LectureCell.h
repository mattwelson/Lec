//
//  LectureCell.h
//  Lec
//
//  Created by Matt Welson on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewController.h"

@interface LectureCell : UITableViewCell

-(void)populateFor:(LECLectureCellViewModel *)vm;

@property LECLectureCellViewModel *vm;

@property UILabel *courseNameLabel;
@property UILabel *courseDescriptionLabel;

@end
