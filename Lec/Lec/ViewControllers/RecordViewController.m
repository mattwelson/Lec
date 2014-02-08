//
//  RecordViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "RecordViewController.h"
#import "LECImportHeader.h"
#import "LECActionBar.h"

@interface RecordViewController (){
    LECLectureViewModel *viewModel;
}

@end

@implementation RecordViewController

- (id)initWithLecture:(Lecture *)lecture
{
    self = [super initWithNibName:@"RecordViewController" bundle:nil];
    if (self) {
        NSLog(@"Recording View Controller!");
        viewModel = [LECLectureViewModel viewModelWithLecture:lecture];
        [viewModel prepareForRecordingAudio];
        [viewModel startRecordingAudio];
        
        contentSection = 1; // the section with table data
        actionSection = 2; // the section with an action bar
        hasFooter = YES;
        noSections = 2;
        
        actionBar = [LECActionBar tagBarWithTarget:self andSelector:@selector(actionBarPressed)];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [viewModel stopRecordingAudio];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)courseTableViewSetup
{
    [super courseTableViewSetup];
    // register tag cell for resuse
}

-(void)createHeaderView
{
    self.headerView = [[LECHeaderView alloc] initWithLecture:viewModel];
    [self.view addSubview:self.headerView];
}

#pragma mark Abstract methods implemented
-(void)deleteObjectFromViewModel:(NSInteger)index
{
    // delete tag!
}

-(id) viewModelFromSubclass
{
    return viewModel;
}

-(NSArray *) tableData
{
    return viewModel.tableData;
}

-(void) didSelectCellAt:(NSInteger)index
{
    // play tag?
}

-(void) actionBarPressed
{
    NSLog(@"Push me good");
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
