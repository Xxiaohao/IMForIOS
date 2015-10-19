//
//  XHTestViewController.m
//  IMForIOS
//
//  Created by LC on 15/10/15.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHTestViewController.h"

@interface XHTestViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imageVIew;

@end

@implementation XHTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageVIew.contentSize = CGSizeMake(300, 300);
    self.imageVIew.contentOffset=CGPointMake(0, -60);
    XHLog(@"哈哈哈");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
