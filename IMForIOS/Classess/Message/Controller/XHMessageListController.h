//
//  XHMessageListController.h
//  IMForIOS
//
//  Created by LC on 15/10/12.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactModel.h"
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface XHMessageListController : UIViewController

singleton_interface(XHMessageListController)
@property (nonatomic,strong) NSMutableArray *messageFrames;
@property (nonatomic,strong) XHContactModel *contactPerson;
@property (nonatomic,strong) NSString *senderID;
//@property (nonatomic,strong) NSString *visible;

//对接收到的消息进行处理
-(void)handleNewMessage:(NSDictionary *)dict AndFlag:(NSString *)flag;

//装载数据并对数据进行处理
-(void)loadAndHandleDataWithContact:(XHContactModel *)contact andMessageArray:(NSArray *)messageArray;



@end
