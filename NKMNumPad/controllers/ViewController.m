//
//  ViewController.m
//  HuwaHuwa
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "ViewController.h"
#import "PhysicalPoint.h"
#import "View.h"

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
  CGFloat dx = point2.x - point1.x;
  CGFloat dy = point2.y - point1.y;
  return sqrt(dx * dx + dy * dy);
};

@interface ViewController () {
  NSMutableArray *_points;
  NSMutableArray *_locations;
  NSTimer *_timer;
  CGPoint _touchPoint;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _points = [NSMutableArray new];
  _locations = [NSMutableArray new];
  _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);

  const NSInteger interval = 100;
  const NSInteger col = 4;
  const NSInteger row = 3;

  for (int i = 0; i < col; i++) {
    for (int j = 0; j < row; j++) {
      CGPoint location;
      location.x = CGRectGetWidth(self.view.frame) * 0.5 -
                   (row - 1) * 0.5 * interval + j * interval;
      location.y = CGRectGetHeight(self.view.frame) * 0.5 -
                   (col - 1) * 0.5 * interval + i * interval;

      [_points addObject:[[PhysicalPoint alloc] initWithPoint:location]];
      [_locations addObject:[NSValue valueWithCGPoint:location]];
    }
  }

  _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                            target:self
                                          selector:@selector(_loop:)
                                          userInfo:nil
                                           repeats:YES];

  ((View *)self.view).points = _points;
}

- (void)_loop:(NSTimer *)timer {
  for (int i = 0; i < _points.count; i++) {
    PhysicalPoint *point = _points[i];

    CGPoint position = point.position;
    CGPoint location = [_locations[i] CGPointValue];

    [point configureAccelerationXvalue:(location.x - position.x) * 80
                                Yvalue:(location.y - position.y) * 80];

    CGFloat maxDist = 80.0f;
    CGFloat dist = DistanceBetweenTwoPoints(position, _touchPoint);

    if (dist < maxDist) {
      CGFloat par = (maxDist - dist) / maxDist;
      [point
          configureAccelerationXvalue:(position.x - _touchPoint.x) * par * 80
                               Yvalue:(position.y - _touchPoint.y) * par * 80];
    }
  }
    
  ((View *)self.view).points = _points;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];

  UITouch *touch = [touches anyObject];
  _touchPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);;
}

@end
