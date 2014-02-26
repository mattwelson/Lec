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
#import "LECDefines.h"
#import "TagCell.h"

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
    [self.tableView registerClass:[TagCell class] forCellReuseIdentifier:CELL_ID_TAG_CELL];
}

-(void)createHeaderView
{
    self.headerView = [[LECHeaderView alloc] initWithLecture:viewModel];
    [self.view addSubview:self.headerView];
}

#pragma mark Abstract methods implemented
-(UITableViewCell *) cellForIndexRow:(NSInteger)indexRow
{
    TagCell *cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_TAG_CELL];
    LECTagCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexRow];
    [cell populateFor:cellViewModel];
    return (UITableViewCell *)cell;
}

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
    [viewModel addTagToCurrentTime];
    [self.tableView reloadData];
    // scroll to keep new cell at bottom of screen
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[viewModel.tableData count]-1 inSection:contentSection];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
