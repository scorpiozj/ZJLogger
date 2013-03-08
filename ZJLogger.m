//
//  ZJLogger.m
//  LogApp
//
//  Created by Zhu J on 3/7/13.
//  Copyright (c) 2013 Zhu J. All rights reserved.
//

#import "ZJLogger.h"

@interface ZJLogger()
{
//    NSLock *writeLock;
//    NSString *logFilePath;
//    NSFileHandle *fileHandle;
}

@property (nonatomic, strong) NSString *logFilePath;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSArray *logLevelArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *processID;
@end

NSString *const fileName = @"ServersManDiskLog.txt";


@implementation ZJLogger



@synthesize logFilePath = _logFilePath;
@synthesize fileHandle = _fileHandle;

@synthesize processID = _processID;
@synthesize dateFormatter = _dateFormatter;
static ZJLogger *sharedLogger = nil;
- (id)initWithLogFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        self.logFilePath = [filePath stringByAppendingPathComponent:fileName];
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if (![fileManager fileExistsAtPath:self.logFilePath])
        {
            [@"" writeToFile:self.logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
        
        
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        self.processID = [NSString stringWithFormat:@"%d",[processInfo processIdentifier]];
        
        
        self.logLevelArray = [NSArray arrayWithObjects:@"LogNone",@"DEBUG",@"INFO",@"WARNING",@"ERROR",@"FATAL", nil];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)dealloc
{

    [_dateFormatter release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    [super dealloc];
}

+(id)shareInstanceWithLogFileFolderPath:(NSString *)filePath;
{
    @synchronized(self)
    {
        if (sharedLogger == nil)
        {
            sharedLogger = [[ZJLogger alloc] initWithLogFilePath:filePath];
        }
    }
    return sharedLogger;
    
}
- (void)logAtLevel:(ZJLogLevel)logLevel withFormat:(NSString *)format, ...;
{
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [self logAtLevel:logLevel withLogMsg:msg];
    [msg release];
    
}
- (void)logAtLevel:(ZJLogLevel)logLevel withLogMsg:(NSString *)msg;
{
    //level
    if (logLevel > kLogFatal || logLevel < kLogDebug)
    {
        logLevel = kLogDebug;
    }
    

#ifdef RELEASE
    if (logLevel < kLogInfo)
    {
        logLevel = kLogInfo;
    }
#endif
    
    
    NSString *levelMsg = self.logLevelArray[logLevel];
    
    //timestamp
    NSString *dateStr = nil;
    dateStr = [self.dateFormatter stringFromDate:[NSDate date]];
    
    //thread id
    NSString *thread = nil;
    mach_port_t another = mach_thread_self();
    thread = [NSString stringWithFormat:@"%d",another];

    //nslog and persistence
    [self logAndWrite:[NSArray arrayWithObjects:dateStr,self.processID,thread,levelMsg,msg, nil]];

}

- (void)logAndWrite:(NSArray *)array
{
    NSString *logStr = [NSString stringWithFormat:@"TIME:%@ PID:%@ TID:%@ LVL:%@\t%@\n",array[0],array[1],array[2],array[3],array[4]];
    NSLog(@"%@",logStr);
    [self performSelectorInBackground:@selector(writeToFile:) withObject:logStr];
}

- (void)writeToFile:(NSString *)msg
{
    @synchronized(self)
    {
        [self.fileHandle seekToEndOfFile];
        [self.fileHandle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
        [self.fileHandle synchronizeFile];
    }
    
}

- (void)appWillTerminate:(NSNotification *)noti
{
    [self.fileHandle closeFile];
}
@end
