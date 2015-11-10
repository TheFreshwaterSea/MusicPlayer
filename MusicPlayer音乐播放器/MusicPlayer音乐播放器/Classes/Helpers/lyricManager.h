//
//  lyricManager.h
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lyricManager : NSObject
// 对外的歌词数组
@property(nonatomic,retain)NSArray *allLyric;


+(instancetype)sharedManager;

-(void)loadLyricWith:(NSString *)lyricStr;// 加载歌词

// 根据播放时间获取到该播放的歌词索引
-(NSInteger)indexWith:(NSTimeInterval)time;

@end
