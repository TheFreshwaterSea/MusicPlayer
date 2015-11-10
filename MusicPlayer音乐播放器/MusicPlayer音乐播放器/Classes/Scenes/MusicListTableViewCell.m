//
//  MusicListTableViewCell.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setMusic:(Music *)music{
    
    _music = music;
    
    _musicLable.text= music.name;
    _singerLable.text = music.singer;
    
}






@end
