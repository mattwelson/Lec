//
//  CourseCell.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LECCourseCellViewModel;

@interface CourseCell : UITableViewCell

-(void)populateFor:(LECCourseCellViewModel *)vm;

@property UILabel *courseNameLabel;
@property UILabel *courseDescriptionLabel;

@end
