//
//  XHDetailTableController.h
//  IMForIOS
//
//  Created by 小侠 on 15-10-20.
//  Copyright © 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHContactModel.h"

@interface XHDetailTableController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,copy)  XHContactModel *contactModel;
@property (nonatomic,copy)  NSArray *myListArray;



@end
