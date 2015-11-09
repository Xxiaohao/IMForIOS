//
//  CZMessageCell.m
//  001QQ聊天界面
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "XHMessageCell.h"
#import "XHChatBean.h"
#import "XHMessageFrame.h"
#import "XHUserInfo.h"

@interface XHMessageCell ()

@property (nonatomic, weak) UILabel *lblTime;
@property (nonatomic, weak) UIImageView *imgViewIcon;
@property (nonatomic, weak) UIButton *btnText;
@end


@implementation XHMessageCell

#pragma mark -  重写initWithStyle方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建子控件
        
        // 显示时间的label
        UILabel *lblTime = [[UILabel alloc] init];
        // 设置文字大小
        lblTime.font = [UIFont systemFontOfSize:12];
        // 设置文字居中
        lblTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblTime];
        self.lblTime = lblTime;
        
        
        // 显示头像的UIImageView
        UIImageView *imgViewIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:imgViewIcon];
        self.imgViewIcon = imgViewIcon;
        
        
        // 显示正文的按钮
        UIButton *btnText = [[UIButton alloc] init];
        // 设置正文的字体大小
        btnText.titleLabel.font = textFont;
        // 修改按钮的正文文字颜色
        [btnText setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // 设置按钮中的label的文字可以换行
        btnText.titleLabel.numberOfLines = 0;
        // 设置按钮的背景色
        //btnText.backgroundColor = [UIColor purpleColor];
        
        // 设置按钮中的titleLabel的背景色
        //btnText.titleLabel.backgroundColor = [UIColor greenColor];
        
        // 设置按钮的内边距
        btnText.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 20);
        
        [self.contentView addSubview:btnText];
        self.btnText = btnText;
    }
    
    // 设置单元格的背景色为clearColor
    self.backgroundColor = [UIColor clearColor];
    return self;
}


#pragma mark -  重写frame 模型的set方法
- (void)setMessageFrame:(XHMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    // 获取数据模型
    XHChatBean *chatBean = messageFrame.chatBean;
    
    // 设置 "时间Label"的数据 和 frame
    self.lblTime.text = [chatBean.time substringToIndex:19];
    self.lblTime.frame = messageFrame.timeFrame;
//    self.lblTime.hidden = chatBean.hideTime;

    // 设置 头像
    self.imgViewIcon.image = [UIImage imageNamed:messageFrame.chatBean.headImg];
    self.imgViewIcon.frame = messageFrame.iconFrame;
    
    
    // 设置消息正文
    [self.btnText setTitle:chatBean.msg forState:UIControlStateNormal];
    self.btnText.frame = messageFrame.textFrame;
    
    
    
    // 设置正文的背景图
    NSString *imgNor, *imgHighlighted;
    if ([[XHUserInfo sharedXHUserInfo].userID isEqualToString:chatBean.senderID ]) {
        // 自己发的消息
        imgNor = @"chat_send_nor";
        imgHighlighted = @"chat_send_press_pic";
        
        // 设置消息的正文文字颜色为 "白色"
        [self.btnText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        // 对方发的消息
        imgNor = @"chat_recive_nor";
        imgHighlighted = @"chat_recive_press_pic";
        
       // 设置消息的正文文字颜色为 "黑色"
        [self.btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    // 加载图片
    UIImage *imageNormal = [UIImage imageNamed:imgNor];
    UIImage *imageHighlighted = [UIImage imageNamed:imgHighlighted];
    
    // 用平铺的方式拉伸图片
    imageNormal = [imageNormal stretchableImageWithLeftCapWidth:imageNormal.size.width * 0.5 topCapHeight:imageNormal.size.height * 0.5];
    imageHighlighted = [imageHighlighted stretchableImageWithLeftCapWidth:imageHighlighted.size.width * 0.5 topCapHeight:imageHighlighted.size.height * 0.5];
    
    // 设置背景图
    [self.btnText setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self.btnText setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
}


#pragma mark -  创建自定义Cell的方法
+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"chatBean_cell";
    XHMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XHMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
