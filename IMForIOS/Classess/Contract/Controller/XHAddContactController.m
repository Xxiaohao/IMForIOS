//
//  XHNewContactController.m
//  IMForIOS
//
//  Created by 小侠 on 15-10-10.
//  Copyright © 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHAddContactController.h"
#import "XHContactTableViewCell.h"
#import "XHContactModel.h"
#import "XHDetailTableController.h"
#import "XHAsyncSocketClient.h"
//#import "XHDetailViewController.h"


typedef void(^SearchBlock)(int result,NSDictionary *dict);
@interface XHAddContactController ()
@end

@implementation XHAddContactController
- (void)viewDidLoad{
    [super viewDidLoad];
    
//    XHContactModel *c = [[XHContactModel alloc]init];
//    c.userAge=10;
//    c.userID=@"184211";
//    NSDictionary *dict =  c.keyValues;
    
//    XHContactModel *c2 = [XHContactModel objectWithKeyValues:dict];
    
    //    self.dataList  = [NSArray arrayWithObjects:@"A",@"B",@"C",nil];
    //    NSLog(@"%d", _dataList.count);
    //
    //   self.showData = [NSMutableArray arrayWithArray:_contacts];
    //    [super viewDidLoad];
    //    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    //    [button setTitle: @"添加" forState: UIControlStateNormal];
    //    [button sizeToFit];
    //    self.navigationItem.titleView = button;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"联系人" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    //    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 45)];
    // self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
    UISearchBar *mySearchBar = [[UISearchBar alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45)];
    //        self.searchBar.delegate = self;
    //    self.searchBar.barStyle=UIBarStyleDefault;
    //    self.searchBar.placeholder=@"工号或姓名";
    //    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    //    //改变searchbar的背景颜色
    //        UIView *segment = [mySearchBar.subviews objectAtIndex:0];
    //        [segment removeFromSuperview];
    //        mySearchBar.backgroundColor = [UIColor whiteColor];
    
    mySearchBar.showsCancelButton = YES;
    mySearchBar.barStyle=UIBarStyleDefault;
    mySearchBar.placeholder=@"搜索 工号或姓名";
    mySearchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    //mySearchBar.tintColor = [UIColor whiteColor] ;
    //mySearchBar.backgroundColor=[UIColor whiteColor] ;
    
    _searchBar = mySearchBar;
    self.searchBar.delegate = self;
    //[mySearchBar release];
    self.tableView.tableHeaderView = self.searchBar;
    
    
    
    //    [self.view addSubview:mySearchBar];
    self.tableView.dataSource = self;
    XHLog(@"-----addContactView---%lu",(unsigned long)[self.contacts count] );
    
    
    
}

//-(void)setContacts:(NSArray *)contacts{
//    _contacts = contacts;
//
//    XHLog(@"---contact--");
//}

-(void)setContacts:(NSArray *)contacts{
    XHLog(@"---contactTable--");
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in contacts) {
        //        XHLog(@"-----dict------%@-----",dict);
        
        XHContactModel *model = [XHContactModel contactWithDict:dict];
        [array addObject:model];
        
    }
    _contacts=array;
}

// 2. 告诉UITableView每组显示几条（几行）数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"count is---- %ld",self.contacts.count);
    return  [self.contacts count]>0?[self.contacts count]:0;
    //   return  [_showData count]>0?[_showData count]:0;
    //return 3;
    // return self.contacts.count;
}


// 3. 告诉UITableView每一组的每一行显示什么单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHLog(@"index row is---- %ld",indexPath.row);
    // XHContactModel *contact = self.showData[indexPath.row];
    XHContactModel *contact = self.contacts[indexPath.row];
    XHLog(@"index row is---- %@",contact);
    
    //作为标识符的ID，是专属的
    //    static NSString *ID=@"searchResult_cell";
    //    XHContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    if (!contactCell) {
    //        contactCell = [[[NSBundle mainBundle]loadNibNamed:@"XHContactTableViewCell" owner:nil options:nil]firstObject];
    //        //        XHLog(@"contact is---- %@",contact.userName);
    //        //contactCell.textLabel.text =[NSString stringWithFormat:@"%ld",indexPath.row];
    //        contactCell.contactModel=contact;
    //       // contactCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //
    //    }
    XHLog(@"contacts---%@",contact);
    UITableViewCell *contactCell = [[UITableViewCell alloc]init];
    contactCell.textLabel.text = contact.userName;
    //    contactCell.detailTextLabel.text = contact.userSignature;
    return contactCell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UISearchBar *mySearchBar = [[UISearchBar alloc]
//                                initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45)];
//    mySearchBar.delegate = self;
//    //    //改变searchbar的背景颜色
//    //    UIView *segment = [mySearchBar.subviews objectAtIndex:0];
//    //    [segment removeFromSuperview];
//    //    mySearchBar.backgroundColor = [UIColor whiteColor];
//
//    //   mySearchBar.showsCancelButton = YES;
//    mySearchBar.barStyle=UIBarStyleDefault;
//    mySearchBar.placeholder=@"工号或姓名";
//    mySearchBar.keyboardType=UIKeyboardTypeNamePhonePad;
//
////    [self.view addSubview:mySearchBar];
//
//    return mySearchBar;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//                             TableSampleIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:TableSampleIdentifier];
//    }
//    if (_showData != nil && _showData.count >0) {
//        NSUInteger row = [indexPath row];
//        cell.textLabel.text = [_showData objectAtIndex:row];
//    }
//    return cell;
//}

//选中某个人，查看详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    XHLog(@"-----XHaddContactController--选中某个联系人-");
    //   XHContactModel *contact = self.showData[indexPath.row];
    XHContactModel *contact = self.contacts[indexPath.row];
    NSString *name = contact.userName;
    XHDetailTableController *detailTableController = [[XHDetailTableController alloc]init]; //initWithNibName:nil bundle:nil];
    //   XHDetailViewController *detailTableController = [[XHDetailViewController alloc]init];
    detailTableController.title = [NSString stringWithFormat:@"%@的详情",name];
    detailTableController.contactModel=contact;
    NSString * userName = [NSString stringWithFormat:@"姓名：%@",[contact userName ] ];
    NSString * userID = [NSString stringWithFormat:@"账号：%@",[contact userID ] ];
    NSString * userSex =nil;
    if(contact.userSex==0){
        userSex = @"性别：女";
    }else{
        userSex = @"性别：男";
    }
    //NSString * userSex = [NSString stringWithFormat:@"性别：%@",[contact userSex ] ];

    NSString * userAge = [NSString stringWithFormat:@"年龄：%d岁",[contact userAge ] ];

    NSString * nickName = [NSString stringWithFormat:@"昵称：%@",[contact nickName ] ];
    NSString * userUnit = [NSString stringWithFormat:@"单位：%@",[contact userUnit ] ];
    NSString * userDuty = [NSString stringWithFormat:@"职务：%@",[contact userDuty ] ];
    NSString * userSignature = [NSString stringWithFormat:@"签名：%@",[contact userSignature] ];
    //   NSString * username = [NSString stringWithFormat:@"姓名：%@",[contactModel nickName ] ];
    NSArray *myListArray =[[NSArray alloc]initWithObjects:userID,userName,userSex,userAge,nickName,userSignature,userUnit,userDuty, nil];
    detailTableController.myListArray = myListArray;
    detailTableController.contactModel=contact;
    /************需要修改20151020*******/
    
    //    // Pass the selected object to the new view controller.
    //
    //    // Push the view controller.
    [self.navigationController pushViewController:detailTableController animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    //    NSLog(@"%i",[_dataList count]);
    //    if (searchText!=nil && searchText.length>0) {
    //        self.showData= [NSMutableArray array];
    //        for (NSString *tempStr in _dataList) {
    //            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
    //                [_showData addObject:tempStr];
    //                NSLog(@"%d",[_showData count]);
    //            }
    //        }
    //        [self.tableView reloadData];
    //    }
    //    else
    //    {
    //        self.showData = [NSMutableArray arrayWithArray:_dataList];
    //        [self.tableView reloadData];
    //    }
    //暂时什么都不做；20151018
    
}

/*
 *搜索
 */
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchbar is done");
    // [searchBar setShowsCancelButton:YES animated:YES];
    
    // _searchName = searchBar.text;
    NSString *text =searchBar.text;//@"张";//self.searchName;
    
    //输入框不为空，并且与上次输入内容不同
    if (text.length>0&&![_searchName isEqualToString:text]) {
        _searchName = searchBar.text;
        //        NSString *command = @"55";
        //        NSString *commandResult = @"1";
        //        NSString *contactsVersion = @"0";
        //
        //
        //        NSDictionary *JsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:command,@"commandID" ,commandResult,@"commandResult",_searchName,@"commandContent",nil];
        
        //   SearchBlock searchblock ;
        //    searchblock(1,JsonDic);
        //   [XHAsyncSocketClient shareSocketClient] searchWithBlock（searchblock(1,JsonDic))
        
        //        XHAsyncSocketClient *sessionClient = [XHAsyncSocketClient shareSocketClient];
        //
        [[XHAsyncSocketClient sharedXHAsyncSocketClient] searchWithSearchType:@"1" andContent:_searchName andBlock:^(int result,NSDictionary *dict) {
            XHLog(@"block is handle");
            [self handleResult:result AndContentDict:dict] ;
            
        }];
        
        
        
        //从联系人中进行查询来显示数据，为了测试查询显示//
        //        NSLog(@"search text:%@",_searchName);
        //
        //        self.showData= [NSMutableArray array];
        //
        //        for (NSDictionary *dict in _contacts) {
        //
        //            NSLog(@"username: %@",dict[@"userName"]);
        //
        //
        //
        //            //如果输入的是文字且在列表中有包含该文字姓名的联系人
        //            if ([[NSString stringWithFormat:@"%@",dict[@"userName"]] containsString:text]  ) {
        //
        //                XHLog(@"username in: %@",dict[@"userName"]);
        //                XHContactModel *model = [XHContactModel contactWithDict:dict];
        //                [_showData addObject:model];
        //                XHLog(@"showdata count:  %d",[_showData count]);
        //
        //            }
        //            //如果输入的全部是数字
        //            //            if([[NSString stringWithFormat:@"%@",dict[@"userID"]] isEqualToString:text]){
        //            //                XHLog(@"输入的全部是数字");
        //            //                XHContactModel *model = [XHContactModel contactWithDict:dict];
        //            //                [_showData addObject:model];
        //            //            }
        //        }
        //        //_contacts = _showData;
        //
        //
        //        //        for (NSString *tempStr in _contacts) {
        //        //            if ([tempStr rangeOfString:self.searchName options:NSCaseInsensitiveSearch].length >0 ) {
        //        //                [_showData addObject:tempStr];
        //        //                NSLog(@"%d",[_showData count]);
        //        //            }
        //        //        }
        
        //
        
    }
    
    
    //    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}

//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"cancel is done");
    //[searchBar setShowsCancelButton:NO animated:NO];
    _showData = nil;
    _contacts = nil;
    [self.tableView reloadData ];
    //    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}
//开始编辑之前调用键盘
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldBegin");
    return  YES;
}
//编辑完之后调用
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    
}

/*准备数据*/
//- (NSMutableData *) prepareSendingData:(NSString *)txt{
//    NSError *err = nil;
//    NSString *command = @"55";
//    NSString *commandResult = @"1";
//    NSString *contactsVersion = @"0";
//    NSString *msg = txt;
//    
//    NSMutableDictionary *JsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:command,@"commandID" ,commandResult,@"commandResult",msg,@"commandContent",nil];
//    
//    NSData *JsonString = [NSJSONSerialization dataWithJSONObject:JsonDic options:NSJSONWritingPrettyPrinted error:&err];  //Json的输入参数必须为NSArray或者NSDictionary
//    NSLog(@"所发送的Json为：%@",[[NSString alloc] initWithData: JsonString encoding:NSUTF8StringEncoding]);
//    
//    unsigned int datalength = (unsigned int)JsonString.length;
//    unsigned int datatotallength = datalength + 4;
//    NSLog(@"传递的数据长度为：%u int的长度为%ld",datalength,sizeof(int));
//    
//    uint32_t theInt = htonl((uint32_t)datalength);
//    uint32_t theTotalInt = htonl((uint32_t)datatotallength);
//    
//    //    NSLog(@"---网络theint-%d--本机datalength%ld--theTotalInt---%d---",(uint32_t)datalength,sizeof(theInt),theTotalInt);
//    
//    NSData *lengthData = [[NSData alloc] initWithBytes:&theInt length:sizeof(int)];
//    NSData *lengthTotalData = [[NSData alloc] initWithBytes:&theTotalInt length:sizeof(int)];
//    NSMutableData *sendingData = [NSMutableData alloc];
//    //发送两个长度，第一个是总长度，猜测就是netty默认会解析这么长的数据。第二个就是自己去解析所带的内容
//    [sendingData appendData:lengthTotalData];
//    [sendingData appendData:lengthData];
//    [sendingData appendData:JsonString];
//    
//    //    NSLog(@"发送出的数据为：%@",sendingData);
//    return sendingData;
//}

-(void)handleResult:(int)result AndContentDict:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (result) {
                
                //            case 55:
                //            {
                //                [self dismissViewControllerAnimated:YES completion:nil];
                //                self.tabViewController =[[XHTabViewController alloc]init];
                //                self.view.window.rootViewController = self.tabViewController;
                //            }
                //                break;
                //            case 8:
                //                self.tabViewController.contacts = dict[@"friendList"];
                //                break;
                //            case 9:
                //                self.tabViewController.groupInfos = dict[@"groupInfoList"];
                break;
            case 55:
                XHLog(@"数据结果值：%d",result);
                XHLog(@"数据结果123：%@",dict[@"UserLookForList"]);
                self.contacts = dict[@"UserLookForList"];
                //得到搜索结果后展示
                XHLog(@"jieguo:%ld ",self.contacts.count);
                
                [self.tableView reloadData];
                break;
        }
    });
}









@end
