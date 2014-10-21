//
//  iphoneMenuScene.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "iphoneMenuScene.h"

#import "AppDelegate.h"
#import "GameViewController.h"

@implementation iphoneMenuScene

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
        
        /*
         IS_IPHONE_4 480
         IS_IPHONE_5 568
         IS_IPHONE_6 667
         IS_IPHONE_6_PLUS 736
         */
        
        if (IS_IPHONE_4)
            iphoneAddY = (480.0-568.0)/2.0;
        if (IS_IPHONE_5)
            iphoneAddY = (568-568.0)/2.0;
        if (IS_IPHONE_6)
            iphoneAddY = (667-568.0)/2.0;
        if (IS_IPHONE_6_PLUS)
            iphoneAddY = (736-568.0)/2.0;
        
        printf("iphoneAddY: %f\n",iphoneAddY);
        
        SKButtonNodeJRTB *button_01 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"menu_button"];
        [button_01 initButton];
        button_01.name = @"menu";
        button_01.delegate = self;
        button_01.scale = primaryScale;
        button_01.position = CGPointMake(22.0,self.size.height-22.0);
        [self addChild:button_01];

        float spacing = 6.0;
        
        SKButtonNodeJRTB *button_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_01"];
        [button_02 initButton];
        button_02.name = @"01";
        button_02.delegate = self;
        button_02.position = CGPointMake(self.size.width/2.0-button_02.size.width/2.0-spacing/2.0,button_02.size.height/2.0+button_02.size.height*1.0+spacing*2.0+iphoneAddY/2.0);
        [self addChild:button_02];

        SKButtonNodeJRTB *button_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_02"];
        [button_03 initButton];
        button_03.name = @"02";
        button_03.delegate = self;
        button_03.position = CGPointMake(self.size.width/2.0+button_02.size.width/2.0+spacing/2.0,button_02.size.height/2.0+button_02.size.height*1.0+spacing*2.0+iphoneAddY/2.0);
        [self addChild:button_03];

        SKButtonNodeJRTB *button_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_03"];
        [button_04 initButton];
        button_04.name = @"03";
        button_04.delegate = self;
        button_04.position = CGPointMake(self.size.width/2.0-button_02.size.width/2.0-spacing/2.0,button_02.size.height/2.0+button_02.size.height*0.0+spacing*1.0+iphoneAddY/2.0);
        [self addChild:button_04];

        SKButtonNodeJRTB *button_05 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_04"];
        [button_05 initButton];
        button_05.name = @"04";
        button_05.delegate = self;
        button_05.position = CGPointMake(self.size.width/2.0+button_02.size.width/2.0+spacing/2.0,button_02.size.height/2.0+button_02.size.height*0.0+spacing*1.0+iphoneAddY/2.0);
        [self addChild:button_05];

        SKLabelNode *aLetter = [SKLabelNode labelNodeWithFontNamed:@"Univers LT Std 57 Condensed"];
        aLetter.position = CGPointMake(self.size.width*.5, button_05.position.y+button_05.size.height*1.5+iphoneAddY);
        aLetter.text = @"Food Safety and HACCP";
        aLetter.fontSize = 52.0;
        aLetter.scale = primaryScale;
        aLetter.zPosition = 1;
        aLetter.fontColor = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        aLetter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        aLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [self addChild:aLetter];

        SKSpriteNode *video1 = [SKSpriteNode spriteNodeWithImageNamed:@"hyperspace_firstframe"];
        video1.alpha = 0.0;
        video1.position = CGPointMake(self.size.width*.5,self.size.height*.5);
        video1.size = self.frame.size;
        [self addChild: video1];
        [video1 runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];

        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void) buttonPushed: (SKButtonNodeJRTB *) sender {
    
    if ([sender.name isEqualToString:@"menu"]) {
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        //[vc setScreenToggle:GAME_03];
        
        //[self clean];
        
        //[vc replaceTheScene];
        
        printf("menu button pressed\n");
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!touched) {
        
        touched = YES;
        
    }
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
    
    printf("menu scene dealloc\n");
}

@end
