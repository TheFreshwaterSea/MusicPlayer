//
//  Music.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "Music.h"

@implementation Music
// 异常处理
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    NSLog(@"error key : %@",key);
}



@end
