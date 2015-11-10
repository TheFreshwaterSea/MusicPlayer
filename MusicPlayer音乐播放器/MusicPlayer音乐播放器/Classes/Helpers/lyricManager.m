//
//  lyricManager.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "lyricManager.h"
#import "Lyric.h"

@interface lyricManager ()

// 用来存放歌词
@property(nonatomic,strong)NSMutableArray *lyrics;


@end


static lyricManager *manager = nil;
@implementation lyricManager


+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [lyricManager new];
    });
    
    return manager;
}

-(void)loadLyricWith:(NSString *)lyricStr{
    
    // 要先将之前歌曲的歌词移除
    [self.lyrics removeAllObjects];
    
    if ([lyricStr isEqualToString:@""]) {
        Lyric *model  = [[Lyric alloc] initWithTime:0 lyric:@"无歌词"];
        
        [self.lyrics addObject:model];
        return;
        
    }
    
    
    
    // 1.分行
    NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    //  最后一行是 @""
    // 所以需要将最后一行移除
    [lyricStringArray removeLastObject];
    
    
    
    
    for (NSString *str in lyricStringArray) {
//        
//        if ([str isEqualToString:@""]) {
//            continue;
//        }
        
        
        NSLog(@"%@",str);
    
        
// [00:00.00] 作曲 : Wiz Khalifa[00:01.00] 作词 : Wiz Khalifa[00:10.440]It's been a long day without you my friend
        
        
        
    // 2.分开时间和歌词
        NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
        if (timeAndLyric.count != 2) {
            continue;
        }
    
    // 3.去掉时间左边的"["
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
    // 4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        
        // 分/Users/lanou3g/Downloads/Resources
        NSInteger minute = [minuteAndSecond[0] integerValue];
        
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
    // 5.装成一个model
        Lyric *model = [[Lyric alloc] initWithTime:(minute * 60 +second) lyric:timeAndLyric[1]];
        // 6.添加到数组中
        [self.lyrics addObject:model];
        
    }
    
}
// 让时间与歌词同步的方法
-(NSInteger)indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
    // 遍历数组,找到还没有播放的那一句歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        Lyric *model = self.lyrics[i];
        if (model.time > time) {
            // 注意如果是第0个元素,而且元素时间比要播放的时间打,i-1就会小于0,这样tableView就会crash
         index = (i - 1 >0)?i -1 : 0;
            // 一定要break,要不就会一直循环下去
            break;
            
        }
        
    }
    return index;
}



// 懒加载

-(NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}

// 把私有属性给公有属性
-(NSArray *)allLyric{
    return self.lyrics;
}















@end
