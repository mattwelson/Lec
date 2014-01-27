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

- (id)initWithCourse:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedCourse:(Course *)course
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewModel = [LECCourseViewModel courseViewModelWithCourse:course];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navagationTopBar];
    // Do any additional setup after loading the view from its nib.
    for(LECLectureCellViewModel *leccell in viewModel.tableData)
    {
        NSLog(@"%@ - %@", leccell.titleText, leccell.subText);
    }
}

- (void) navagationTopBar
{
    self.navigationItem.title = viewModel.navTitle;
    [self.navigationController.navigationBar setBarTintColor:[viewModel tintColour]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) backButtPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
