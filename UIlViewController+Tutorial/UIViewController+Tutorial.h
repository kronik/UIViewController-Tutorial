//
//  UIViewController+Tutorial.h
//  UIViewController+Tutorial
//
//  Created by Dmitry Klimkin on 27/2/14.
//  Copyright (c) 2014 Dmitry Klimkin. All rights reserved.
//

@import UIKit;

typedef void(^UIViewControllerTutorialCompletionBlock)();

@interface UIViewController (Tutorial)

- (void)animateTapForView: (UIView *)view;

- (void)startNavigationTutorial;
- (void)startShowItemOptionsTutorial;
- (void)startCreateNewItemTutorialWithInfo: (NSString *)infoText;

- (void)startTutorialWithInfo: (NSString *)infoText
                      atPoint: (CGPoint)infoPoint
 withFingerprintStartingPoint: (CGPoint)startPoint
                  andEndPoint: (CGPoint)endPoint
         shouldHideBackground: (BOOL)hideBackground;

- (void)startTutorialWithInfo: (NSString *)infoText
                      atPoint: (CGPoint)infoPoint
 withFingerprintStartingPoint: (CGPoint)startPoint
                  andEndPoint: (CGPoint)endPoint
         shouldHideBackground: (BOOL)hideBackground
                   completion: (UIViewControllerTutorialCompletionBlock)completion;

- (void)startTapTutorialWithInfo: (NSString *)infoText
                         atPoint: (CGPoint)infoPoint
            withFingerprintPoint: (CGPoint)touchPoint
            shouldHideBackground: (BOOL)hideBackground;

- (void)startTapTutorialWithInfo: (NSString *)infoText
                         atPoint: (CGPoint)infoPoint
            withFingerprintPoint: (CGPoint)touchPoint
            shouldHideBackground: (BOOL)hideBackground
                      completion: (UIViewControllerTutorialCompletionBlock)completion;

@end
