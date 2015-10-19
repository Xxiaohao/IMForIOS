//
//  XHMessageListController.m
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHMessageListController.h"
#import "XHMessageCell.h"
#import "XHChatBean.h"
#import "XHMessageFrame.h"

@interface XHMessageListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *voice;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *emotion;
@property (weak, nonatomic) IBOutlet UIButton *other_features;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;


@end

@implementation XHMessageListController

//- (NSMutableArray *)messageFrames
//{
//    if (_messageFrames == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
//        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
//        
//        NSMutableArray *arrayModels = [NSMutableArray array];
//        for (NSDictionary *dict in arrayDict) {
//            // 创建一个数据模型
//            XHChatBean *chatModel = [XHChatBean chatWithDict:dict];
//            // 获取上一个数据模型
////            XHChatBean *lastMessage = (XHChatBean *)[[arrayModels lastObject] message];
//            // 判断当前模型的“消息发送时间”是否和上一个模型的“消息发送时间”一致， 如果一致做个标记
//            //            if ([model.time isEqualToString:lastMessage.time]) {
//            //                model.hideTime = YES;
//            //            }
//            // 创建一个frame 模型
//            XHMessageFrame *modelFrame = [[XHMessageFrame alloc]init];
//            modelFrame.chatBean = chatModel;
//            // 把frame 模型加到arrayModels
//            [arrayModels addObject:modelFrame];
//        }
//        _messageFrames = arrayModels;
//    }
//    return _messageFrames;
//}

-(void)setMessageFrames:(NSMutableArray *)messageFrames{
    for (NSDictionary *dict in messageFrames) {
        XHChatBean *chatModel = [XHChatBean chatWithDict:dict];
        XHMessageFrame *modelFrame = [[XHMessageFrame alloc]init];
        modelFrame.chatBean = chatModel;
        // 把frame 模型加到arrayModels
        [_messageFrames addObject:modelFrame];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 取消分割线
    self.msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置UITableView的背景色
    self.msgTableView.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1.0];
    
    // 设置UITableView的行不允许被选中
    self.msgTableView.allowsSelection = NO;
    
    //设置msgTableView顶部和navigativeBar的底部相连
    CGRect navigativeBarFrame = self.navigationController.navigationBar.frame;
//    CGPoint offsetPoint =CGPointMake(0, -navigativeBarFrame.size.height-navigativeBarFrame.origin.y);
    XHLog(@"---------%@", NSStringFromCGRect(self.navigationController.navigationBar.frame ));
//    self.msgTableView.contentOffset = offsetPoint;
    self.msgTableView.contentInset = UIEdgeInsetsMake(navigativeBarFrame.size.height+navigativeBarFrame.origin.y, 0, 0, 0);
    // 设置文本框最左侧有一段间距
    UIView *leftVw = [[UIView alloc] init];
    leftVw.frame = CGRectMake(0, 0, 5, 1);
    
    // 把leftVw设置给文本框
    self.inputText.leftView = leftVw;
    self.inputText.leftViewMode = UITextFieldViewModeAlways;
    
    
    // 监听键盘的弹出事件
    // 1. 创建一个NSNotificationCenter对象。
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 2. 监听键盘的弹出通知
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 当键盘上的return键被单击的时候触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1. 获取用户输入的文本
    NSString *text = textField.text;
    
    // 清空文本框
    textField.text = nil;
    
    // 刷新UITableView的数据
    [self.msgTableView reloadData];
    
    // 把最后一行滚动到最上面
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.msgTableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)noteInfo
{
    //    NSLog(@"通知名称: %@", noteInfo.name);
    //
    //    NSLog(@"通知的发布者: %@", noteInfo.object);
    //
    //    NSLog(@"通知的具体内容: %@", noteInfo.userInfo);
    // 1. 获取当键盘显示完毕或者隐藏完毕后的Y值
    CGRect rectEnd = [noteInfo.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = rectEnd.origin.y;
    
    // 用键盘的Y值减去屏幕的高度计算出平移的值
    // 1. 如果是键盘弹出事件, 那么计算出的值就是负的键盘的高度
    // 2. 如果是键盘的隐藏事件, 那么计算出的值就是零， 因为键盘在隐藏以后, 键盘的Y值就等于屏幕的高度。
    CGFloat tranformValue = keyboardY - self.view.frame.size.height;

    [UIView animateWithDuration:5 animations:^{
        // 让控制器的View执行一次“平移”
        self.view.transform = CGAffineTransformMakeTranslation(0, tranformValue);

    }];

    // 让UITableView的最后一行滚动到最上面
    NSIndexPath *lastRowIdxPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.msgTableView scrollToRowAtIndexPath:lastRowIdxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"----count----%ld",self.messageFrames.count);
    return self.messageFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHMessageFrame *messageFrame = self.messageFrames[indexPath.row];
    XHMessageCell *chatBeanCell = [XHMessageCell messageCellWithTableView:tableView];
    chatBeanCell.messageFrame = messageFrame;
    //    chatBeanCell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row]  ;
    return chatBeanCell;
}

#pragma mark -Table view delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHMessageFrame *messageFrame  = self.messageFrames[indexPath.row];
    return messageFrame.rowHeight;
}


// ******** 注意: 监听通知以后一定要在监听通知的对象的dealloc方法中移除监听 **********/.



@end
