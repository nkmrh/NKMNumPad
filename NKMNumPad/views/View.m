//
//  View.m
//  HuwaHuwa
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "View.h"
#import "PhysicalPoint.h"

@implementation View

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)setPoints:(NSArray *)points {
  _points = points;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint prevPoint = CGPointZero;
    
  for (int i = 0; i < self.points.count; i++) {
    PhysicalPoint *point = self.points[i];
    CGRect borderRect =
        CGRectMake(point.position.x, point.position.y, 10.0, 10.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillEllipseInRect(context, borderRect);
      
      CGContextSetLineWidth(context,1);
      CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
      
      CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
            CGContextAddLineToPoint(context, point.position.x, point.position.y);
      CGContextStrokePath(context);
      
      
      prevPoint = point.position;
  }
    
    
}

@end
