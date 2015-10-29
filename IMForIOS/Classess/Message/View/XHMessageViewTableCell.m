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

-(void)setCount:(NSInteger)count{
    _count = count;
    if (_count==0) {
        self.msgCount.text = @"";
    }
}

-(void)setValueWithDic:(NSDictionary *)latestMessageDict andContact:(XHContactModel *)contact andCount:(NSInteger)count{
    XHLog(@"dict is %@",latestMessageDict);
    _count = count;
    _latestMessageDict = latestMessageDict;
    _contact = contact;
    self.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",_contact.upheadspe]];
    self.userName.text = _contact.userName;
    self.msgTime.text = [_latestMessageDict[@"time"] substringWithRange:NSMakeRange(5, 11)];
    self.msgCount.text = [NSString stringWithFormat:@"%ld",count];
    self.msg.text = _latestMessageDict[@"msg"];
    XHLog(@"msg is %@",_latestMessageDict[@"msg"]);
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
    XHLog(@"--------tableviewCell is selected-----------");
    // Configure the view for the selected state
}



@end
