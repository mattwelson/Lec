//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCourse:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedCourse:(LECDummyCourse *)course
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedCourse = course;
        NSString *name = selectedCourse.courseName;
        NSLog(@"Course: [%@] has been pressed!", name);
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navagationTopBar];
    // Do any additional setup after loading the view from its nib.
}

- (void) navagationTopBar
{
    
    self.navigationItem.title = selectedCourse.courseName;
}

- (void) backButPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
