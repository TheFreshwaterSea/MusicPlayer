//
//  PlayingViewController.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "Music.h"
#import "Lyric.h"
#import "lyricManager.h"
#import "JDStatusBarNotification.h"
// 3.遵循协议
@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDelegate,UITableViewDataSource>
// 记录一下当前播放的音乐的索引
@property(nonatomic,assign)NSInteger currentIndex;
// 记录当前播放的音乐
@property(nonatomic,strong)Music *currentModel;
// 暂停or播放
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;

// 控件
@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;
@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;
@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;

@property (strong, nonatomic) IBOutlet UISlider *slider4Time;// 持续播放时间
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;// 音量
// 
@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;

// 控件事件
// 上一首
- (IBAction)action4Prev:(UIButton *)sender;
// 播放or暂停
- (IBAction)action4PlayOrPause:(UIButton *)sender;
// 下一首
- (IBAction)action4Next:(UIButton *)sender;
// 时间变化
- (IBAction)action4ChangeTime:(UISlider *)sender;
// 音量
- (IBAction)action4ChangeVolume:(UISlider *)sender;



@end




static PlayingViewController *playingVC = nil;

static NSString *identifier = @"cellResue";

@implementation PlayingViewController

+(instancetype)sharePlayingVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main sb
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //在main sb 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
}

- (instancetype)init{
    if (self = [super init]) {
       //  [self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
        [self.btn4PlayOrPause setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
        
    }
    return self;
}

-(Music *)currentModel{
    
    // 取到要播放的model
    Music *music = [[DataManager sharedManager] musicWithIndex:self.currentIndex];
    
    return music;
    
}








-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 如果要播放的音乐和当前播放的音乐一样,就什么都不干
    if (_index == _currentIndex) {
        return;
    }else{
        // 如果不等于
        _currentIndex = _index;
    }
    
    
    
    
    [self startPlay];
    
}


-(void)startPlay{
    
    
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    
    [self buildUI];
}

-(void)buildUI{
    // _不走getter方法,但self走
    self.lab4SingerName.text = self.currentModel.singer;
    self.lab4SongName.text = self.currentModel.name;
    
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    // 更改btn
    
   
    // 改变进度条的最大值(用self)
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/1000; // 把毫秒换成秒
    // 进度条从起始位置开始
    self.slider4Time.value = 0;
    // 更改旋转角度,图片归位
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    // 解析歌词
    [[lyricManager sharedManager] loadLyricWith:self.currentModel.lyric];

    //刷新歌词
    [self.tableView4Lyric reloadData];
    
    
    
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentIndex = -1;
    // 4.设置自己为播放器的代理,帮播放器干一些事情
    [PlayerManager sharedManager].delegate = self;
    
    //    self.img4Pic.layer.masksToBounds = YES;
    //    self.img4Pic.layer.cornerRadius = 120;
    
    // 注册
    
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
    
    
    
}

#pragma mark - PlayerManagerDelegate
// 5.播放器播放结束了,开始播放下一首
-(void)playerDidPlayEnd{
    [self action4Next:nil];
    
    
}


// 三.播放器每0.1秒会让代理（也就是这个页面）执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
    // 时间slider的进度实时显示
    self.slider4Time.value=time;
    // 显示播放时间
    self.lab4PlayedTime.text=[self stringWithTime:time];
    // 计算剩余时间
    NSTimeInterval time2=[self.currentModel.duration intValue]/1000-time;
    // 显示剩余时间
    self.lab4LastTime.text=[self stringWithTime:time2];
    // 每0.1秒选择1度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI/180);
    // 根据当前播放时间获取到应该播放哪句歌词
    NSInteger index = [[lyricManager sharedManager] indexWith:time];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView选中我i们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }

// 根据时间获取字符串
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes=time/60;
    NSInteger seconds=(int)time%60;
    return [NSString stringWithFormat:@"%ld:%ld",minutes,seconds];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lyricManager sharedManager].allLyric.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // 取到对应的cell
    Lyric *lyric = [lyricManager sharedManager].allLyric[indexPath.row];
    cell.textLabel.text = lyric.lyricContext;
    
  //  cell.textLabel.text = @"歌词";
    // 居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    // 给正在显示歌词的行加个颜色
    UIView *aView = [[UIView alloc]initWithFrame:self.view.frame];
    aView.backgroundColor = [UIColor yellowColor];
    cell.selectedBackgroundView = aView;
    
    return cell;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    // 判断是否是第一首
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].allMusic.count-1;
    }
    [self startPlay];
    
    [JDStatusBarNotification showWithStatus:self.currentModel.name dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];

    
}
// 暂停或播放事件
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放,就让播放器暂停,同时改变button的text
        [[PlayerManager sharedManager] pause];
        
     //   [sender setTitle:@"播放" forState:UIControlStateNormal];
        
        [sender setImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
        
    }else{
        //暂停状态:开始播放,并改变btn 为 暂停
        [[PlayerManager sharedManager] play];
       // [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
        [sender setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
    }
    
    
    
    
}
// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    // 随机播放
    int random;
    random = arc4random()%[DataManager sharedManager].allMusic.count;
    
    _currentIndex = random;
    
    
    // 在播放下一首时,先暂停,销毁timer
    [[PlayerManager sharedManager] pause];
    
  //  _currentIndex++;
    //判断是不是最后一首
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        // 最后一首
        _currentIndex = 0;
        
        
    }
    [self startPlay];
    
  //  [JDStatusBarNotification showWithStatus:@"下一首" styleName:nil];
    
    [JDStatusBarNotification showWithStatus:self.currentModel.name dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];

    
}
// 改变播放速度
- (IBAction)action4ChangeTime:(UISlider *)sender {
    
    UISlider *slider = sender;
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
    
    
    
    
    
}
// 改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    
    [[PlayerManager sharedManager] changerToVolume:sender.value];
    
    
    
}
@end
