//
//  ZJLogger.h
//  LogApp
//
//  Created by Zhu J on 3/7/13.
//  Copyright (c) 2013 Zhu J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJLogDefine.h"

NSArray *logLevelMsg;

@interface ZJLogger : NSObject


//+(id)shareInstanceWithLogFileFolderPath:(NSString *)filePath;
+(id)shareInstance;
- (void)logAtLevel:(ZJLogLevel)logLevel withFormat:(NSString *)format, ...;
- (void)logAtLevel:(ZJLogLevel)logLevel withLogMsg:(NSString *)msg;
@end
