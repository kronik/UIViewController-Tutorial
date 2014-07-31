//
//  UIViewController+Tutorial.m
//  UIViewController+Tutorial
//
//  Created by Dmitry Klimkin on 27/2/14.
//  Copyright (c) 2014 Dmitry Klimkin. All rights reserved.
//

#import "UIViewController+Tutorial.h"
#import "DKCircleImageView.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ApplicationMainColor                [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1]

@implementation UIViewController (Tutorial)

- (void)startNavigationTutorial {
    
    [self startTutorialWithInfo: NSLocalizedString(@"Swipe Right to go back", nil)
                        atPoint:CGPointMake(ScreenWidth / 2, ScreenHeight / 2 + 80)
   withFingerprintStartingPoint:CGPointMake(30, ScreenHeight / 2)
                    andEndPoint:CGPointMake(ScreenWidth / 2, ScreenHeight / 2)
           shouldHideBackground:YES];
}

- (void)startShowItemOptionsTutorial {
    
    [self startTutorialWithInfo:NSLocalizedString(@"Swipe Left to reveal options", nil)
                        atPoint:CGPointMake(ScreenWidth / 2, 250)
   withFingerprintStartingPoint:CGPointMake(ScreenWidth - 60, 30)
                    andEndPoint:CGPointMake(ScreenWidth - 200, 30)
           shouldHideBackground:NO];
}

- (void)startCreateNewItemTutorialWithInfo: (NSString *)infoText {
    
    [self startTutorialWithInfo:infoText
                        atPoint:CGPointMake(ScreenWidth / 2, 350)
   withFingerprintStartingPoint:CGPointMake(ScreenWidth / 2, 150)
                    andEndPoint:CGPointMake(ScreenWidth / 2, 300)
           shouldHideBackground:YES];
}

- (void)animateTapForView: (UIView *)view {
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [view.superview convertPoint:view.center fromView:view.superview];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = [UIColor whiteColor].CGColor;
    circleShape.lineWidth = 2.0;
    
    [view.superview.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [circleShape addAnimation:animation forKey:nil];
}

- (void)startTapTutorialWithInfo: (NSString *)infoText
                         atPoint: (CGPoint)infoPoint
            withFingerprintPoint: (CGPoint)touchPoint
            shouldHideBackground: (BOOL)hideBackground
                      completion: (UIViewControllerTutorialCompletionBlock)completion{
    
    NSString *tutorialKey = [NSString stringWithFormat:@"%@_%@_tutorial_%@", NSStringFromClass ([self class]), NSStringFromSelector(_cmd), infoText];
    
    BOOL wasShown = [[NSUserDefaults standardUserDefaults] boolForKey:tutorialKey];
    
    if (wasShown) {
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:tutorialKey];
    }
    
    UIView *tutorialView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    tutorialView.backgroundColor = [ApplicationMainColor colorWithAlphaComponent:hideBackground ? 1.0 : 0.2];
    tutorialView.alpha = 0.0;
    
    [self.view addSubview: tutorialView];
    
    DKCircleImageView *touchView = [[DKCircleImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    
    touchView.center = touchPoint;
    
    touchView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    [tutorialView addSubview: touchView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, ScreenHeight / 3)];
    
    infoLabel.font = [UIFont systemFontOfSize:30];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.center = infoPoint;
    infoLabel.text = infoText;
    
    [tutorialView addSubview: infoLabel];
    
    self.view.userInteractionEnabled = NO;
    
    __weak typeof(self) this = self;

    [UIView animateWithDuration:0.5 animations:^{
        tutorialView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [this animateTapForView:touchView];
        
        [UIView animateWithDuration:1.0 animations:^{
            touchView.alpha = 0.3;
        } completion:^(BOOL finished) {
            touchView.alpha = 1.0;

            [this animateTapForView:touchView];
            
            [UIView animateWithDuration:1.0 animations:^{
                touchView.alpha = 0.3;
            } completion:^(BOOL finished) {
                
                touchView.alpha = 1.0;
                
                [this animateTapForView:touchView];

                [UIView animateWithDuration:1.0 animations:^{
                    touchView.alpha = 0.0;
                    infoLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        tutorialView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        
                        [touchView removeFromSuperview];
                        [infoLabel removeFromSuperview];
                        [tutorialView removeFromSuperview];
                        
                        this.view.userInteractionEnabled = YES;
                        
                        if(completion){
                            completion();
                        }
                    }];
                }];
            }];
        }];
    }];
}

- (void)startTapTutorialWithInfo: (NSString *)infoText
                         atPoint: (CGPoint)infoPoint
            withFingerprintPoint: (CGPoint)touchPoint
            shouldHideBackground: (BOOL)hideBackground{
    [self startTapTutorialWithInfo:infoText atPoint:infoPoint withFingerprintPoint:touchPoint shouldHideBackground:hideBackground completion:NULL];
}

- (void)startTutorialWithInfo: (NSString *)infoText
                      atPoint: (CGPoint)infoPoint
 withFingerprintStartingPoint: (CGPoint)startPoint
                  andEndPoint: (CGPoint)endPoint
         shouldHideBackground: (BOOL)hideBackground
                   completion: (UIViewControllerTutorialCompletionBlock)completion{
    NSString *tutorialKey = [NSString stringWithFormat:@"%@_%@_tutorial_%@", NSStringFromClass ([self class]), NSStringFromSelector(_cmd), infoText];
    
    BOOL wasShown = [[NSUserDefaults standardUserDefaults] boolForKey:tutorialKey];
    
    if (wasShown) {
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:tutorialKey];
    }
    
    UIView *tutorialView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    tutorialView.backgroundColor = [ApplicationMainColor colorWithAlphaComponent:hideBackground ? 1.0 : 0.2];
    tutorialView.alpha = 0.0;
    
    [self.view addSubview: tutorialView];
    
    DKCircleImageView *touchView = [[DKCircleImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    touchView.center = startPoint;
    
    touchView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    [tutorialView addSubview: touchView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, ScreenHeight / 3)];
    
    infoLabel.font = [UIFont systemFontOfSize:30];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.center = infoPoint;
    infoLabel.text = infoText;
    
    [tutorialView addSubview: infoLabel];
    
    self.view.userInteractionEnabled = NO;
    
    __weak typeof(self) this = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        tutorialView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            touchView.center = endPoint;
            touchView.alpha = 0.3;
        } completion:^(BOOL finished) {
            
            touchView.center = startPoint;
            touchView.alpha = 1.0;
            
            [UIView animateWithDuration:1.5 animations:^{
                touchView.center = endPoint;
                touchView.alpha = 0.3;
            } completion:^(BOOL finished) {
                
                touchView.center = startPoint;
                touchView.alpha = 1.0;
                
                [UIView animateWithDuration:1.5 animations:^{
                    touchView.center = endPoint;
                    touchView.alpha = 0.0;
                    infoLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        tutorialView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        
                        [touchView removeFromSuperview];
                        [infoLabel removeFromSuperview];
                        [tutorialView removeFromSuperview];
                        
                        this.view.userInteractionEnabled = YES;
                        
                        if(completion){
                            completion();
                        }
                    }];
                }];
            }];
        }];
    }];
}

- (void)startTutorialWithInfo: (NSString *)infoText
                      atPoint: (CGPoint)infoPoint
 withFingerprintStartingPoint: (CGPoint)startPoint
                  andEndPoint: (CGPoint)endPoint
         shouldHideBackground: (BOOL)hideBackground {
    [self startTutorialWithInfo:infoText atPoint:infoPoint withFingerprintStartingPoint:startPoint andEndPoint:endPoint shouldHideBackground:hideBackground completion:NULL];
}

@end
