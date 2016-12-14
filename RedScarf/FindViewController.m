//
//  FindViewController.m
//  RedScarf
//
//  Created by CPZX008 on 16/11/23.
//  Copyright © 2016年 xboker. All rights reserved.
//

#import "FindViewController.h"
#import "MJRefresh.h"

#import "CustomRefreshGifHeader.h"
#import "MyViewController.h"



#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGTH   [UIScreen mainScreen].bounds.size.height




@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger refreshTime;

@property (nonatomic, assign) NSInteger touchCount;


@end

@implementation FindViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    __weak FindViewController *weakSelf = self;
    CustomRefreshGifHeader *header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    NSArray *imageArr = @[[UIImage imageNamed:@"refresh1"], [UIImage imageNamed:@"refresh2"], [UIImage imageNamed:@"refresh3"], [UIImage imageNamed:@"refresh4"]];
    [header setImages:imageArr duration:0.5 forState:MJRefreshStateIdle];
    [header setImages:imageArr duration:0.5 forState:MJRefreshStatePulling];
    [header setImages:imageArr duration:0.5 forState:MJRefreshStateRefreshing];
    [header setImages:imageArr duration:0.5 forState:MJRefreshStateWillRefresh];
    self.tableView.mj_header = header;
    self.tabBarController.delegate = self;
    self.touchCount = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"test";
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tabBarController.selectedIndex = 1;
    MyViewController *myC = ((UINavigationController *)self.tabBarController.viewControllers.lastObject).viewControllers.firstObject;
    
    NSLog(@"%@+++++", ((UINavigationController *)self.tabBarController.viewControllers.lastObject).viewControllers.firstObject);
    
    UIView *cutView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    [myC.view addSubview:cutView];
    cutView.frame = CGRectMake(0, -64, WIDTH, HEIGTH);
    
    [UIView animateWithDuration:0.3 animations:^{
        cutView.frame = CGRectMake(0, -94, WIDTH + 30, HEIGTH + 30);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.9 animations:^{
            cutView.frame = CGRectMake(100, HEIGTH - 22, 5, 5);
            cutView.alpha = 0.4;
        } completion:^(BOOL finished) {
            [cutView removeFromSuperview];
        }];
    }];
    
}



#pragma mark    UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    __weak FindViewController *weakSelf = self;
    if (tabBarController.selectedIndex == 0) {
        self.touchCount ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.touchCount = 1;
        });
        if (self.touchCount > 2 ) {
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.touchCount = 1;
                [weakSelf.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
                weakSelf.tableView.mj_header.pullingPercent = 1;
            } completion:^(BOOL finished) {
                weakSelf.tableView.mj_header.state = MJRefreshStateRefreshing;
            }];
        }
    }
    return YES;
}






/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
