//
//  YXLDetail.m
//  IMForIOS
//
//  Created by 小侠 on 15-10-29.
//  Copyright © 2015年 XH. All rights reserved.
//

#import "YXLDetail.h"
#import "XHMessageListController.h"

@interface YXLDetail ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbluserName;
@property (weak, nonatomic) IBOutlet UILabel *lbluserTxt;
@property (weak, nonatomic) IBOutlet UILabel *lbluserSignature;
@property (weak, nonatomic) IBOutlet UILabel *lbluserUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbluserDuty;
@property (weak, nonatomic) IBOutlet UILabel *lbluserID;
@property (weak, nonatomic) IBOutlet UIButton *lblButton;
- (IBAction)buttonClick;

@end

@implementation YXLDetail

singleton_implementation(YXLDetail)

-(void)setContactModel:(XHContactModel *)contactModel{
//    XHLog(@"--------XHContactModel------%d",self.view == nil);
    _contactModel=contactModel;
    [self setValueForSub];
}

-(void)setValueForSub{
    self.lbluserID.text = _contactModel.userID;
    self.lbluserName.text = _contactModel.userName;
    NSString *sex = nil;
    if (_contactModel.userSex == 0) {
        sex = @"女";
        
    }else{
        sex = @"男";
    }
    self.lbluserTxt.text = [NSString stringWithFormat:@"%@   %d岁",sex,_contactModel.userAge ];
    self.lbluserSignature.text = _contactModel.userSignature;
    self.lbluserUnit.text = _contactModel.userUnit;
    self.lbluserDuty.text = _contactModel.userDuty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    XHLog(@"-------yxldetail------");
    [self setValueForSub];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
//    if (_contactModel!=nil) {
//        self.lbluserID.text = self.contactModel.userID;
//        self.lbluserName.text = self.contactModel.userName;
//        NSString *sex = nil;
//        if (self.contactModel.userSex == 0) {
//            
//            sex = @"女";
//            
//        }else{
//            sex = @"男";
//        }
//        self.lbluserTxt.text = [NSString stringWithFormat:@"%@   %d岁",sex,self.contactModel.userAge ];
//        self.lbluserSignature.text = self.contactModel.userSignature;
//        self.lbluserUnit.text = self.contactModel.userUnit;
//        self.lbluserDuty.text = self.contactModel.userDuty;
//    }
}

-(void)setButtonWithNSString:(NSString *)string{
//    if ([string isEqualToString:@"发送消息"]) {
//        XHLog(@"111111111111111111");
//        
//        [self.lblButton setTitle:@"发送消息" forState:UIControlStateNormal];
//        [self.lblButton setTitle:@"发送消息" forState:UIControlStateHighlighted];
////        [self.lblButton addTarget:self.lblButton action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//        [self.lblButton addTarget:self.lblButton action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//        XHLog(@"22222222222");
//    }else if([string isEqualToString:@"加好友"]){
//        
//    }
}

- (IBAction)buttonClick {
    [self sendMessage];
}

-(void)sendMessage{
    XHLog(@"_+++++++");
    [self.detailDelegate pushToMessageListViewControllerWithContact:self.contactModel];
    XHLog(@"----");
    [self.navigationController pushViewController:[XHMessageListController sharedXHMessageListController] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
