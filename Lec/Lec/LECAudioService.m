//
//  LECAudioService.m
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECAudioService.h"

@implementation LECAudioService {
    AVAudioSession *session;
    NSURL *recordingPath;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}

static LECAudioService *sharedService;

+ (LECAudioService *)sharedAudioService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECAudioService alloc] init];
    return sharedService;
}

#pragma mark Recording
-(void) setupAudioRecordingForPath:(NSString *)path
{
    session = [AVAudioSession sharedInstance];
    
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
    
    recordingPath = [self recordingPath:path];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordingPath settings:[self audioRecordingSettings] error:&error];
    if (error) {
        @throw [NSException exceptionWithName:@"Audio Recording failed" reason:@"Dammit" userInfo:nil];
    }
    
    audioRecorder.delegate = self;
    
    if ([audioRecorder prepareToRecord])
    {
        NSLog(@"Good to roll");
    }
}

-(void) startRecording
{
    if ([audioRecorder record])
    {
        NSLog(@"WOOOOO!");
        return;
    }
    @throw [NSException exceptionWithName:@"Recording failed to start" reason:@"Reason? Don't know" userInfo:nil];
}

-(void) stopRecording
{
    [audioRecorder stop];
}

#pragma mark Playback
-(void) setupAudioPlayback:(NSString *)path
{
    NSError *error;
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    recordingPath = [self recordingPath:path];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingPath error:&error];
    if (error || !audioPlayer) // if things are not initialised properly
    {
        @throw [NSException exceptionWithName:@"Preparing audio for playback" reason:@"Dammit" userInfo:nil];
    }
}

-(void) startPlayback
{
    if ([audioPlayer prepareToPlay]) {
        [audioPlayer play];
        assert([audioPlayer isPlaying]); // TODO: Take out?
    }
    else {
        @throw [NSException exceptionWithName:@"Audio player!" reason:@"Oh no!" userInfo:nil];
    }
}

-(void) stopPlayback
{
    [audioPlayer stop];
    assert(![audioPlayer isPlaying]);
}

#pragma mark Private
-(NSURL *)recordingPath:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    NSURL *documentFolderURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:Nil create:NO error:&error];
    if (error) @throw [NSException exceptionWithName:@"File Creation" reason:@"Failed to generate URL" userInfo:nil];
    
    return [documentFolderURL URLByAppendingPathComponent:path];
}

-(NSDictionary *)audioRecordingSettings {
    return @{
             AVFormatIDKey: @(kAudioFormatAppleLossless),
             AVSampleRateKey: @(44100.0f),
             AVNumberOfChannelsKey: @1,
             AVEncoderAudioQualityKey: @(AVAudioQualityLow)
             };
}

@end
