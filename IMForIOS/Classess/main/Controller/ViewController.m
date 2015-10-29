//
//  ViewController.m
//  IMForIOS
//
//  Created by LC on 15/9/11.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "ViewController.h"
#import "XHTabViewController.h"
#import "XHAsyncSocketClient.h"
#import "XHUserInfo.h"
#import "FMDB.h"


@interface ViewController ()<UITextFieldDelegate,SessionServerDelegate>{
    XHUserInfo *userInfo;
}
@property (weak, nonatomic) IBOutlet UITextField *pw_word;
@property (weak, nonatomic) IBOutlet UITextField *user_field;
@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (nonatomic,strong) XHTabViewController *tabViewController;


#pragma mark block
@property (nonatomic,copy) void (^loginAction)(NSString *username,NSString *password);


- (IBAction)loginClick;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [XHUserInfo sharedXHUserInfo];
    NSLog(@"viewController1 load");
    [XHAsyncSocketClient sharedXHAsyncSocketClient].sessionServerDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [userInfo loadUserInfoFromSanbox];
    self.user_field.text = userInfo.userID;
    self.pw_word.text = userInfo.passWord;
    
 
}



-(void)kbFrameWillChange:(NSNotification *)noti{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 点击登录
- (IBAction)loginClick {
    NSString *user = self.user_field.text;
    NSString *pw = self.pw_word.text;
    
    [[XHAsyncSocketClient sharedXHAsyncSocketClient] loginWithUserName:(NSString *)user andUserPW:(NSString *)pw andBlock:^(int result,NSDictionary *dict) {
        [self handleResult:result AndContentDict:dict];
    }];
    userInfo.userID = user;
    userInfo.passWord = pw;
}

-(void)handleResult:(int)result AndContentDict:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (result) {
            case LOGIN_SECCUSS:
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                self.tabViewController =[[XHTabViewController alloc]init];
                self.view.window.rootViewController = self.tabViewController;
                userInfo.upheadspe = [dict[@"upheadspe"] intValue];
                [userInfo saveUserInfoToSanbox];
//                XHLog(@"self message is %@ ",dict);
            }
                break;
            case 8:
                self.tabViewController.contacts = dict[@"friendList"];
                break;
            case 9:
                self.tabViewController.groupInfos = dict[@"groupInfoList"];
                break;
        }
    });
}


-(void)dealloc{
    NSLog(@"--dealloc--%s---",__func__);
}

#pragma mark SessionServerDelegate
-(void)showFriendsWithDict:(NSDictionary *)dict{
    XHLog(@"-showFriendsWithDict-dict.count-----%@--------",dict);
}

-(void)searchContacts:(NSDictionary *)dict{
    
}

#pragma mark textField 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


@end
