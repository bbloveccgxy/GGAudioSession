//
//  GGAudioSession.m
//  GGAudioSession
//
//  Created by gxy on 2017/4/13.
//  Copyright © 2017年 GaoXinYuan. All rights reserved.
//

#import "GGAudioSession.h"
#import <AVFoundation/AVAudioSession.h>
#import <UIKit/UIKit.h>

static GGAudioSession *session = nil;

@interface GGAudioSession ()

@property (strong, nonatomic) AVAudioSession *audioSession;

@end

@implementation GGAudioSession

+ (GGAudioSession *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[super allocWithZone:NULL] init];
        session.audioSession = [AVAudioSession sharedInstance];
        [session.audioSession setActive:YES error:nil];
        [session.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter] addObserver:session selector:@selector(receiveHeadPhoneOut:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:session selector:@selector(receiveInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    });
    return session;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return  [GGAudioSession share];
}

- (id)copy {
    return [GGAudioSession share];
}

- (id)mutableCopy {
    return [GGAudioSession share];
}

- (void)receiveHeadPhoneOut:(NSNotification*)noti {
    
    AVAudioSessionRouteChangeReason reason = [noti.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = noti.userInfo[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            self.headPhoneOut();
        }
    }
}

- (void)receiveInterrupt:(NSNotification*)noti {
    AVAudioSessionInterruptionType type = [noti.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (self.beforeInterrupt != nil) {
            self.beforeInterrupt();
        }
    } else {
        if (self.afterInterrupt != nil) {
            self.afterInterrupt();
        }
    }
    
}

@end
