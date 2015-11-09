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
    
    self.contactViewController = [[XHContactViewController alloc]init];
    [self addChildVC:self.contactViewController title:@"联系人" image:@"tabbar_profile" selectImage:@"tabbar_profile_selected"];
     [self.contactViewController addContactTable];
    
    self.myselfViewController = [[XHMyselfViewController alloc]init];
    [self addChildVC:self.myselfViewController title:@"我" image:@"tabbar_home" selectImage:@"tabbar_home_selected"];
//    XHLog(@"---tabbar frame is %@----",NSStringFromCGRect( self.tabBar.frame));
}

-(void)setContacts:(NSArray *)contacts{
    XHLog(@" set _contacts ---------------");
    _contacts = contacts;
    self.contactViewController.contacts = self.contacts;
    self.messageViewController.contacts = self.contacts;
}

-(void)setGroupInfos:(NSArray *)groupInfos{
    XHLog(@" set _contacts ---------------");
    _groupInfos = groupInfos;
    self.contactViewController.groupInfos = self.groupInfos;
}

/**tab控制器增加子控制器 */
-(void)addChildVC:(UIViewController *)target title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    target.title = title;
    target.tabBarItem.image = [UIImage imageNamed:image];
    target.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    target.view.backgroundColor = XHRandomColor;
    
    // 设置文字的样式
    NSMutableDictionary *fontColor = [NSMutableDictionary dictionary];
    fontColor[NSForegroundColorAttributeName] = XHColor(133, 133, 133);
    [target.tabBarItem setTitleTextAttributes:fontColor forState:UIControlStateNormal];
    
    NSMutableDictionary *fontColorSelect = [NSMutableDictionary dictionary];
    fontColorSelect[NSForegroundColorAttributeName]= [UIColor orangeColor];
    [target.tabBarItem setTitleTextAttributes:fontColorSelect forState:UIControlStateSelected];
    
    XHNavigationViewController *navigationViewController =[[XHNavigationViewController alloc] initWithRootViewController:target];
//    XHLog(@"navigationbar frame is %@" ,NSStringFromCGRect(navigationViewController.navigationBar.frame));
    [self addChildViewController:navigationViewController];
//    [self.contactViewController addContactTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
