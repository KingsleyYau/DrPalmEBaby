//
//  AttachmentDownloader.h
//  DrPalm
//
//  Created by fgx_lion on 12-4-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassAttachmentDownloader;
@protocol ClassAttachmentDownloaderDelegate <NSObject>
@optional
- (BOOL)attachmentDownloader:(ClassAttachmentDownloader*)attachmentDownloader startDownload:(NSString*)contentType;
- (void)attachmentDownloader:(ClassAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType;
- (void)attachmentDownloader:(ClassAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error;
@end

@interface ClassAttachmentDownloader : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData   *_data;
    NSString        *_contentType;
    NSURLConnection *_urlConnection;
    NSString        *_url;
    id<ClassAttachmentDownloaderDelegate>    _delegate;
}

@property (atomic, assign) id<ClassAttachmentDownloaderDelegate>  delegate;
@property (nonatomic, readonly) NSString    *url;

- (BOOL)startDownload:(NSString*)url delegate:(id<ClassAttachmentDownloaderDelegate>)delegate;
- (BOOL)stopDownload;
@end
