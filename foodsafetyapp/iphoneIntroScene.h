//
//  SKScene+iphoneIntroScene.h
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SoundManager.h"

@interface iphoneIntroScene : SKScene {
    
    float                   iphoneAddX;
    
    float                   primaryScale;
    
    SKSpriteNode            *back;
    
    BOOL                    touched;
    
}

@end
