//
//  iphoneIntroScene.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "iphoneIntroScene.h"

#import "AppDelegate.h"
#import "GameViewController.h"


@implementation iphoneIntroScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        touched = NO;
        
        self.backgroundColor = [SKColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        // primary scale is used to scale assets such that only one 4x iPad Retina asset needs to be included in the binary
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            primaryScale = 0.5;
        } else {
            primaryScale = 0.25;
        }
        
        if (IS_IPHONE5W || IS_IPHONE5H) {
            iphoneAddX = 44.0;
            back = [SKSpriteNode spriteNodeWithImageNamed:@"intro"];
        }
        else {
            iphoneAddX = 0.0;
            back = [SKSpriteNode spriteNodeWithImageNamed:@"intro"];
        }
        
        back.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:back];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!touched) {
        
        touched = YES;
        
        [self start];
        
    }
}

- (void) start
{
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    [vc setScreenToggle:MENU];
    
    [self clean];
    
    [vc replaceTheScene];
}

- (void) clean
{
    
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode* child = obj;
        [child removeAllActions];
        [child removeAllChildren];
    }];
    
    [self removeAllActions];
    [self removeAllChildren];
    
}

- (void)dealloc {
    
    printf("intro scene dealloc\n");
}

@end
