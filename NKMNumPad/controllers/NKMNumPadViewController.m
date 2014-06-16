//
//  NKMNumPadViewController.m
//  
//
//  Created by hajime-nakamura on 6/11/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

#import "NKMNumPadViewController.h"
#import "NKMPhysicalPoint.h"

static const NSInteger kNKMNumPadColumnMax = 3;
static const NSInteger kNKMNumPadRowMax = 4;

typedef struct {
    float Position[2];
    float Color[4];
    float TexCoord[2];
} Vertex;

Vertex vertices[] = {
    {{-1.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 1.0}},
    {{-0.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.3, 1.0}},
    {{0.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.6, 1.0}},
    {{1.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 1.0}},
    
    {{-1.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.75}},
    {{-0.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.3, 0.75}},
    {{0.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.6, 0.75}},
    {{1.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.75}},
    
    {{-1.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.5}},
    {{-0.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.3, 0.5}},
    {{0.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.6, 0.5}},
    {{1.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.5}},
    
    {{-1.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.25}},
    {{-0.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.3, 0.25}},
    {{0.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.6, 0.25}},
    {{1.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.25}},
    
    {{-1.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.0}},
    {{-0.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.3, 0.0}},
    {{0.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.6, 0.0}},
    {{1.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.0}},
};

GLubyte indices[] = {
    4, 0, 1,
    4, 1, 5,
    5, 1, 2,
    5, 2, 6,
    6, 2, 3,
    6, 3, 7,
    
    8, 4, 5,
    8, 5, 9,
    9, 5, 6,
    9, 6, 10,
    10, 6, 7,
    10, 7, 11,
    
    12, 8, 9,
    12, 9, 13,
    13, 9, 10,
    13, 10, 14,
    14, 10, 11,
    14, 11, 15,
    
    16, 12, 13,
    16, 13, 17,
    17, 13, 14,
    17, 14, 18,
    18, 14, 15,
    18, 15, 19,
};

Vertex vertices2[] = {
    {{-1.5, 0.5}, {1.0, 0.0, 0.0, 0.5}, {0.0, 1.0}},
    {{-0.5, 0.5}, {1.0, 0.0, 0.0, 0.5}, {0.3, 1.0}},
    {{-1.5, -0.5}, {1.0, 0.0, 0.0, 0.5}, {0.0, 0.75}},
    {{-0.5, -0.5}, {1.0, 0.0, 0.0, 0.5}, {0.3, 0.75}},
};

GLubyte indices2[] = {
    2, 0, 1,
    2, 1, 3,
};

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
  CGFloat dx = point2.x - point1.x;
  CGFloat dy = point2.y - point1.y;
  return sqrt(dx * dx + dy * dy);
};

@interface NKMNumPadViewController ()
{
  NSMutableArray *_points;
  NSMutableArray *_locations;
  CGPoint _touchPoint;
    NSIndexPath *_hilightedIndexPath;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    GLuint _vertexArray;
    
    GLuint _vertexBuffer2;
    GLuint _indexBuffer2;
    GLuint _vertexArray2;
}

@property(nonatomic) EAGLContext *context;
@property (nonatomic) GLKBaseEffect *effect;

@end

@implementation NKMNumPadViewController

//--------------------------------------------------------------//
#pragma mark -- View --
//--------------------------------------------------------------//

- (void)viewDidLoad {
  [super viewDidLoad];
    
    [self setupGL];

  _points = [NSMutableArray new];
  _locations = [NSMutableArray new];
  _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);

  const CGFloat intervalX = CGRectGetWidth(self.view.bounds) / kNKMNumPadColumnMax;
  const CGFloat intervalY = CGRectGetHeight(self.view.bounds) / kNKMNumPadRowMax;
  const NSInteger col = kNKMNumPadColumnMax + 1;
  const NSInteger row = kNKMNumPadRowMax + 1;
    
  for (int i = 0; i < row; i++) {
    for (int j = 0; j < col; j++) {
      CGPoint location;
      location.x = CGRectGetWidth(self.view.bounds) * 0.5 -
                   (col - 1) * 0.5 * intervalX + j * intervalX;
      location.y = CGRectGetHeight(self.view.bounds) * 0.5 -
                   (row - 1) * 0.5 * intervalY + i * intervalY;

      [_points addObject:[[NKMPhysicalPoint alloc] initWithPoint:location]];
      [_locations addObject:[NSValue valueWithCGPoint:location]];
    }
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self tearDownGL];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

//--------------------------------------------------------------//
#pragma mark -- GL --
//--------------------------------------------------------------//

- (void)setupGL {
    self.preferredFramesPerSecond = 60;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    [EAGLContext setCurrentContext:self.context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    view.delegate = self;
    
    self.effect = [GLKBaseEffect new];
    self.effect.useConstantColor = GL_FALSE;
    
#if 0
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft,
                              nil];
    NSError * error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"4x4grid" ofType:@"png"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = GL_TRUE;
#endif
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(CGRectGetMinX(self.view.bounds), CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds), CGRectGetMinY(self.view.bounds), -1.0f, 1.0f);
    
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);

    glDeleteBuffers(1, &_vertexBuffer2);
    glDeleteBuffers(1, &_indexBuffer2);
    glDeleteVertexArraysOES(1, &_vertexArray2);
    
    self.effect = nil;
}

//--------------------------------------------------------------//
#pragma mark -- Touch --
//--------------------------------------------------------------//

- (NSIndexPath*)_indexPathFortouchedPoint:(CGPoint)point
{
    CGFloat tx, ty;
    tx = point.x;
    ty = point.y;
    
    NSInteger row, col;
    row = -1;
    col = -1;
    
    ///
    /// row
    ///
    
    // For row 0
    if ([_locations[0] CGPointValue].y < ty && [_locations[4] CGPointValue].y > ty &&
        [_locations[0] CGPointValue].y < ty && [_locations[4] CGPointValue].y > ty) {
        row = 0;
    }
    // For row 1
    else if ([_locations[4] CGPointValue].y < ty && [_locations[8] CGPointValue].y > ty &&
             [_locations[4] CGPointValue].y < ty && [_locations[8] CGPointValue].y > ty) {
        row = 1;
        
    }
    // For row 2
    else if ([_locations[8] CGPointValue].y < ty && [_locations[12] CGPointValue].y > ty &&
             [_locations[8] CGPointValue].y < ty && [_locations[12] CGPointValue].y > ty) {
        row = 2;
    }
    // For row 3
    else if ([_locations[12] CGPointValue].y < ty && [_locations[16] CGPointValue].y > ty &&
             [_locations[12] CGPointValue].y < ty && [_locations[16] CGPointValue].y > ty) {
        row = 3;
    }
    
    ///
    /// colum
    ///
    
    // For colum 0
    if ([_locations[0] CGPointValue].x < tx && [_locations[1] CGPointValue].x > tx &&
        [_locations[0] CGPointValue].x < tx && [_locations[1] CGPointValue].x > tx) {
        col = 0;
    }
    // For colum 1
    else if ([_locations[1] CGPointValue].x < tx && [_locations[2] CGPointValue].x > tx &&
             [_locations[1] CGPointValue].x < tx && [_locations[2] CGPointValue].x > tx) {
        col = 1;
        
    }
    // For colum 2
    else if ([_locations[2] CGPointValue].x < tx && [_locations[3] CGPointValue].x > tx &&
             [_locations[2] CGPointValue].x < tx && [_locations[3] CGPointValue].x > tx) {
        col = 2;
    }
    
    NSIndexPath *indexPath = nil;
    if (-1 != row && -1 != col) {
        indexPath= [NSIndexPath indexPathForRow:row inSection:col];
    }
    
    return indexPath;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self.view];
    _hilightedIndexPath = [self _indexPathFortouchedPoint:_touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self.view];
    _hilightedIndexPath = [self _indexPathFortouchedPoint:_touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);
    _hilightedIndexPath = [self _indexPathFortouchedPoint:_touchPoint];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);
    _hilightedIndexPath = [self _indexPathFortouchedPoint:_touchPoint];
}

//--------------------------------------------------------------//
#pragma mark -- GLKViewControllerDelegate --
//--------------------------------------------------------------//

- (void)update
{
    for (int i = 0; i < _points.count; i++) {
        NKMPhysicalPoint *point = _points[i];
        
        CGPoint position = point.position;
        CGPoint location = [_locations[i] CGPointValue];
        
        [point configureAccelerationXvalue:(location.x - position.x) * 300
                                    Yvalue:(location.y - position.y) * 300];
        
        CGFloat maxDist = 120.0f;
        CGFloat dist = DistanceBetweenTwoPoints(position, _touchPoint);
        
        if (dist < maxDist) {
            CGFloat par = (maxDist - dist) / maxDist;
            [point
             configureAccelerationXvalue:(position.x - _touchPoint.x) * par * 300
             Yvalue:(position.y - _touchPoint.y) * par * 300];
        }
    }
    
    // Update vertices1
    for (int i = 0; i < _points.count; i++) {
        NKMPhysicalPoint *point = _points[i];
        vertices[i].Position[0] = point.position.x;
        vertices[i].Position[1] = point.position.y;
    }

    // Update vertices2
    if (nil == _hilightedIndexPath) {
        vertices2[0].Position[1] = 0.0f;
        vertices2[1].Position[1] = 0.0f;
        vertices2[2].Position[1] = 0.0f;
        vertices2[3].Position[1] = 0.0f;
        
        vertices2[0].Position[0] = 0.0f;
        vertices2[1].Position[0] = 0.0f;
        vertices2[2].Position[0] = 0.0f;
        vertices2[3].Position[0] = 0.0f;
    }
    else {
        NSInteger row1, row2, col1, col2;
        row1 = _hilightedIndexPath.row * 4;
        row2 = (_hilightedIndexPath.row * 4) + 4;
        col1 = _hilightedIndexPath.section;
        col2 = _hilightedIndexPath.section + 1;

        vertices2[0].Position[0] = ((NKMPhysicalPoint*)_points[col1 + row1]).position.x;
        vertices2[0].Position[1] = ((NKMPhysicalPoint*)_points[col1 + row1]).position.y;
        vertices2[1].Position[0] = ((NKMPhysicalPoint*)_points[col2 + row1]).position.x;
        vertices2[1].Position[1] = ((NKMPhysicalPoint*)_points[col2 + row1]).position.y;
        vertices2[2].Position[0] = ((NKMPhysicalPoint*)_points[col1 + row2]).position.x;
        vertices2[2].Position[1] = ((NKMPhysicalPoint*)_points[col1 + row2]).position.y;
        vertices2[3].Position[0] = ((NKMPhysicalPoint*)_points[col2 + row2]).position.x;
        vertices2[3].Position[1] = ((NKMPhysicalPoint*)_points[col2 + row2]).position.y;
    }
}

//--------------------------------------------------------------//
#pragma mark -- GLKViewDelegate --
//--------------------------------------------------------------//

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
#if 0
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
#endif
    
    [self.effect prepareToDraw];
    
//    glDrawElements(GL_TRIANGLES , sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE , 0);
    glDrawElements(GL_LINE_STRIP , sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE , 0);
    
    
    glDeleteBuffers(2, &_vertexBuffer2);
    glDeleteBuffers(2, &_indexBuffer2);
    glDeleteVertexArraysOES(2, &_vertexArray2);
    
    glGenVertexArraysOES(2, &_vertexArray2);
    glBindVertexArrayOES(_vertexArray2);
    
    glGenBuffers(2, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices2), vertices2, GL_DYNAMIC_DRAW);
    
    glGenBuffers(2, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices2), indices2, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDrawElements(GL_TRIANGLES , sizeof(indices2)/sizeof(indices2[0]), GL_UNSIGNED_BYTE , 0);
//    glDrawElements(GL_LINE_STRIP , sizeof(indices2)/sizeof(indices2[0]), GL_UNSIGNED_BYTE , 0);
}

@end
