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

@interface XHContactViewController ()
@property (nonatomic,strong)XHContactTableController *contactTableController;
@property (nonatomic,strong)XHGroupTableController *groupTableController;
@property (nonatomic,assign)UIViewController *selectViewController;
@property (nonatomic,assign)NSInteger selectIndex;
@end

@implementation XHContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
    [segmentedControl setTitle:@"联系人" forSegmentAtIndex:0];
    [segmentedControl setTitle:@"讨论组" forSegmentAtIndex:1];
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
//    XHLog(@"------contactView load--navigationItem is %@---",self.navigationItem);
    //     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:self action:@selector(setting)];
//    [self addContactTable];
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    [self transitionFromViewController:self.childViewControllers[index] toViewController:self.childViewControllers[self.selectIndex] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        self.selectViewController=self.childViewControllers[index];
        _selectIndex = index;
    }];
//    switch (index) {
//        case 0:
//        {
//            [self transitionFromViewController:self.childViewControllers[self.selectIndex] toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//                self.selectViewController=self.childViewControllers[index];
//                self.selectIndex = index;
//            }];
//            XHLog(@"00000--%@",self.selectViewController);
//        }
//            break;
//        case 1:
//        {
//            self.selectIndex = index;
//            XHLog(@"11111--%@",self.selectViewController);
//        }
//            break;
//    }
}

//-(void)setSelectIndex:(NSInteger)index{
//    [self transitionFromViewController:self.childViewControllers[self.selectIndex] toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//        self.selectViewController=self.childViewControllers[index];
//        _selectIndex = index;
//    }];
//}

-(void)addContactTable{
//    NSLog(@"----height--is %@--",self.navigationController.navigationBar);
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGRect subViewFrame = CGRectMake(0, navigationBarFrame.size.height+20, navigationBarFrame.size.width, tabBarFrame.origin.y-navigationBarFrame.size.height-20);
    
    self.groupTableController  = [[XHGroupTableController alloc]init];
    self.groupTableController.view.frame = subViewFrame;
    [self.view addSubview:self.groupTableController.view];
    [self addChildViewController:self.groupTableController];
    
    self.contactTableController  = [[XHContactTableController alloc]init];
    self.contactTableController.view.frame = subViewFrame;
    [self.view addSubview:self.contactTableController.view];
    [self addChildViewController:self.contactTableController];
    
//    XHLog(@"---contact-frame--%@--navigatvebar fram is %@-",NSStringFromCGRect(self.navigationController.navigationBar.frame),NSStringFromCGRect(self.tabBarController.tabBar.frame));
    
    self.selectIndex = 1;
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
//    XHLog(@"---contact--");
}

-(void)setGroupInfos:(NSArray *)groupInfos{
    _groupInfos = groupInfos;
    self.groupTableController.groupInfos = groupInfos;
//    XHLog(@"---group--");
}


-(void)addContacts{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
