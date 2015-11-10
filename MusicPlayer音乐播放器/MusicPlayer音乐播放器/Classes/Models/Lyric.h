//
//  Lyric.h
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lyric : NSObject

// 歌词播放时间
@property(nonatomic,assign)NSTimeInterval time;
// 歌词内容
@property(nonatomic,retain)NSString *lyricContext;

-(instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric;


@end
