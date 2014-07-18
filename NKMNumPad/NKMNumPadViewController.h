//
//  NKMNumPadViewController.h
//
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import <GLKit/GLkit.h>

@protocol NKMNumPadViewControllerDelegate
- (void)numPadViewControllerDidTouch:(NSIndexPath *)indexPath;
@end

@interface NKMNumPadViewController : GLKViewController
@property(nonatomic, weak) id<NKMNumPadViewControllerDelegate> touchDelegate;
@property(nonatomic) UIColor *clearColor;
@property(nonatomic) UIColor *hilightColor;
@property(nonatomic) UIColor *tintColor;
@property(nonatomic) NSString *imageNameFor4Inch;
@property(nonatomic) NSString *imageNameFor3_5Inch;
@end
