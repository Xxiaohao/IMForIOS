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

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pw_word;
@property (weak, nonatomic) IBOutlet UITextField *user_field;
@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (strong,nonatomic) XHAsyncSocketClient *socketClient;
@property (nonatomic,strong) XHTabViewController *tabViewController;

#pragma mark block
@property (nonatomic,copy) void (^loginAction)(NSString *username,NSString *password);


- (IBAction)loginClick;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //网络连接
    self.socketClient = [XHAsyncSocketClient shareSocketClient ];
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [self.socketClient cutOffSocket];
    self.socketClient.socket.userData = SocketOfflineByServer;
    [self.socketClient startConnectSocket];
    NSLog(@"viewController load");
    self.socketClient.allData = [[NSMutableData alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)kbFrameWillChange:(NSNotification *)noti{
    // 获取窗口的高度
   
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;

    
    
    // 键盘结束的Frm
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    NSLog(@"---%@--%fd-",noti.userInfo,kbEndY);
//    self.inputViewConstraint.constant = windowH - kbEndY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick {
    NSString *user = self.user_field.text;
    NSString *pw = self.pw_word.text;
    
    [self.socketClient sendMessage:nil];
    
//    self.tabViewController = [[XHTabViewController alloc]init];
//    
//    [self presentViewController:self.tabViewController animated:YES completion:^{
//    }];
    
//    [self performSegueWithIdentifier:@"login" sender:self];
    NSLog(@"-----%@-------%@----",user,pw);
}



#pragma mark textField 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


@end
