//
//  XHMessageCell.h
//  001QQ聊天界面
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHMessageFrame;
@interface XHMessageCell : UITableViewCell

// 为自定义单元格增加一个frame 模型属性
@property (nonatomic, strong) XHMessageFrame *messageFrame;


// 封装一个创建自定义Cell的方法
+ (instancetype)messageCellWithTableView:(UITableView *)tableView;


@end
