//
//  XHContactViewController.m
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactViewController.h"
#import "XHContactTableController.h"
#import "XHContactTableViewCell.h"
#import "XHContactModel.h"
#import "XHGroupTableController.h"
#import "XHAsyncSocketClient.h"
#import "XHAddContactController.h"


@interface XHContactViewController ()
@property (nonatomic,strong)XHContactTableController *contactTableController;
@property (nonatomic,strong)XHGroupTableController *groupTableController;
@property (nonatomic,strong)UIViewController *selectViewController;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)XHAddContactController *addContactController;
@end

@implementation XHContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addContactTable];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    //segmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
    [segmentedControl setTitle:@"联系人" forSegmentAtIndex:0];
    [segmentedControl setTitle:@"讨论组" forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex=0;
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
}

/**切换子控制器 */
-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    [self transitionFromViewController:self.childViewControllers[index] toViewController:self.childViewControllers[self.selectIndex] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        self.selectViewController=self.childViewControllers[index];
        _selectIndex = index;
        
        XHLog(@"frame is %@ ",NSStringFromCGRect(self.selectViewController.view.frame));
    }];
}

/** 增加子控制器*/
-(void)addContactTable{
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGRect subViewFrame = CGRectMake(0, navigationBarFrame.size.height+20, navigationBarFrame.size.width, tabBarFrame.origin.y-navigationBarFrame.size.height-20);
    
    self.groupTableController  = [[XHGroupTableController alloc]init];
    self.groupTableController.view.frame = subViewFrame;
    [self.view addSubview:self.groupTableController.view];
    [self addChildViewController:self.groupTableController];
    
    self.contactTableController  = [[XHContactTableController alloc]init];
    self.contactTableController.view.frame = self.groupTableController.view.frame;
    [self.view addSubview:self.contactTableController.view];
    [self addChildViewController:self.contactTableController];
    
    self.selectIndex = 0;
    self.selectViewController = self.contactTableController;
//    self.contactTableController.view.translatesAutoresizingMaskIntoConstraints=NO;
//    NSLayoutConstraint *topCon_contact = [NSLayoutConstraint constraintWithItem:self.contactTableController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//    NSLayoutConstraint *bottomCon_contact = [NSLayoutConstraint constraintWithItem:self.contactTableController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    NSLayoutConstraint *leftCon_contact = [NSLayoutConstraint constraintWithItem:self.contactTableController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
//    NSLayoutConstraint *rightCon_contact = [NSLayoutConstraint constraintWithItem:self.contactTableController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    //    self.contactTableController.contacts = self.contacts;
    
//    [self.view addConstraints:@[topCon_contact,bottomCon_contact,leftCon_contact,rightCon_contact]];
}

-(void)setContacts:(NSArray *)contacts{
    _contacts = contacts;
    self.contactTableController.contacts = self.contacts;
}

-(void)setGroupInfos:(NSArray *)groupInfos{
    _groupInfos = groupInfos;
    self.groupTableController.groupInfos = groupInfos;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addContacts{
    self.addContactController = [[XHAddContactController alloc]init];
//
    _addContactController.title = @"添加";
//
//    self.addContactController.contacts = self.contacts;
    [self.navigationController pushViewController:self.addContactController animated:YES];
//    XHLog(@"---contactView-addContacts--");
}






@end
