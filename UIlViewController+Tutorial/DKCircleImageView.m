//
//  DKCircleImageView.m
//  DKCircleImageView
//
//  Created by Dmitry Klimkin on 28/2/14.
//  Copyright (c) 2014 Dmitry Klimkin. All rights reserved.
//

#import "DKCircleImageView.h"

#define DKCircleImageViewBorderWidth 3.0f

@implementation DKCircleImageView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMaskToBounds:self.bounds];
}

- (void)updateMaskToBounds:(CGRect)maskBounds {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    
    maskLayer.bounds = maskBounds;
    maskLayer.path = maskPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
    self.layer.cornerRadius = CGRectGetHeight(maskBounds) / 2.0;
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    self.layer.borderWidth = DKCircleImageViewBorderWidth;
    
    [self.layer setMask:maskLayer];
}

@end
