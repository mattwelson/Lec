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

@implementation LECLectureViewModel

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture
{
    LECLectureViewModel *vm = [[LECLectureViewModel alloc] init];
    vm.lecture = lecture;
    vm.icon = lecture.course.icon;
    vm.colourString = lecture.course.colour;
    vm.navTitle = [lecture lectureName];
    vm.subTitle = [NSString stringWithFormat:@"Lecture %@", [lecture lectureNumber]];
    
    vm.courseName = [[lecture course] courseName];
    
    vm.recordingPath = [lecture recordingPath];
    if ([vm.recordingPath length] > 0) {
        vm.needsRecording = NO;
        NSLog(@"%@", vm.recordingPath);
    } else {
        [vm setInitialRecordingPath];
        vm.needsRecording = YES;
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
}

#pragma mark Playback
-(void) prepareForPlayback
{
    [[LECAudioService sharedAudioService] setupAudioPlayback:[self recordingPath]];
}

-(void) startAudioPlayback
{
    [[LECAudioService sharedAudioService] startPlayback];
}

-(void) stopAudioPlayback
{
    [[LECAudioService sharedAudioService] stopPlayback];
}

@end
