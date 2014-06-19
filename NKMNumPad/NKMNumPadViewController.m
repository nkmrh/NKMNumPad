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
static const NSInteger kNKMNumPadRowMax = 5;

typedef struct {
    float Position[2];
    float Color[4];
    float TexCoord[2];
} Vertex;

Vertex vertices[] = {
    {{-1.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 1.0}},
    {{-0.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 1.0}},
    {{0.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 1.0}},
    {{1.5, 0.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 1.0}},
    
    {{-1.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.8}},
    {{-0.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 0.8}},
    {{0.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 0.8}},
    {{1.5, -0.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.8}},
    
    {{-1.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.6}},
    {{-0.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 0.6}},
    {{0.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 0.6}},
    {{1.5, -1.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.6}},
    
    {{-1.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.4}},
    {{-0.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 0.4}},
    {{0.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 0.4}},
    {{1.5, -2.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.4}},
    
    {{-1.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.2}},
    {{-0.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 0.2}},
    {{0.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 0.2}},
    {{1.5, -3.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.2}},
    
    {{-1.5, -4.5}, {0.0, 0.0, 0.0, 1.0}, {0.0, 0.0}},
    {{-0.5, -4.5}, {0.0, 0.0, 0.0, 1.0}, {0.333333, 0.0}},
    {{0.5, -4.5}, {0.0, 0.0, 0.0, 1.0}, {0.666666, 0.0}},
    {{1.5, -4.5}, {0.0, 0.0, 0.0, 1.0}, {1.0, 0.0}},
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
    
    20, 16, 17,
    20, 17, 21,
    21, 17, 18,
    21, 18, 22,
    22, 18, 19,
    22, 19, 23,
};

Vertex vertices2[] = {
    {{-1.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {0.0, 1.0}},
    {{-0.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {1.0, 1.0}},
    {{-1.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {0.0, 0.0}},
    {{-0.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {1.0, 0.0}},
};

GLubyte indices2[] = {
    2, 0, 1,
    2, 1, 3,
};

Vertex vertices3[] = {
    {{-1.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {0.0, 1.0}},
    {{-0.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {0.333333, 1.0}},
    {{0.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {0.666666, 1.0}},
    {{1.5, 0.5}, {1.0, 1.0, 1.0, 0.5}, {1.0, 1.0}},
    
    {{-1.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {0.0, 0.0}},
    {{-0.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {0.333333, 0.0}},
    {{0.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {0.666666, 0.0}},
    {{1.5, -0.5}, {1.0, 1.0, 1.0, 0.5}, {1.0, 0.0}},
};

GLubyte indices3[] = {
    4, 0, 1,
    4, 1, 5,
    5, 1, 2,
    5, 2, 6,
    6, 2, 3,
    6, 3, 7,
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
    
    GLuint _vertexBuffer3;
    GLuint _indexBuffer3;
    GLuint _vertexArray3;
}

@property(nonatomic) EAGLContext *context;
@property (nonatomic) GLKBaseEffect *effect;

@end

@implementation NKMNumPadViewController

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (void)_initializeInstanceVariables
{
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
    
    CGFloat red, green, blue, alpha;
    [_hilightColor getRed:&red green:&green blue:&blue alpha:&alpha];
    for (int i = 0; i < sizeof(vertices2) / sizeof(vertices2[0]); i++) {
        vertices2[i].Color[0] = red;
        vertices2[i].Color[1] = green;
        vertices2[i].Color[2] = blue;
        vertices2[i].Color[3] = alpha;
    }
    for (int i = 0; i < sizeof(vertices3) / sizeof(vertices3[0]); i++) {
        vertices3[i].Color[0] = red;
        vertices3[i].Color[1] = green;
        vertices3[i].Color[2] = blue;
        vertices3[i].Color[3] = alpha;
    }
}

//--------------------------------------------------------------//
#pragma mark -- View --
//--------------------------------------------------------------//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _clearColor = [UIColor clearColor];
    _hilightColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    _tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _initializeInstanceVariables];
    [self _setupGL];
    [self _registerNotifiactionObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self _tearDownGL];
}

//--------------------------------------------------------------//
#pragma mark -- Notification --
//--------------------------------------------------------------//

- (void)_registerNotifiactionObserver
{
    NSNotificationCenter*   center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(_didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)_didBecomeActive:(NSNotification*)notification
{
    for (NKMPhysicalPoint* point in _points) {
        [point initializeInstanceVariables];
    }
}

//--------------------------------------------------------------//
#pragma mark -- GLES --
//--------------------------------------------------------------//

- (void)_setupGL {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    [EAGLContext setCurrentContext:self.context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    view.delegate = self;
    
    self.preferredFramesPerSecond = 60;
    self.effect = [GLKBaseEffect new];
    self.effect.useConstantColor = GL_TRUE;

    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft,
                              nil];
    NSError * error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"4x3" ofType:@"png"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = GL_TRUE;
    
    CGFloat red, green, blue, alpha;
    [_tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.effect.constantColor = GLKVector4Make(red, green, blue, alpha);
    
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(CGRectGetMinX(self.view.bounds), CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds), CGRectGetMinY(self.view.bounds), -1.0f, 1.0f);
    
    [_clearColor getRed:&red green:&green blue:&blue alpha:&alpha];
    glClearColor(red, green, blue, alpha);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glGenVertexArraysOES(1, &_vertexArray2);
    glBindVertexArrayOES(_vertexArray2);
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glGenVertexArraysOES(1, &_vertexArray3);
    glBindVertexArrayOES(_vertexArray3);
    glGenBuffers(1, &_vertexBuffer3);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer3);
    glGenBuffers(1, &_indexBuffer3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer3);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
}

- (void)_tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);

    glDeleteBuffers(1, &_vertexBuffer2);
    glDeleteBuffers(1, &_indexBuffer2);
    glDeleteVertexArraysOES(1, &_vertexArray2);
    
    glDeleteBuffers(1, &_vertexBuffer3);
    glDeleteBuffers(1, &_indexBuffer3);
    glDeleteVertexArraysOES(1, &_vertexArray3);
    
    self.effect = nil;
}

//--------------------------------------------------------------//
#pragma mark -- Touch --
//--------------------------------------------------------------//

- (NSIndexPath*)_indexPathForTouchedPoint:(CGPoint)point
{
    CGFloat tx, ty;
    tx = point.x;
    ty = point.y;
    
    NSInteger row, col;
    row = -1;
    col = -1;
    
    /// row ///
    
    // For row 0
    if (((NKMPhysicalPoint*)_points[0]).position.y < ty &&
        ((NKMPhysicalPoint*)_points[4]).position.y > ty) {
        row = 0;
    }
    // For row 1
    else if (((NKMPhysicalPoint*)_points[4]).position.y < ty &&
             ((NKMPhysicalPoint*)_points[8]).position.y > ty) {
        row = 1;
    }
    // For row 2
    else if (((NKMPhysicalPoint*)_points[8]).position.y < ty &&
             ((NKMPhysicalPoint*)_points[12]).position.y > ty) {
        row = 2;
    }
    // For row 3
    else if (((NKMPhysicalPoint*)_points[12]).position.y < ty &&
             ((NKMPhysicalPoint*)_points[16]).position.y > ty) {
        row = 3;
    }
    // For row 4
    else if (((NKMPhysicalPoint*)_points[16]).position.y < ty &&
             ((NKMPhysicalPoint*)_points[20]).position.y > ty) {
        row = 4;
    }
    
    /// colum ///
    
    // For colum 0
    if (((NKMPhysicalPoint*)_points[0]).position.x < tx &&
        ((NKMPhysicalPoint*)_points[1]).position.x > tx) {
        col = 0;
    }
    // For colum 1
    else if (((NKMPhysicalPoint*)_points[1]).position.x < tx &&
             ((NKMPhysicalPoint*)_points[2]).position.x > tx) {
        col = 1;
    }
    // For colum 2
    else if (((NKMPhysicalPoint*)_points[2]).position.x < tx &&
             ((NKMPhysicalPoint*)_points[3]).position.x > tx) {
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
    _hilightedIndexPath = [self _indexPathForTouchedPoint:_touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self.view];
    _hilightedIndexPath = [self _indexPathForTouchedPoint:_touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([(id)self.touchDelegate respondsToSelector:@selector(numPadViewControllerDidTouch:)]) {
        [self.touchDelegate numPadViewControllerDidTouch:_hilightedIndexPath];
    }
    
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);
    _hilightedIndexPath = [self _indexPathForTouchedPoint:_touchPoint];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = CGPointMake(FLT_MAX, FLT_MAX);
    _hilightedIndexPath = [self _indexPathForTouchedPoint:_touchPoint];
}

//--------------------------------------------------------------//
#pragma mark -- GLKViewControllerDelegate --
//--------------------------------------------------------------//

- (void)update
{
    // Update physical points
    for (int i = 0; i < _points.count; i++) {
        NKMPhysicalPoint *point = _points[i];
        
        CGPoint position = point.position;
        CGPoint location = [_locations[i] CGPointValue];
        [point configureAccelerationXvalue:(location.x - position.x) * 400
                                    Yvalue:(location.y - position.y) * 400];
        
        CGFloat maxDist = 105.0f;
        CGFloat dist = DistanceBetweenTwoPoints(position, _touchPoint);
        
        if (dist < maxDist) {
            CGFloat par = (maxDist - dist) / maxDist;
            [point
             configureAccelerationXvalue:(position.x - _touchPoint.x) * par * 200
             Yvalue:(position.y - _touchPoint.y) * par * 200];
        }
        
        [point updateWithInterval:self.timeSinceLastUpdate];
    }
    
    // Update vertices1
    for (int i = 0; i < sizeof(vertices) / sizeof(vertices[0]); i++) {
        NKMPhysicalPoint *point = _points[i];
        vertices[i].Position[0] = point.position.x;
        vertices[i].Position[1] = point.position.y;
    }

    // Update vertices2, vertex3
    if (nil == _hilightedIndexPath) {
        for (int i = 0; i < sizeof(vertices3) / sizeof(vertices3[0]); i++) {
            vertices3[i].Position[0] = 0.0f;
            vertices3[i].Position[1] = 0.0f;
        }
        for (int i = 0; i < sizeof(vertices2) / sizeof(vertices2[0]); i++) {
            vertices2[i].Position[0] = 0.0f;
            vertices2[i].Position[1] = 0.0f;
        }
    }
    else if (4 == _hilightedIndexPath.row) {
        for (int i = 0; i < sizeof(vertices3) / sizeof(vertices3[0]); i++) {
            vertices3[i].Position[0] = ((NKMPhysicalPoint*)_points[16 + i]).position.x;
            vertices3[i].Position[1] = ((NKMPhysicalPoint*)_points[16 + i]).position.y;
        }
        for (int i = 0; i < sizeof(vertices2) / sizeof(vertices2[0]); i++) {
            vertices2[i].Position[0] = 0.0f;
            vertices2[i].Position[1] = 0.0f;
        }
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
        
        for (int i = 0; i < sizeof(vertices3) / sizeof(vertices3[0]); i++) {
            vertices3[i].Position[0] = 0.0f;
            vertices3[i].Position[1] = 0.0f;
        }
    }
}

//--------------------------------------------------------------//
#pragma mark -- GLKViewDelegate --
//--------------------------------------------------------------//

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // ----------------------------------------------------------------------
    
    self.effect.texture2d0.enabled = GL_FALSE;
    [self.effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    // ----------------------------------------------------------------------
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices2), vertices2, GL_DYNAMIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices2), indices2, GL_DYNAMIC_DRAW);
    glDrawElements(GL_TRIANGLES , sizeof(indices2)/sizeof(indices2[0]), GL_UNSIGNED_BYTE , 0);
    
    // ----------------------------------------------------------------------
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices3), vertices3, GL_DYNAMIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices3), indices3, GL_DYNAMIC_DRAW);
    glDrawElements(GL_TRIANGLES , sizeof(indices3)/sizeof(indices3[0]), GL_UNSIGNED_BYTE , 0);
    
    // ----------------------------------------------------------------------
    
    self.effect.texture2d0.enabled = GL_TRUE;
    [self.effect prepareToDraw];
    
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_DYNAMIC_DRAW);
    glDrawElements(GL_TRIANGLES , sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE , 0);
}

@end
