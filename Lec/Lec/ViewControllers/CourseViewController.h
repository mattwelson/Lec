//
//  CourseViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"

@interface CourseViewController : UIViewController{
    LECDummyCourse *selectedCourse;
}
- (id)initWithCourse:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedCourse:(NSObject *)course;

@end
