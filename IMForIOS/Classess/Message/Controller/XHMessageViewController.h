//
//  XHMessageViewController.h
//  IMForIOS
//
//  Created by LC on 15/9/17.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHMessageViewController : UITableViewController

@property (nonatomic,strong)NSArray *contacts;//联系人信息
//@property (nonatomic,strong)NSMutableDictionary *messagesDictionary;//key:用户账号 value：MutableArray  转载该用户发送过来的消息
@property (nonatomic,strong)NSMutableArray *contactsMessages;

@end
