//
//  NKMNumPadViewController.h
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import <GLKit/GLkit.h>

@protocol NKMNumPadViewControllerDelegate
-(void)numPadViewControllerDidTouch:(NSIndexPath*)indexPath;
@end

@interface NKMNumPadViewController : GLKViewController
@property (nonatomic, assign) id <GLKViewControllerDelegate, NKMNumPadViewControllerDelegate> delegate;
@property (nonatomic) UIColor *clearColor;
@property (nonatomic) UIColor *hilightColor;
@property (nonatomic) UIColor *tintColor;
@end
