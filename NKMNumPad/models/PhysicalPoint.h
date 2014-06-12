//
//  PhysicalPoint.h
//  HuwaHuwa
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhysicalPoint : NSObject

@property(nonatomic) CGFloat speedX;
@property(nonatomic) CGFloat speedY;
@property(nonatomic) CGFloat resistance;
@property(nonatomic) CGPoint position;

- (instancetype)init;
- (instancetype)initWithPoint:(CGPoint)point;
- (void)configureAccelerationXvalue:(CGFloat)x Yvalue:(CGFloat)y;

@end
