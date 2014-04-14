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
{
    NSInteger currentTag;
}

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture
{
    LECLectureViewModel *vm = [[LECLectureViewModel alloc] init];
    vm.lecture = lecture;
    vm.icon = lecture.course.icon;
    vm.colourString = lecture.course.colour;
    vm.navTitle = [lecture lectureName];
    vm.subTitle = [NSString stringWithFormat:@"Lecture %@", [lecture lectureNumber]];
    
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
    
    vm.canTag = YES;
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
    [self insertTagAtStart];
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
    currentTag = 0;
    ((LECTagCellViewModel *)self.tableData[currentTag]).playState = isPlaying;
}

-(void) startAudioPlayback
{
    [[LECAudioService sharedAudioService] setDelegate:self];
    [[LECAudioService sharedAudioService] startPlayback];
}

-(void) stopAudioPlayback
{
    [[LECAudioService sharedAudioService] stopPlayback];
}

-(BOOL) audioIsPlaying
{
    return [[LECAudioService sharedAudioService] isAudioPlaying];
}

-(void)goToTag:(NSInteger)index
{
    self.canTag = YES;
    LECTagCellViewModel *tagCVM = self.tableData[index];
    [[LECAudioService sharedAudioService] goToTime:[tagCVM time]];
    
    for (int i = 0; i < [self.tableData count]; i ++)
    {
        if (i < index)
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = hasPlayed;
        }
        else if (i > index)
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = notPlayed;
        }
        else
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = isPlaying;
            ((LECTagCellViewModel *)self.tableData[i]).progress = 0;
            currentTag = index;
        }
    }
}

-(BOOL)insertTagAtStart
{
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = @0;
    tag.name = @"Intro";
    [[LECDatabaseService sharedDBService] saveChanges];
    LECTagCellViewModel *tagCVM = [LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString];
    
    NSUInteger newIndex = [self.tableData indexOfObject:tagCVM inSortedRange:NSMakeRange(0, self.tableData.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(LECTagCellViewModel *obj1, LECTagCellViewModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    
    [self.tableData insertObject:tagCVM atIndex:newIndex];
    return YES;
}

-(BOOL)insertTagAtCurrentTime
{
    if (!self.canTag) return NO;
    
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = [[LECAudioService sharedAudioService] getCurrentTime];
    tag.name = @"Hi, I'm a PLAYBACK tag";
    [[LECDatabaseService sharedDBService] saveChanges];
    LECTagCellViewModel *tagCVM = [LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString];

    NSUInteger newIndex = [self.tableData indexOfObject:tagCVM inSortedRange:NSMakeRange(0, self.tableData.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(LECTagCellViewModel *obj1, LECTagCellViewModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    
    [self.tableData insertObject:tagCVM atIndex:newIndex];
    return YES;
}

#pragma mark - Crazy tag shit
-(void)playbackIsAtTime:(double)time
{
    // forward only for now
    CGFloat progress = time / [[LECAudioService sharedAudioService] getRecordingLength];
    [self setCurrentTagProgress:progress];
    NSLog(@"%f", progress);
}

-(void)setCurrentTagProgress:(CGFloat)progress
{
    [(LECTagCellViewModel *)[self.tableData objectAtIndex:currentTag] setProgress:progress];
    [self.delegate reloadTable];
}

@end
