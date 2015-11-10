//
//  MusicListTableViewCell.h
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"

@interface MusicListTableViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *musicLable;
@property (strong, nonatomic) IBOutlet UILabel *singerLable;



@property(nonatomic,retain)Music *music;

@end
