//
//  NKMNumPadView.m
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "NKMNumPadView.h"
#import "NKMPhysicalPoint.h"

@implementation NKMNumPadView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

#if 0
- (void)setPoints:(NSArray *)points {
  _points = points;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint prevPoint = CGPointZero;
    
  for (int i = 0; i < self.points.count; i++) {
    NKMPhysicalPoint *point = self.points[i];
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
#endif
@end
