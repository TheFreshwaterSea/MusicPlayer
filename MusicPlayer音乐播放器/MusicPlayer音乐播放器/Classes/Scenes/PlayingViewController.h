//
//  PlayingViewController.h
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController
// 要播放第几首歌曲
@property(nonatomic,assign)NSInteger index;



// 创建一个一直存在的界面
+(instancetype)sharePlayingVC;

@end
