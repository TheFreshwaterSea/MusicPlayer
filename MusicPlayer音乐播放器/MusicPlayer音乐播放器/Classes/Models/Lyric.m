//
//  Lyric.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "Lyric.h"

@implementation Lyric

-(instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric{
    
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
    
}




@end
