//
//  NKMPhysicalPoint.m
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "NKMPhysicalPoint.h"

@interface NKMPhysicalPoint () {
  CGFloat _accelerationX;
  CGFloat _accelerationY;
  NSTimeInterval _prevTimeinterval;
  NSTimer *_timer;
}

@end

@implementation NKMPhysicalPoint

- (instancetype)init {
  return [self initWithPoint:CGPointZero];
}

- (instancetype)initWithPoint:(CGPoint)point {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.position = point;
  self.resistance = 0.95;
  _accelerationX = 0;
  _accelerationY = 0;
  self.speedX = 0;
  self.speedY = 0;
  _prevTimeinterval = [[NSDate date] timeIntervalSince1970];

  _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                   target:self
                                 selector:@selector(_loop:)
                                 userInfo:nil
                                  repeats:YES];
  return self;
}

- (void)_loop:(NSTimer *)timer {
  NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval t = (nowInterval - _prevTimeinterval);
    
  CGPoint point;
  point = self.position;
  point.x += self.speedX * t + 0.5 * _accelerationX * t * t;
  point.y += self.speedY * t + 0.5 * _accelerationY * t * t;
  self.position = point;

  _speedX += _accelerationX * t;
  _speedY += _accelerationY * t;

  _speedX *= _resistance;
  _speedY *= _resistance;

  _accelerationX = 0;
  _accelerationY = 0;

  _prevTimeinterval = nowInterval;
}

- (void)configureAccelerationXvalue:(CGFloat)x Yvalue:(CGFloat)y {
  _accelerationX += x;
  _accelerationY += y;
}

@end
