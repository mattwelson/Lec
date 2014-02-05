//
//  RecordViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "RecordViewController.h"
#import "LECImportHeader.h"

@interface RecordViewController (){
    LECLectureViewModel *viewModel;
}

@end

@implementation RecordViewController

- (id)initWithLecture:(Lecture *)lecture
{
    self = [super initWithNibName:@"RecordViewController" bundle:nil];
    if (self) {
        viewModel = [LECLectureViewModel viewModelWithLecture:lecture];
        
        if (viewModel.needsRecording){
            [viewModel prepareForRecordingAudio];
            [viewModel startRecordingAudio];
        } else {
            [viewModel prepareForPlayback];
            [viewModel startAudioPlayback];
        }
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (viewModel.needsRecording){
        [viewModel stopRecordingAudio];
    } else {
        [viewModel stopAudioPlayback];
    }
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

@end
