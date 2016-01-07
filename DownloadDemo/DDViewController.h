//
//  ViewController.h
//  DownloadDemo
//
//  Created by Rafael Ferreira on 1/6/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! @brief The controller for the first view. */
@interface DDViewController : UIViewController

/*! @brief The file url to download it. */
@property (weak, nonatomic) IBOutlet UITextField *downloadURLField;

/*! @brief Action to be done when I touch the DownloadButton. */
- (IBAction)downloadFile:(id)sender;

/*! @brief The reference for the progress bar UI component.*/
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/*! @brief The reference for the loading UI component. */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end