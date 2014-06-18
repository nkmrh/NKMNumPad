//
//  NKMPhysicalPoint.h
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

@interface NKMPhysicalPoint : NSObject

@property(nonatomic, readonly) CGPoint position;

- (instancetype)init;
- (instancetype)initWithPoint:(CGPoint)point;
- (void)initializeInstanceVariables;
- (void)configureAccelerationXvalue:(CGFloat)x Yvalue:(CGFloat)y;
- (void)updateWithInterval:(NSTimeInterval)interval;

@end
