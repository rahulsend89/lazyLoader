//
//  LazyLoader.m
//  lazyLoader
//
//  Created by Malik, Rahul (US - Mumbai) on 5/14/15.
//  Copyright (c) 2015 Malik, Rahul (US - Mumbai). All rights reserved.
//

#import "LazyLoader.h"
CGFloat const spaceFromFrame = 1.0f;
CGFloat const easeConst = 0.025;
CGFloat const FPS = 1/60.f;
@interface LazyLoader()
@property (nonatomic,strong)UIColor *color;
@property (nonatomic)CGFloat startAngle;
@property (nonatomic)CGFloat rotation;
@property (nonatomic)CGFloat endAngle;
@property (nonatomic)CGFloat strokeWidth;
@property (nonatomic)CGFloat duration;
@property (nonatomic)CGFloat startVarianValue;
@property (nonatomic)CGFloat varianValue;
@property (nonatomic)CGFloat endVarianValue;
@property (nonatomic)NSTimer *myTimer;
@property (nonatomic)CGFloat multiValue;
@property (nonatomic)CGFloat easeFraction;
@property (nonatomic)BOOL animationStarted;
@property (nonatomic)BOOL flipGlich;
@property (nonatomic)int deltaStart;
@property (nonatomic)int deltaEnd;
@property (nonatomic)BOOL flipX;
@end
@implementation LazyLoader

-(void)initVariable{
    [self setBackgroundColor:[UIColor clearColor]];
    self.animationStarted = YES;
    self.color = [UIColor blackColor];
    self.startAngle = 0.0f;
    self.endAngle = 1.0f;
    self.strokeWidth = self.frame.size.width/10;
    self.duration = 1.0;
    self.varianValue = 1.0;
    self.flipX = NO;
    self.multiValue = 1.0+easeConst;
    self.easeFraction = easeConst;
    self.flipGlich = NO;
    self.startVarianValue = self.varianValue;
    self.endVarianValue = 0;
    self.deltaStart = 0;
    self.deltaEnd = 1;
    self.rotation = 90;
    self.transform = CGAffineTransformMakeScale((self.flipX?-1.0:1.0), 1.0);
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:FPS
                                     target:self
                                   selector:@selector(animatioFunc)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)animatioFunc{
    self.rotation-=self.varianValue;
    self.startAngle -= self.startVarianValue;
    self.endAngle -= self.endVarianValue;
    self.startVarianValue*=self.multiValue;
    self.endVarianValue*=(self.multiValue-(self.easeFraction*2));
    if(self.startAngle<=0.0f){
        self.startAngle = 360.0f;
        self.endVarianValue = self.startVarianValue;
        self.startVarianValue = 0;
    }
    if(self.endAngle<=0.0f){
        self.flipGlich = YES;
        self.endAngle = 360.0f;
        self.startVarianValue = self.varianValue;
        self.endVarianValue = 0;
    }
    [self setNeedsDisplay];
}
- (void)drawLoaderWithFrame: (CGRect)frame startAngle: (CGFloat)startAngle endAngle: (CGFloat)endAngle strokeWidth: (CGFloat)strokeWidth rotation: (CGFloat)rotation;
{
    //// General Declarations
    CGRect mainRect = CGRectMake(CGRectGetMinX(frame)+spaceFromFrame*(self.strokeWidth), CGRectGetMinY(frame)+spaceFromFrame*(self.strokeWidth), CGRectGetWidth(frame)-spaceFromFrame*2*(self.strokeWidth), CGRectGetHeight(frame)-spaceFromFrame*2*(self.strokeWidth));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Arc Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(frame)+spaceFromFrame*(self.strokeWidth) + mainRect.size.width/2, CGRectGetMinY(frame)+spaceFromFrame*(self.strokeWidth) + mainRect.size.height/2);
    CGContextRotateCTM(context, -rotation * M_PI / 180);
    CGRect ovalRect = CGRectMake(-mainRect.size.width/2, -mainRect.size.height/2, mainRect.size.width, mainRect.size.height);
    UIBezierPath* ovalPath = UIBezierPath.bezierPath;
    [ovalPath addArcWithCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)) radius: CGRectGetWidth(ovalRect) / 2 startAngle: -startAngle * M_PI/180 endAngle: -endAngle * M_PI/180 clockwise: YES];
    ovalPath.lineCapStyle = kCGLineCapRound;
    ovalPath.lineJoinStyle = kCGLineJoinRound;
    [self.color setStroke];
    ovalPath.lineWidth = strokeWidth;
    [ovalPath stroke];
    
    CGContextRestoreGState(context);
}


-(void)dealloc{
    [self.myTimer invalidate];
    self.myTimer = nil;
}
-(void)drawRect:(CGRect)rect{
    if(!self.animationStarted){
        [self initVariable];
    }else{
        if(self.flipGlich){
            [self drawLoaderWithFrame:rect startAngle:0.0 endAngle:1.0 strokeWidth:self.strokeWidth rotation:0.0];
            self.flipGlich = NO;
        }
        [self drawLoaderWithFrame:rect startAngle:self.startAngle endAngle:self.endAngle strokeWidth:self.strokeWidth rotation:self.rotation];
    }
    [super drawRect:rect];
}
@end
