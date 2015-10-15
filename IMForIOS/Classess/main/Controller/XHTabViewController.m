//
//  XHTabViewController.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHTabViewController.h"
#import "XHContactViewController.h"
#import "XHNavigationViewController.h"
#import "XHMessageViewController.h"
#import "XHMyselfViewController.h"

@interface XHTabViewController ()
@property (nonatomic,strong)XHMessageViewController *messageViewController;
@property (nonatomic,strong)XHContactViewController *contactViewController;
@property (nonatomic,strong)XHMyselfViewController *myselfViewController;

@end

@implementation XHTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageViewController = [[XHMessageViewController alloc]init];
    [self addChildVC:self.messageViewController title:@"消息" image:@"tabbar_message_center" selectImage:@"tabbar_message_center_selected"];
    
//    self.messageViewController = messageViewController;
    self.contactViewController = [[XHContactViewController alloc]init];
    [self addChildVC:self.contactViewController title:@"联系人" image:@"tabbar_profile" selectImage:@"tabbar_profile_selected"];
    
    
//    self.contactViewController = contactViewController;
    self.myselfViewController = [[XHMyselfViewController alloc]init];
    [self addChildVC:self.myselfViewController title:@"我" image:@"tabbar_home" selectImage:@"tabbar_home_selected"];
//    self.myselfViewController = myselfViewController;
}

-(void)setContacts:(NSArray *)contacts{
    XHLog(@"----tabView---");
    _contacts = contacts;
    self.contactViewController.contacts = self.contacts;
}

-(void)setGroupInfos:(NSArray *)groupInfos{
    XHLog(@"---groupInfos---");
    _groupInfos = groupInfos;
    self.contactViewController.groupInfos = self.groupInfos;
}


-(void)addChildVC:(UIViewController *)target title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    target.title = title;
    target.tabBarItem.image = [UIImage imageNamed:image];
    target.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    target.view.backgroundColor = XHRandomColor;
    
    // 设置文字的样式
    NSMutableDictionary *fontColor = [NSMutableDictionary dictionary];
    fontColor[NSForegroundColorAttributeName] = XHColor(133, 133, 133);
    [target.tabBarItem setTitleTextAttributes:fontColor forState:UIControlStateNormal];
    
    NSMutableDictionary *fontColorSelect = [NSMutableDictionary dictionary];
    fontColorSelect[NSForegroundColorAttributeName]= [UIColor orangeColor];
    [target.tabBarItem setTitleTextAttributes:fontColorSelect forState:UIControlStateSelected];
    
//    target.navigationController.navigationBar
    
    
    XHNavigationViewController *navigationViewController =[[XHNavigationViewController alloc] initWithRootViewController:target];
    [self addChildViewController:navigationViewController];
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
