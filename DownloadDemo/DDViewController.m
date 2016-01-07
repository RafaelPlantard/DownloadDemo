//
//  ViewController.m
//  DownloadDemo
//
//  Created by Rafael Ferreira on 1/6/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "DDViewController.h"
#import "AFNetworking.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (NSURL *)downloadSavePathFor:(NSString *)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentsDirectoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    return [documentsDirectoryURL URLByAppendingPathComponent:filename];
}

- (void)showMessage:(NSString *)message {
    UIAlertController *messageController = [UIAlertController alertControllerWithTitle:@"Download Demo" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"continue" style:UIAlertActionStyleCancel handler:nil];
    
    [messageController addAction:continueAction];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

- (AFURLSessionManager *)generateSessionManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.securityPolicy.validatesDomainName = NO;
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    return manager;
}

- (IBAction)downloadFile:(id)sender {
    NSURL *url = [NSURL URLWithString:_downloadURLField.text];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFURLSessionManager *manager = [self generateSessionManager];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = downloadProgress.fractionCompleted;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [self downloadSavePathFor:response.suggestedFilename];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [_loading stopAnimating];
        
        if (!error) {
            NSLog(@"File downloaded to: %@", filePath);
            [self showMessage:@"File download successfully."];
        } else {
            [self showMessage:[NSString stringWithFormat:@"Download error: %@", error.localizedDescription]];
        }
    }];
    
    _progressView.hidden = NO;
    _progressView.progress = 0;
    
    [_loading startAnimating];
    
    
    [downloadTask resume];
}
@end