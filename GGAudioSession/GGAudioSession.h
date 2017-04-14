//
//  GGAudioSession.h
//  GGAudioSession
//
//  Created by gxy on 2017/4/13.
//  Copyright © 2017年 GaoXinYuan. All rights reserved.
//
//  在plist文件中添加Required background modes，并且设置item 0 = App plays audio or streams audio/video using AirPlay（其实可以直接通过Xcode在Project Targets-Capabilities-Background Modes中设置）
//
//
//

#import <Foundation/Foundation.h>

typedef void(^GGAudioSessionHeadPhoneOut)();

typedef void(^GGAudioSessionInterrupt)();

@interface GGAudioSession : NSObject

+ (GGAudioSession*)share;

@property (copy, nonatomic) GGAudioSessionHeadPhoneOut headPhoneOut;

@property (copy, nonatomic) GGAudioSessionInterrupt afterInterrupt;

@property (copy, nonatomic) GGAudioSessionInterrupt beforeInterrupt;

@property (assign, readonly, nonatomic) BOOL isActived;

- (void)inactiveAudioSession;

- (void)activeAudioSession;

@end
