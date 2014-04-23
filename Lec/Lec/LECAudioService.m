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
    void (^playbackFinished)(void);
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
    [session setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
    
    recordingPath = [self recordingPath:path];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordingPath settings:[self audioRecordingSettings] error:&error];
    if (error) {
        @throw [NSException exceptionWithName:@"Audio Recording failed" reason:@"Dammit" userInfo:nil];
    }
    
    audioRecorder.delegate = self;
    
    if (![audioRecorder prepareToRecord])
    {
        @throw [NSException exceptionWithName:@"AudioPlayerNotReady" reason:@"Not sure" userInfo:nil];
    }
}

-(void) startRecording
{
    if (![audioRecorder record])
    {
        @throw [NSException exceptionWithName:@"Recording failed to start" reason:@"Reason? Don't know" userInfo:nil];
    }
}

-(void) stopRecording
{
    [audioRecorder stop];
}

#pragma mark Playback
-(void) setupAudioPlayback:(NSString *)path withCompletion:(void (^)(void))block
{
    NSError *error;
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    recordingPath = [self recordingPath:path];
    NSLog(@"File path %@", recordingPath);
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingPath error:&error];
    audioPlayer.delegate = self;
    playbackFinished = block;
    if (error || !audioPlayer) // if things are not initialised properly
    {
        @throw [NSException exceptionWithName:@"Preparing audio for playback" reason:@"Dammit" userInfo:nil];
    }
}

-(void) startPlayback
{
    [session setActive:YES error:nil];
    if ([audioPlayer prepareToPlay]) {
        [audioPlayer play];
        assert([audioPlayer isPlaying]); // TODO: Take out? Once at a production stage
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

#pragma mark Tag Stuff
-(void)goToTime:(NSNumber *)time
{
    if (!audioPlayer.playing) [audioPlayer play];
    audioPlayer.currentTime = [time doubleValue];
}

-(NSNumber *) getCurrentTime
{
    if (audioPlayer && [audioPlayer isPlaying])
    {
        return [NSNumber numberWithDouble:[audioPlayer currentTime]];
    } else if (audioRecorder && [audioRecorder isRecording]) {
        return [NSNumber numberWithDouble:[audioRecorder currentTime]];
    }
    @throw [NSException exceptionWithName:@"WhatTheFuckException" reason:@"Nothing is playing or recording" userInfo:nil];
}

#pragma mark - Protocol
#pragma mark - Playback
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    playbackFinished();
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
             AVFormatIDKey: @(kAudioFormatMPEG4AAC),
             AVSampleRateKey: @(44100.0f),
             AVNumberOfChannelsKey: @1,
             AVEncoderAudioQualityKey: @(AVAudioQualityLow)
             };
}

@end
