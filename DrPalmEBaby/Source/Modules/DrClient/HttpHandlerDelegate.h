//
//  HttpHandlerDelegate.h
//  DrCOMClientWS
//
//  Created by Keqin Su on 11-4-18.
//  Copyright 2011 City Hotspot Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HttpHandlerDelegate <NSObject>

- (void)onHttpReceiveForCheck:(NSString*)data original:(NSURL*)original current:(NSURL*)current gwHost:(NSString*)gwHost;
- (void)onHttpReceiveForLogin:(NSString*)data;
- (void)onHttpReceiveForLogout:(NSString*)data;
- (void)onHttpReceiveForStatus:(NSString*)data;
- (void)onHttpReceiveForVersion:(NSString*)data;
- (void)onHttpError:(NSError*)error;

@end
