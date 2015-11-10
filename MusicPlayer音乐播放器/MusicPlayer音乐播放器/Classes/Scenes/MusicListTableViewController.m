//
//  MusicListTableViewController.m
//  MusicPlayer音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListTableViewCell.h"
#import "DataManager.h"
#import "Music.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"
// #import "UIImageView+WebCache.h"

@interface MusicListTableViewController ()

@end

//static NSString *identifier = @"cellResue";
static NSString *cusIdentifier = @"cellCustom";
@implementation MusicListTableViewController
//代码规范,每一个模块之间空一行
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:cusIdentifier];
    
    [DataManager sharedManager].myUpdataUI = ^(){
        [self.tableView reloadData];
    };
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [DataManager sharedManager].allMusic.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cusIdentifier forIndexPath:indexPath];
    
 //   Music *musi = [DataManager sharedManager].allMusic[indexPath.row];
  
    Music *musi = [[DataManager sharedManager] musicWithIndex:indexPath.row];
    
    cell.music = musi;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:musi.picUrl] placeholderImage:nil];
    
    
  //  cell.textLabel.text = @"1";
    // 防止模糊不清
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MusicListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    NSLog(@"%@",cell.music);
//    // 播放音乐
//    [[PlayerManager sharedManager] playWithUrlString:cell.music.mp3Url];
    
    // 拿到模态出来的控制器
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    // 属性传值
    playingVC.index = indexPath.row;
    
    [self showDetailViewController:playingVC sender:nil];
    
    
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
