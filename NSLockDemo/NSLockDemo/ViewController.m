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
    for (int i = 0; i < 100; i++) {
        NSLog(@"%.0f", self.tableView.contentSize.height);
        NSLog(@"%@", NSStringFromCGPoint(self.tableView.contentOffset));
        dispatch_async(dispatch_queue_create("a", DISPATCH_QUEUE_CONCURRENT), ^{
            NSLog(@"%@",[NSThread currentThread]);
            NSMutableArray *arrM_new = [NSMutableArray arrayWithArray:self.arrM];
            [arrM_new addObject:@"1"];
            if (arrM_new.count > 30) {
                [arrM_new removeObjectsInRange:NSMakeRange(0, 29)];
            }
            self.arrM = arrM_new;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSLog(@"%.0f", self.tableView.contentSize.height);
                CGPoint offset = CGPointMake(0,self.tableView.contentSize.height - self.tableView.frame.size.height);
                if (offset.y < 0) {
                    offset = CGPointMake(0, -44);
                }
                [self.tableView setContentOffset:offset animated:NO];
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
