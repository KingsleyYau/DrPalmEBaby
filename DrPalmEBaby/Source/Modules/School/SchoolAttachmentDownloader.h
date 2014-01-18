//
//  AttachmentDownloader.h
//  DrPalm
//
//  Created by fgx_lion on 12-4-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SchoolAttachmentDownloader;
@protocol SchoolAttachmentDownloaderDelegate <NSObject>
@optional
- (BOOL)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader startDownload:(NSString*)contentType;
- (void)attachmentDownloader:(SchoolAttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType;
- (void)attachmentDownloader:(SchoolAttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error;
@end

@interface SchoolAttachmentDownloader : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData   *_data;
    NSString        *_contentType;
    NSURLConnection *_urlConnection;
    NSString        *_url;
    id<SchoolAttachmentDownloaderDelegate>    _delegate;
}

@property (atomic, assign) id<SchoolAttachmentDownloaderDelegate>  delegate;
@property (nonatomic, readonly) NSString    *url;

- (BOOL)startDownload:(NSString*)url delegate:(id<SchoolAttachmentDownloaderDelegate>)delegate;
- (BOOL)stopDownload;
@end
