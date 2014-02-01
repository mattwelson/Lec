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
    vm.recordingPath = [lecture recordingPath];
    vm.courseName = [[lecture course] courseName];
    
    NSString *recordingPath= [NSString stringWithFormat:@"%@_%@_%@",vm.courseName, vm.subTitle, vm.navTitle];
    vm.recordingPath = [[recordingPath stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingPathExtension:FILE_RECORDING_TYPE];
    
    return vm;
}

#pragma mark Recording
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

#pragma mark Playback

@end
