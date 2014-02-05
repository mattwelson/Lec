//
//  RecordViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lecture.h"
#import "PullupTableViewController.h"

@interface RecordViewController : PullupTableViewController

-(id)initWithLecture:(Lecture *)lecture;

@end
