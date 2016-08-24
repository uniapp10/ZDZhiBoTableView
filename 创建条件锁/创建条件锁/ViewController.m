//
//  ViewController.m
//  创建条件锁
//
//  Created by zhudong on 16/8/24.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *arrM;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrM = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(itemClick)];
}
- (void)itemClick{
    //创建互斥锁
    NSLock *lock = [[NSLock alloc] init];
    for (int i = 0; i < 100; i++) {
        dispatch_async(dispatch_queue_create("a", DISPATCH_QUEUE_CONCURRENT), ^{
            NSLog(@"%@",[NSThread currentThread]);
            //互斥锁锁定
            [lock lock];
                [self.arrM addObject:@"1"];
                if (self.arrM.count > 30) {
                    [self.arrM removeObjectsInRange:NSMakeRange(0, 29)];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [self.tableView reloadData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.arrM.count - 1) inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    //互斥锁打开
                    [lock unlock];
                });
        });
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrM.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd组%zd行",indexPath.section,indexPath.row];
    return cell;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
