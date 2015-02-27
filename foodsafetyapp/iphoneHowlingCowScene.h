//
//  iphoneHowlingCowScene.h
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKButtonNodeJRTB.h"

@interface iphoneHowlingCowScene : SKScene <SKButtonNodeJRTBDelegate,  UIGestureRecognizerDelegate> {
    
    float                   iphoneAddY;
    float                   iphoneAddX;
    
    float                   primaryScale;
    
    SKSpriteNode            *back;
    
    BOOL                    touched;
    
    BOOL                    videoReady;
    
    float                   videoLength;
    
    SKButtonNodeJRTB        *playButton;
    
    SKButtonNodeJRTB        *menuButton;
    SKButtonNodeJRTB        *backButton;
    SKButtonNodeJRTB        *navBackButton;
    
    SKSpriteNode            *overlay;
    
    SKEffectNode            *solarSystem;
    
    UIImage                 *screenshot;
    SKSpriteNode            *screenshotView;
    
    BOOL                    menuOut;
        
    SKSpriteNode            *top;
}

@end
