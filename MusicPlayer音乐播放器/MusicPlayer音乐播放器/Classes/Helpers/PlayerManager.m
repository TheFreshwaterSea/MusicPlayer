//
//  PlayerManager.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayerManager ()
//播放器->全局唯一,因为如果有两个avplayer的话,就会同时播放两个音乐
@property(nonatomic,retain)AVPlayer *player;
// 计时器
@property(nonatomic,retain)NSTimer *timer;



@end

@implementation PlayerManager
static PlayerManager *manager = nil;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加通知中心,当self发出AVPlayerItemDidPlayToEndTimeNotification时触发playerDidPlayerEnd事件
        //自动播放下一首
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
-(void)playerDidPlayEnd:(NSNotificationCenter *)not{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 6.接收到item播放结束后,让代理去干一件事情,代理会怎么干,播放器不需要知道
        [self.delegate playerDidPlayEnd];
    }
}


// 对外方法
-(void)playWithUrlString:(NSString *)urlStr{
    // 如果是切换歌曲,要先把正在播放的观察移除掉
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    // 对item添加观察
    // 观察item的状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    // 替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    
//    //开始播放
//    [self.player play];

    
}
// 播放
-(void)play{
    // 如果正在播放的话,就不播放了,直接返回就行了
    if (_isPlaying) {
        return;
    }
    
    [self.player play];
    // 开始播放后标记一下
    _isPlaying = YES;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    
}

-(void)playingWithSeconds{
    NSLog(@"%lld",self.player.currentTime.value / self.player.currentTime.timescale);
    // 二.计算一下播放器现在播放的秒数
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
        
        [self.delegate playerPlayingWithTime:time];
    }
    
    
}


// 暂停
-(void)pause{
    [self.player pause];
    //暂停播放后设为NO
    _isPlaying = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
    
}

// time : 50秒
-(void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    
   [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
       
       if (finished) {
           // 拖拽成功后再播放
           [self play];
       }
       
   }];
    
    
}

// 音量
-(void)changerToVolume:(CGFloat)volume{
    
    self.player.volume = volume;
}

// 用来访问avplayer的音量
-(CGFloat)volume{
    
    return self.player.volume;
}


// 懒加载

-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

// 观察响应
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    AVPlayerStatus status = [change[@"new"] integerValue];
    
    switch (status) {
        case AVPlayerStatusFailed:
            NSLog(@"加载失败");
            break;
            case AVPlayerStatusUnknown:
            NSLog(@"资源不对");
            break;
            case AVPlayerStatusReadyToPlay:
            NSLog(@"准备完毕,可以播放了");
            //开始播放
            // 先暂停,将nstimer销毁,然后再播放,创建NSTimer
            [self pause];
            [self play];
            break;
            
        default:
            break;
    }
    
    
}





@end
