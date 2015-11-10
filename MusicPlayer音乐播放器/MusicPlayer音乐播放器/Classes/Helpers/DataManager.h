//
//  DataManager.h
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"

typedef void (^UpdataUI)();

@interface DataManager : NSObject
@property(nonatomic,strong)NSArray *allMusic;
@property(nonatomic,copy)UpdataUI myUpdataUI;

// 单例方法

+(DataManager *)sharedManager;

// 根据cell的索引返回一个model
-(Music *)musicWithIndex:(NSInteger)index;

@end
