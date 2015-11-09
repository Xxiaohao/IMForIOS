//
//  XHMessageListController.m
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//
/**
 *  此类主要是消息的发送、发送消息后的处理，直接接收消息的处理，用户从消息列表点击消息cell，然后对消息的处理，查看历史消息，历史消息的处理。
 *  消息处理的同时，有对时间的处理（是否显示时间），历史消息和其他消息对时间的处理有所不同，历史消息属于全部重绘，其他消息单条插入
 */

#import "XHMessageListController.h"
#import "XHMessageCell.h"
#import "XHChatBean.h"
#import "XHMessageFrame.h"
#import "XHMessageClient.h"
#import "XHUserInfo.h"
#import "XHDataBaseManager.h"
#import "MJRefresh.h"
#import "TYImageCache.h"
#import "Masonry.h"

#define TextMsg @"0"

@interface XHMessageListController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *voice;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *emotion;
@property (weak, nonatomic) IBOutlet UIButton *other_features;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray * messages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *featureViewHeight;
@property (weak, nonatomic) IBOutlet UIView *operateView;
@property (weak, nonatomic) IBOutlet UIView *featureView;
@property (nonatomic,assign) NSInteger flag;

- (IBAction)clickFeature;

@end

@implementation XHMessageListController

singleton_implementation(XHMessageListController)

-(void)loadAndHandleDataWithContact:(XHContactModel *)contact andMessageArray:(NSArray *)messageArray{
    self.currentPage = 1;
    self.messageFrames = [NSMutableArray array];
    self.messages = [NSMutableArray array];
    XHLog(@"111contact.userid is %@",contact.userID);
    _contactPerson = contact;
    for (NSDictionary *dict in messageArray) {
        [self handleNewMessage:dict AndFlag:@""];
        //        [self.messages addObject:dict];
    }
    self.title = self.contactPerson.userName;
    [self.msgTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置msgTableView顶部和navigativeBar的底部相连
    CGRect navigativeBarFrame = self.navigationController.navigationBar.frame;
    //    self.navigationController.navigationBarHidden = YES;
    self.msgTableView.contentInset = UIEdgeInsetsMake(navigativeBarFrame.size.height+navigativeBarFrame.origin.y-10, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    XHLog(@"messagelist load");
    // 取消分割线
    self.msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置UITableView的背景色
    self.msgTableView.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1.0];
    // 设置UITableView的行不允许被选中
    self.msgTableView.allowsSelection = NO;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    [header setTitle:@"下拉加载更多消息" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载更多消息" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"已加载所有消息" forState:MJRefreshStateNoMoreData];
    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
    
    self.msgTableView.header= header;
    
    // 设置文本框最左侧有一段间距
    UIView *leftVw = [[UIView alloc] init];
    leftVw.frame = CGRectMake(0, 0, 5, 1);
    self.inputText.leftView = leftVw;
    self.inputText.leftViewMode = UITextFieldViewModeAlways;
    
    [self loadFeatures];
    
    // 监听键盘的弹出事件 创建一个NSNotificationCenter对象。
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 监听键盘的弹出通知
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)loadMoreMessage{
    self.currentPage++;
    [self.messageFrames removeAllObjects];
    NSMutableArray *array = [[XHDataBaseManager sharedXHDataBaseManager]readMessageWithSender:self.contactPerson.userID andCurrentPage:self.currentPage];
    for (NSDictionary *dict in [[array reverseObjectEnumerator]allObjects] ) {
        [self.messages insertObject:dict atIndex:0];
    }
    for (NSDictionary *dict in self.messages) {
        [self handleNewMessage:dict AndFlag:@"history"];
    }
    [self.msgTableView.header endRefreshing];
    [self.msgTableView reloadData];
}

/**
 *  比较两条消息的时间差，确定是否显示时间
 *  @param chatModel 消息对象
 */
-(void)hiddenTimeWithChatBean:(XHChatBean *)chatModel{
    XHChatBean *cb = ((XHMessageFrame *)[self.messageFrames lastObject]).chatBean;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (cb !=nil) {
        NSDate *lastDate = [format dateFromString:[cb.time substringToIndex:19]];
        NSDate *nowDate = [format dateFromString:[chatModel.time substringToIndex:19]];
        CGFloat timePeriod= [nowDate timeIntervalSince1970] -[lastDate timeIntervalSince1970];
        if (timePeriod <120) {
            chatModel.hiddenTime = YES;
        }
    }
}

#pragma mark 接收消息
//flag是chat则是正在聊天的消息   flag是history则表示为从数据库中读取的消息
-(void)handleNewMessage:(NSDictionary *)dict AndFlag:flag{
    XHChatBean *chatModel = [XHChatBean chatWithDict:dict];
    self.senderID = chatModel.senderID;
    XHMessageFrame *messageFrame = [[XHMessageFrame alloc]init];
    chatModel.headImg = [NSString stringWithFormat:@"%03d", self.contactPerson.upheadspe];
    
    if ([NSString stringWithFormat:@"%@",dict[@"time"]].length>19) {
        chatModel.time =dict[@"time"];
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"time"] intValue]];
        NSString *time = [NSString stringWithFormat:@"%@",date];
        chatModel.time =time;
    }
    [self hiddenTimeWithChatBean:chatModel];
    messageFrame.chatBean = chatModel;
    // 把frame 模型加到arrayModels
    if (![flag isEqualToString:@"history"]) {
        [self.messages addObject:dict];
    }
    [self.messageFrames addObject:messageFrame];
    
    [self.msgTableView reloadData];
}

#pragma mark 发送消息
// 当键盘上的return键被单击的时候触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1. 获取用户输入的文本
    NSString *text = textField.text;
    if (text ==nil || [text isEqualToString:@""]) {
        return 0;
    }
    if(text.length>300){
        XHLog(@"您发送的数据过多！");
    }
    //创建消息对象、消息字典
    XHChatBean *chatBean = [[XHChatBean alloc]init];
    chatBean.senderID = [XHUserInfo sharedXHUserInfo].userID;
    chatBean.receiverID = self.contactPerson.userID;
    NSMutableArray *msgFalgQueue = [NSMutableArray array];
    [msgFalgQueue addObject:TextMsg];
    NSMutableArray *msgQueue = [NSMutableArray array];
    [msgQueue addObject:text];
    chatBean.msgFlagQueue = msgFalgQueue;
    chatBean.msgQueue = msgQueue;
    chatBean.msg = text;
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [format stringFromDate:[NSDate date]];
    //    XHLog(@"11111111time is %@ and dd is %@",time,[NSDate date]);
    chatBean.time =time;
    
    NSDictionary *chatBeanDict = chatBean.keyValues;
    
    [self.messages addObject:chatBeanDict];
    //将消息插入数据库
    [[XHDataBaseManager sharedXHDataBaseManager]insertMessageWithDict:chatBeanDict andFlag:@"read"];
    //    XHLog(@" 消息发送成功 is %ld ",result);
    
    //设置消息的frame并放入自己的聊天页面中显示
    XHMessageFrame *messageFrame = [[XHMessageFrame alloc]init];
    chatBean.headImg = [NSString stringWithFormat:@"%03d", [XHUserInfo sharedXHUserInfo].upheadspe];
    [self hiddenTimeWithChatBean:chatBean];
    messageFrame.chatBean = chatBean;
    [self.messageFrames addObject:messageFrame];
    
    [[XHMessageClient sharedXHMessageClient]sendingDataWithCommandID:PERSON_TO_PERSON_MESSAGE andCommandResult:@"-1" andCommandContent:[chatBeanDict JSONString]];
    
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
    // 1. 获取当键盘显示完毕或者隐藏完毕后的Y值
    CGRect rectEnd = [noteInfo.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = rectEnd.origin.y;
    
    // 用键盘的Y值减去屏幕的高度计算出平移的值
    // 1. 如果是键盘弹出事件, 那么计算出的值就是负的键盘的高度
    // 2. 如果是键盘的隐藏事件, 那么计算出的值就是零， 因为键盘在隐藏以后, 键盘的Y值就等于屏幕的高度。
    CGFloat tranformValue = keyboardY - self.view.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        // 让控制器的View执行一次“平移”
        self.featureViewHeight.constant = -tranformValue;
        //        self.view.transform = CGAffineTransformMakeTranslation(0, tranformValue);
    }];
    
    // 让UITableView的最后一行滚动到最上面
    if (self.messageFrames.count>0) {
        NSIndexPath *lastRowIdxPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
        [self.msgTableView scrollToRowAtIndexPath:lastRowIdxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHMessageFrame *messageFrame = self.messageFrames[indexPath.row];
    XHMessageCell *chatBeanCell = [XHMessageCell messageCellWithTableView:tableView];
    chatBeanCell.messageFrame = messageFrame;
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
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFeatures{
    NSArray *featureIcons = @[@"location",@"microphone",@"phoneshake",@"photos",@"record_begin_button"];
    NSArray *featureTexts = @[@"位置",@"语音",@"抖动",@"照片",@"待定"];
    CGFloat subWith = 64;
    CGFloat subHight = 80;
    CGFloat marginHor = (self.view.frame.size.width - subWith*4)/5;
    CGFloat marginVer = 10;
    
    //    UIView *featureView = [[UIView alloc]init];
    for (int i =0; i<featureIcons.count; i++) {
        UIButton *featureIcon = [[UIButton alloc]init];
        featureIcon.tag = i;
        [featureIcon addTarget:self action:@selector(featureAction:) forControlEvents:UIControlEventTouchUpInside];
        [featureIcon setImage:[UIImage imageNamed:featureIcons[i]] forState:UIControlStateNormal];
        [featureIcon setTitle:featureTexts[i] forState:UIControlStateNormal];
        featureIcon.titleLabel.font = [UIFont systemFontOfSize:12];
        [featureIcon setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
        [featureIcon setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        featureIcon.frame = CGRectMake((i%4+1)*marginHor+i%4*subWith, (i/4+1)*marginVer+i/4*80, subWith, subHight);
        
        [self.featureView addSubview:featureIcon];
    }
    //    return featureView;
}

-(void)featureAction:(UIButton *)sender{
    XHLog(@"-----%ld-",sender.tag);
    switch (sender.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3://选择图片
            [self pickImg];
            break;
        case 4:
            
            break;
    }
}

-(void)pickImg{
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc]init];
    imgPickerController.delegate = self;
//    imgPickerController.title = @"图片选择";
//    imgPickerController.allowsEditing = YES;
    imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPickerController animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    XHLog(@" info is %@",info);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    UIViewController *viewController = [[UIViewController alloc]init];
    viewController.view.backgroundColor = [UIColor  whiteColor];
    UIImageView *imgView = [[UIImageView alloc]init];
//    CGSize imgSize = img.size;
//    XHLog(@" size is %@",NSStringFromCGSize(imgSize));
//    BOOL b = [[TYImageCache cache] saveImageFromName:[NSString stringWithFormat:@"%d.png",arc4random_uniform(1000)] image:img];
//    XHLog(@"---b--is %d---",b);
    CGSize previewSize = CGSizeZero;
    if (img.size.width>viewController.view.frame.size.width||img.size.height>viewController.view.frame.size.height) {
        CGFloat scaleWidth = img.size.width/viewController.view.frame.size.width;
        CGFloat scaleHeight = img.size.height/viewController.view.frame.size.height;
        if (scaleWidth>scaleHeight) {
            previewSize = CGSizeMake(img.size.width/scaleWidth, img.size.height/scaleWidth);
        }else{
            previewSize = CGSizeMake(img.size.width/scaleHeight, img.size.height/scaleHeight);
        }
    }else{
        previewSize = img.size;
    }
    CGFloat imgViewY = (viewController.view.frame.size.height-previewSize.height)/2;
    CGFloat imgViewX = (viewController.view.frame.size.width-previewSize.width)/2;
    imgView.frame = CGRectMake(imgViewX, imgViewY, previewSize.width, previewSize.height);
    imgView.image = img;
    [viewController.view addSubview:imgView];
    [picker pushViewController:viewController animated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 控件点击事件
- (IBAction)clickFeature {
    [self.view endEditing:YES];
    if (self.featureViewHeight.constant == 200) {
        self.featureViewHeight.constant = 0;
    }else{
        self.featureViewHeight.constant = 200;
    }
}


@end
