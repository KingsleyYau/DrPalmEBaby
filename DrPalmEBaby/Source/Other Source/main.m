//
//  main.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#include <signal.h>

#import "GTMStackTrace.h"

void stacktrace(int sig, siginfo_t *info, void *context) {
    // Crash Log写入到文件
    [AppDelegate() logCrashToFile:GTMStackTrace()];
    
}

int main(int argc, char * argv[])
{
    struct sigaction mySigAction;
    mySigAction.sa_sigaction = stacktrace;
    mySigAction.sa_flags = SA_SIGINFO;
    
    sigemptyset(&mySigAction.sa_mask);
    sigaction(SIGQUIT, &mySigAction, NULL);
    sigaction(SIGILL , &mySigAction, NULL);
    sigaction(SIGTRAP, &mySigAction, NULL);
    sigaction(SIGABRT, &mySigAction, NULL);
    sigaction(SIGEMT , &mySigAction, NULL);
    sigaction(SIGFPE , &mySigAction, NULL);
    sigaction(SIGBUS , &mySigAction, NULL);
    sigaction(SIGSEGV, &mySigAction, NULL);
    sigaction(SIGSYS , &mySigAction, NULL);
    sigaction(SIGPIPE, &mySigAction, NULL);
    sigaction(SIGALRM, &mySigAction, NULL);
    sigaction(SIGXCPU, &mySigAction, NULL);
    sigaction(SIGXFSZ, &mySigAction, NULL);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
