//
//  NKMPhysicalPoint.m
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "NKMPhysicalPoint.h"

@interface NKMPhysicalPoint () {
  CGPoint _initialPoint;
  CGFloat _accelerationX;
  CGFloat _accelerationY;
  CGFloat _speedX;
  CGFloat _speedY;
  CGFloat _resistance;
}

@end

@implementation NKMPhysicalPoint

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (instancetype)init {
  return [self initWithPoint:CGPointZero];
}

- (instancetype)initWithPoint:(CGPoint)point {
  self = [super init];
  if (!self) {
    return nil;
  }
    
  _initialPoint = point;
    
  [self initializeInstanceVariables];
    
  return self;
}

//--------------------------------------------------------------//
#pragma mark -- Public --
//--------------------------------------------------------------//

- (void)initializeInstanceVariables
{
    _position = _initialPoint;
    _resistance = 0.6;
    _accelerationX = 0.0;
    _accelerationY = 0.0;
    _speedX = 0.0;
    _speedY = 0.0;
}

- (void)updateWithInterval:(NSTimeInterval)interval
{
    NSTimeInterval t = interval;
    CGPoint point;
    point = _position;
    point.x += _speedX * t + 0.5 * _accelerationX * t * t;
    point.y += _speedY * t + 0.5 * _accelerationY * t * t;
    _position = point;
    
    _speedX += _accelerationX * t;
    _speedY += _accelerationY * t;
    
    _speedX *= _resistance;
    _speedY *= _resistance;
    
    _accelerationX = 0.0;
    _accelerationY = 0.0;
}

- (void)configureAccelerationXvalue:(CGFloat)x Yvalue:(CGFloat)y {
  _accelerationX += x;
  _accelerationY += y;
}

@end
