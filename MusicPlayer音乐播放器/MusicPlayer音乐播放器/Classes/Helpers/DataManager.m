//
//  DataManager.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "DataManager.h"
#import "Music.h"

@interface DataManager ()

@property(nonatomic,strong)NSMutableArray *musicArray;
@end


@implementation DataManager
// command+control+上/下  切换.h/.m
static DataManager *manager = nil;
+(DataManager *)sharedManager{
    // gcd提供的一种单例方法
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager requestData];
    });
    
    
    return manager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self requestData];
    }
    return self;
}



-(void)requestData{
    // 在子线程中请求数据,防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 数据连接
        NSURL *url = [NSURL URLWithString:kMusicListURL];
        // 请求数据
        
        NSArray *dataArray = [NSArray arrayWithContentsOfURL:url];
        
        for (int i = 0; i < dataArray.count; i++) {
            NSLog(@"%@",dataArray[i]);
            // 构建model
            
       //     self.musicArray = [NSMutableArray array];  zhe一步可以用下面懒加载替换
            Music *model =[Music new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [self.musicArray addObject:model];
        }
        // 返回主线程更新UI
       dispatch_async(dispatch_get_main_queue(), ^{
           if (!self.myUpdataUI) {
               NSLog(@"block 没有代码");
           }else{
             //  [self.tableView reloadData];
               self.myUpdataUI();
           }
       });
        
        
        
    });
    
    
}

#pragma mark --lazy load
-(NSMutableArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}



-(NSArray *)allMusic{
    return self.musicArray;

}

-(Music *)musicWithIndex:(NSInteger)index{
    
    return self.allMusic[index];
}




@end
