//
//  LECLectureViewModel.m
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLectureViewModel.h"
#import "LECAudioService.h"
#import "LECDefines.h"
#import "LECTagCellViewModel.h"

@implementation LECLectureViewModel

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture
{
    LECLectureViewModel *vm = [[LECLectureViewModel alloc] init];
    vm.lecture = lecture;
    vm.icon = lecture.course.icon;
    vm.colourString = lecture.course.colour;
    vm.subTitle = [lecture lectureName];
    vm.navTitle = [NSString stringWithFormat:@"Lecture %@", [lecture lectureNumber]];
    
    vm.courseName = [[lecture course] courseName];
    
    vm.recordingPath = [lecture recordingPath] ;
    if (!vm.recordingPath) {
        [vm setInitialRecordingPath];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(currentTime)) ascending:YES];
    NSArray *sortedTags = [lecture.tags sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (Tag *tag in sortedTags)
    {
        [vm.tableData addObject:[LECTagCellViewModel tagCellVMWithTag:tag andColour:vm.colourString]];
    }
    return vm;
}

#pragma mark Recording
-(void) setInitialRecordingPath
{
    NSString *recordingPath= [NSString stringWithFormat:@"%@_%@_%@",self.courseName, self.subTitle, self.navTitle];
    self.recordingPath = [[recordingPath stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingPathExtension:FILE_RECORDING_TYPE];
    
    self.lecture.recordingPath = self.recordingPath;
    [[LECDatabaseService sharedDBService] saveChanges];
}

-(void)prepareForRecordingAudio
{
    [[LECAudioService sharedAudioService] setupAudioRecordingForPath:[self recordingPath]];
}

-(void)startRecordingAudio
{
    [[LECAudioService sharedAudioService] startRecording];
}

-(void)stopRecordingAudio
{
    [[LECAudioService sharedAudioService] stopRecording];
}

-(void) addTagToCurrentTime
{
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = [[LECAudioService sharedAudioService] getCurrentTime];
    tag.name = @"Hi, I'm a tag";
    [[LECDatabaseService sharedDBService] saveChanges];
    [self.tableData addObject:[LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString]];
}

#pragma mark Playback
-(void) prepareForPlaybackWithCompletion:(void (^)(void))block
{
    [[LECAudioService sharedAudioService] setupAudioPlayback:[self recordingPath] withCompletion:block];
}

-(void) startAudioPlayback
{
    [[LECAudioService sharedAudioService] startPlayback];
}

-(void) stopAudioPlayback
{
    [[LECAudioService sharedAudioService] stopPlayback];
}

-(void)goToTag:(NSInteger)index
{
    LECTagCellViewModel *tagCVM = self.tableData[index];
    [[LECAudioService sharedAudioService] goToTime:[tagCVM time]];
}

-(void)insertTagAtCurrentTime
{
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = [[LECAudioService sharedAudioService] getCurrentTime];
    tag.name = @"Hi, I'm a PLAYBACK tag";
    [[LECDatabaseService sharedDBService] saveChanges];
    LECTagCellViewModel *tagCVM = [LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString];

    NSUInteger newIndex = [self.tableData indexOfObject:tagCVM inSortedRange:NSMakeRange(0, self.tableData.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(LECTagCellViewModel *obj1, LECTagCellViewModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    
    [self.tableData insertObject:tagCVM atIndex:newIndex];
}

@end
