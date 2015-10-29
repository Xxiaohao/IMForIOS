//
//  XHNewContactController.h
//  IMForIOS
//
//  Created by 小侠 on 15-10-10.
//  Copyright © 2015年 XH. All rights reserved.
//

#ifndef XHAddContactController_h
#define XHAddContactController_h


#endif /* XHNewContactController_h */

#import <UIKit/UIKit.h>
#import "XHContactModel.h"


@interface XHAddContactController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
//{
//    NSArray *dataList;
//    NSMutableArray *showData;
//}
@property (retain, nonatomic) NSMutableArray *showData;
//@property (retain, nonatomic) NSArray *dataList;
//@property (retain, nonatomic) NSArray *showData;
@property (nonatomic,copy)XHContactModel *contactModel;

@property (nonatomic,strong)NSArray *contacts;
@property (nonatomic,copy)NSString *searchName;//搜索框内容

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
