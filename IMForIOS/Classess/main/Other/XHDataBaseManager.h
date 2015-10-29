//
//  XHDataBaseManager.h
//  IMForIOS
//
//  Created by LC on 15/10/28.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Singleton.h"

@interface XHDataBaseManager : NSObject

@property (nonatomic,strong) XHDataBaseManager *dbManager;
@property (nonatomic,strong) FMDatabase *db;

singleton_interface(XHDataBaseManager);

/**将消息放入本地数据库中的msgs表中 */
-(NSInteger)insertMessageWithDict:(NSDictionary *)dict andFlag:(NSString *)flag;

/**将msgs表中已读消息的flag改成read */
-(NSInteger)updateMessageWithSender:(NSString *)senderID;

/**读取msgs表中的消息数据 */
-(NSMutableArray *)readMessageWithSender:(NSString *)senderID;


@end
