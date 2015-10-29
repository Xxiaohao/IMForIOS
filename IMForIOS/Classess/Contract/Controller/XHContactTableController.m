//
//  XHContactTableController.m
//  IMForIOS
//
//  Created by LC on 15/9/18.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "XHContactTableController.h"
#import "XHContactTableViewCell.h"
#import "XHContactModel.h"
#import "XHAsyncSocketClient.h"

@interface XHContactTableController ()


@end

@implementation XHContactTableController

//-(NSArray *)contacts{
//    if (!contacts) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i=0; i<15; i++) {
//            XHContactModel *model = [[XHContactModel alloc]init];
//            model.userName = [NSString stringWithFormat:@"张三%d",i];
//            model.userSignature = [NSString stringWithFormat:@"大江东去%d",i];
//            [array addObject:model];
//        }
//        contacts = array;
//    }
//    return contacts;
//}

//-(NSArray *)contacts{
//
//}

-(void)setContacts:(NSArray *)contacts{
    XHLog(@"---contactTable--");
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in contacts) {
//        XHLog(@"-----dict------%@-----",dict);
        
        if (![dict[@"userID"] isEqualToString:@"184211"]) {
            XHContactModel *model = [XHContactModel contactWithDict:dict];
            [array addObject:model];
        }
        
    }
    _contacts=array;
    //    self.contacts=array;
    //    XHLog(@"-----_contacts------%@-----",_contacts);
    //    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self loadContacts];
    NSLog(@"contactTable is init");
    
    //    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

//-(void)loadContacts{
//    XHLog(@"-----friends---%@-",[XHAsyncSocketClient shareSocketClient].friends);
//    self.contacts = [XHAsyncSocketClient shareSocketClient].friends;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count is---- %ld",self.contacts.count);
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHContactModel *contact = self.contacts[indexPath.row];
    static NSString *ID=@"contact_cell";
    XHContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!contactCell) {
        contactCell = [[[NSBundle mainBundle]loadNibNamed:@"XHContactTableViewCell" owner:nil options:nil]firstObject];
        contactCell.contactModel=contact;
    }
    return contactCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)dealloc{
    XHLog(@"------");
}


@end
