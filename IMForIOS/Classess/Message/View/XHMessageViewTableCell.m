//
//  XHMessageViewTableCell.m
//  IMForIOS
//
//  Created by LC on 15/10/15.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHMessageViewTableCell.h"

@interface XHMessageViewTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *msgTime;
@property (weak, nonatomic) IBOutlet UILabel *msgCount;
@property (weak, nonatomic) IBOutlet UILabel *msg;

@end


@implementation XHMessageViewTableCell

-(void)setMessageArrays:(NSArray *)messageArrays{
    self.messageArrays = messageArrays;
    self.headImage.image = [UIImage imageNamed:self.messageArrays[0][@""]];
    self.userName.text = self.messageArrays[0][@"userName"];
    self.msgTime.text = self.messageArrays[0][@"msgTime"];
    self.msgCount.text = [NSString stringWithFormat:@"%ld",self.messageArrays.count];
    self.msg.text = self.messageArrays[0][@"msg"];
}


+(instancetype)messageViewCellWithTableView :(UITableView *)tableView{
   static NSString *ID = @"messageView_cell";
   XHMessageViewTableCell *messageViewCell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!messageViewCell) {
        messageViewCell = [[[NSBundle mainBundle]loadNibNamed:@"XHMessageViewTableCell" owner:nil options:nil]firstObject];
    }
    return messageViewCell;
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
