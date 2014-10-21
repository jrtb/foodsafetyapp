//
//  SKButtonNodeJRTB.m
//  grandpainspace
//
//  Created by jrtb on 10/28/13.
//  Copyright (c) 2013 Fairlady Media, Inc. All rights reserved.
//

#import "SKButtonNodeJRTB.h"
#import "AppDelegate.h"

#import "SoundManager.h"

@implementation SKButtonNodeJRTB

@synthesize enabled;

- (void)initButton {
    
    //printf("button initing\n");
    
    self.userInteractionEnabled = YES;
    
    normalImage = @"";
    clickImage = @"";
    
    enabled = YES;
    
}

- (void)setNormalImage :(NSString*)withThisImage
{
    normalImage = withThisImage;
}

- (void)setClickImage :(NSString*)withThisImage
{
    clickImage = withThisImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (enabled) {
        
        UITouch* touch = [touches anyObject];
        CGPoint loc = [touch locationInNode:self.parent];
        
        //printf("touch at %f,%f\n",loc.x,loc.y);
        
        if ([self containsPoint:loc]) {
            
            if (![clickImage isEqualToString:@""]) {
                self.texture = [SKTexture textureWithImageNamed:clickImage];
            } else {
                self.colorBlendFactor = 1.0;
                self.color = [SKColor grayColor];
            }
            
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (enabled) {
        
        UITouch* touch = [touches anyObject];
        CGPoint loc = [touch locationInNode:self.parent];
        
        //printf("touch at %f,%f\n",loc.x,loc.y);
        
        if ([self containsPoint:loc]) {
            
            if (![normalImage isEqualToString:@""]) {
                self.texture = [SKTexture textureWithImageNamed:normalImage];
            } else {
                self.colorBlendFactor = 0.0;
            }
            
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (enabled) {

        UITouch* touch = [touches anyObject];
        CGPoint loc = [touch locationInNode:self.parent];
        
        //printf("touch at %f,%f\n",loc.x,loc.y);
        
        BOOL letGoOnButton = NO;
        
        if ([self containsPoint:loc]) {
            
            letGoOnButton = YES;
            
            [self buttonTouched];
            
        }
        
        if (!letGoOnButton) {
            if (![normalImage isEqualToString:@""]) {
                self.texture = [SKTexture textureWithImageNamed:normalImage];
            } else {
                self.colorBlendFactor = 0.0;
            }
        }
    }
    
}

- (void) buttonTouched
{
    [[SoundManager sharedManager] playSound:@"click2.caf"];
    
    SKAction *wait = [SKAction waitForDuration:0.0];
    SKAction *go = [SKAction runBlock:^{
        if (![normalImage isEqualToString:@""]) {
            self.texture = [SKTexture textureWithImageNamed:normalImage];
        } else {
            self.colorBlendFactor = 0.0;
        }
        [self.delegate buttonPushed:self];
    }];
    [self runAction:[SKAction sequence:@[wait,go]]];
    
}

- (void) dealloc
{
	//printf("deallocing Button\n");
	
	//[self stopAllActions];
	//[self removeAllChildrenWithCleanup:YES];
	
	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
