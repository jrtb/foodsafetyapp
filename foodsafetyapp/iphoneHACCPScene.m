//
//  iphoneHACCPScene.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "iphoneHACCPScene.h"

#import "AppDelegate.h"
#import "GameViewController.h"

#import "UIImage+ImageEffects.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation iphoneHACCPScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        touched = NO;
        menuOut = NO;
        
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
        
        if (IS_IPHONE_4) {
            iphoneAddY = (480.0-568.0)/2.0;
            iphoneAddX = (320.0-320.0)/2.0;
        }
        if (IS_IPHONE_5) {
            iphoneAddY = (568-568.0)/2.0;
            iphoneAddX = (320.0-320.0)/2.0;
        }
        if (IS_IPHONE_6) {
            iphoneAddY = (667-568.0)/2.0;
            iphoneAddX = (375.0-320.0)/2.0;
        }
        if (IS_IPHONE_6_PLUS) {
            iphoneAddY = (736-568.0)/2.0;
            iphoneAddX = (414.0-320.0)/2.0;
        }
        
        printf("iphoneAddY: %f\n",iphoneAddY);
        
        solarSystem = [[SKEffectNode alloc] init];
        solarSystem.position = CGPointMake(0.0,0.0);
        [self addChild:solarSystem];
        
        menuButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"menu_button"];
        [menuButton initButton];
        menuButton.name = @"menu";
        menuButton.delegate = self;
        menuButton.scale = primaryScale;
        menuButton.position = CGPointMake(22.0,self.size.height-22.0);
        menuButton.zPosition = 4;
        menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        menuButton.colorBlendFactor = 1.0;
        [solarSystem addChild:menuButton];
        
        backButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"back_button"];
        [backButton initButton];
        backButton.name = @"back";
        backButton.delegate = self;
        backButton.scale = primaryScale;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.zPosition = -1;
        backButton.enabled = NO;
        [self addChild:backButton];
        
        navBackButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"green_back_button"];
        [navBackButton initButton];
        navBackButton.name = @"navback";
        navBackButton.delegate = self;
        navBackButton.scale = primaryScale;
        navBackButton.position = CGPointMake(self.size.width-26.0,self.size.height-26.0);
        navBackButton.zPosition = 4;
        [solarSystem addChild:navBackButton];
        
        float spacing = 5.0;
        
        float buttonSize = 152.5;
        float buttonScale = 1.0;
        if (IS_IPHONE_4) {
            buttonScale = 0.8;
            iphoneAddY += 64.0;
        }
        if (IS_IPHONE_6_PLUS) {
            buttonScale = 1.2;
            iphoneAddY -= 52.0;
        }
        buttonSize = buttonSize * buttonScale;
        
        SKSpriteNode *top = [SKSpriteNode spriteNodeWithImageNamed:@"haccp_top"];
        top.position = CGPointMake(self.size.width/2, self.size.height);
        top.anchorPoint = CGPointMake(0.5, 1.0);
        float newWidth = self.size.width / buttonScale;
        float factor = newWidth / top.size.width;
        if (IS_IPHONE_4)
            factor = factor * .8;
        //printf("old width: %f, new width: %f, factor: %f\n",top.size.width,newWidth,factor);
        top.zPosition = 2;
        top.scale = buttonScale * factor;
        [solarSystem addChild:top];
        
        SKButtonNodeJRTB *button_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"haccp_button_01"];
        [button_02 initButton];
        button_02.name = @"01";
        button_02.delegate = self;
        button_02.position = CGPointMake(self.size.width/2.0-buttonSize/2.0-spacing/2.0,buttonSize/2.0+buttonSize*1.0+spacing*2.0+iphoneAddY/2.0);
        button_02.scale = buttonScale;
        [solarSystem addChild:button_02];
        
        SKButtonNodeJRTB *button_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"haccp_button_02"];
        [button_03 initButton];
        button_03.name = @"02";
        button_03.delegate = self;
        button_03.position = CGPointMake(self.size.width/2.0+buttonSize/2.0+spacing/2.0,buttonSize/2.0+buttonSize*1.0+spacing*2.0+iphoneAddY/2.0);
        button_03.scale = buttonScale;
        [solarSystem addChild:button_03];
        
        SKButtonNodeJRTB *button_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"haccp_button_03"];
        [button_04 initButton];
        button_04.name = @"03";
        button_04.delegate = self;
        button_04.position = CGPointMake(self.size.width/2.0-buttonSize/2.0-spacing/2.0,buttonSize/2.0+buttonSize*0.0+spacing*1.0+iphoneAddY/2.0);
        button_04.scale = buttonScale;
        [solarSystem addChild:button_04];
        
        SKButtonNodeJRTB *button_05 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"haccp_button_04"];
        [button_05 initButton];
        button_05.name = @"04";
        button_05.delegate = self;
        button_05.position = CGPointMake(self.size.width/2.0+buttonSize/2.0+spacing/2.0,buttonSize/2.0+buttonSize*0.0+spacing*1.0+iphoneAddY/2.0);
        button_05.scale = buttonScale;
        [solarSystem addChild:button_05];
        
        SKLabelNode *aLetter = [SKLabelNode labelNodeWithFontNamed:@"Univers LT Std 57 Condensed"];
        if (IS_IPHONE_4 || IS_IPHONE_5)
            aLetter.position = CGPointMake(self.size.width*.5, button_05.size.height*2.0+spacing*4.0+iphoneAddY*.5+16.0);
        else
            aLetter.position = CGPointMake(self.size.width*.5, button_05.size.height*2.0+spacing*4.0+iphoneAddY*.5+32.0);
        aLetter.text = @"HACCP";
        aLetter.fontSize = 52.0;
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
            aLetter.fontSize += 24;
        aLetter.scale = primaryScale * buttonScale;
        aLetter.zPosition = 1;
        aLetter.fontColor = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        aLetter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        aLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [solarSystem addChild:aLetter];
        
        SKAction *waitC = [SKAction waitForDuration:0.2];
        SKAction *goC = [SKAction runBlock:^{
            
            [self getScreenshot];
            
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        overlay = [SKSpriteNode spriteNodeWithImageNamed:@"menu_overlay2"];
        overlay.position = CGPointMake(self.size.width/2-self.size.width, self.size.height/2);
        overlay.zPosition = 10;
        [self addChild:overlay];
        
        SKButtonNodeJRTB *overlayButton_01 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_01"];
        [overlayButton_01 initButton];
        overlayButton_01.name = @"overlay_01";
        overlayButton_01.delegate = self;
        overlayButton_01.position = CGPointMake(-32.0,67.0);
        overlayButton_01.zPosition = 3;
        [overlay addChild:overlayButton_01];
        
        SKButtonNodeJRTB *overlayButton_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_02"];
        [overlayButton_02 initButton];
        overlayButton_02.name = @"overlay_02";
        overlayButton_02.delegate = self;
        overlayButton_02.position = CGPointMake(-32.0,67.0-55.0);
        overlayButton_02.zPosition = 3;
        [overlay addChild:overlayButton_02];
        
        SKButtonNodeJRTB *overlayButton_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_03"];
        [overlayButton_03 initButton];
        overlayButton_03.name = @"overlay_03";
        overlayButton_03.delegate = self;
        overlayButton_03.position = CGPointMake(-32.0,67.0-55.0*2);
        overlayButton_03.zPosition = 3;
        [overlay addChild:overlayButton_03];
        
        SKButtonNodeJRTB *overlayButton_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_04"];
        [overlayButton_04 initButton];
        overlayButton_04.name = @"overlay_04";
        overlayButton_04.delegate = self;
        overlayButton_04.position = CGPointMake(-32.0,67.0-55.0*3);
        overlayButton_04.zPosition = 3;
        [overlay addChild:overlayButton_04];
        
        SKButtonNodeJRTB *overlayButton_05 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_05"];
        [overlayButton_05 initButton];
        overlayButton_05.name = @"overlay_05";
        overlayButton_05.delegate = self;
        overlayButton_05.position = CGPointMake(-32.0,67.0-55.0*4);
        overlayButton_05.zPosition = 3;
        [overlay addChild:overlayButton_05];
        
        SKButtonNodeJRTB *overlayButton_06 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_06"];
        [overlayButton_06 initButton];
        overlayButton_06.name = @"overlay_06";
        overlayButton_06.delegate = self;
        overlayButton_06.position = CGPointMake(-32.0,67.0-55.0*5);
        overlayButton_06.zPosition = 3;
        [overlay addChild:overlayButton_06];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
        [vc.view addGestureRecognizer:swipeGestureLeft];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [swipeGestureLeft setDelegate:self];
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(handleSwipeGestureRight:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [vc.view addGestureRecognizer:swipeGestureRight];
        
        [swipeGestureRight setDelegate:self];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void) handleSwipeGestureLeft: (id) sender
{
    printf("swipe left\n");
    
    if (menuOut) {
        
        menuOut = NO;
        
        [menuButton removeAllActions];
        menuButton.enabled = YES;
        [menuButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX-self.size.width, self.size.height*.5) duration:0.4]];
        
        [screenshotView runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.enabled = NO;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0-self.size.width,self.size.height-22.0) duration:0.4]];
        
        SKAction *waitC = [SKAction waitForDuration:0.4];
        SKAction *goC = [SKAction runBlock:^{
            screenshotView.zPosition = -1;
            backButton.zPosition = -1;
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
    } else {
        
        printf("nav back button pressed\n");
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];

        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
        
    }
    
}

- (void) handleSwipeGestureRight: (id) sender
{
    printf("swipe right\n");
    
    if (!menuOut) {
        
        menuOut = YES;
        
        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
        
        screenshotView.zPosition = 5;
        [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.zPosition = 41;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.enabled = YES;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
}

- (void) getScreenshot {
    
    //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [screenshot applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    screenshotView = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:blurredSnapshotImage]];
    //screenshotView.scale = blurredSnapshotImage.scale / 3.0;
    screenshotView.position = CGPointMake(self.size.width*.5, self.size.height*.5);
    screenshotView.zPosition = -1;
    screenshotView.alpha = 0.0;
    [self addChild:screenshotView];
    
    //NSLog(@"image size %@, scale %f", NSStringFromCGSize(blurredSnapshotImage.size), blurredSnapshotImage.scale);
    //NSLog(@"texture from image, size %@", NSStringFromCGSize(screenshotView.size));
    
    UIGraphicsEndImageContext();
    
    printf("screenshot ready\n");
    
}

- (void) buttonPushed: (SKButtonNodeJRTB *) sender {
    
    if ([sender.name isEqualToString:@"overlay_01"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_02"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HACCP];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_03"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_04"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_05"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_06"]) {
        [self removeAllActions];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }

    if ([sender.name isEqualToString:@"navback"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("nav back button pressed\n");
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];

        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
        
    }
    
    if ([sender.name isEqualToString:@"menu"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("menu button pressed\n");
        
        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
        
        screenshotView.zPosition = 5;
        [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.zPosition = 41;
        backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.enabled = YES;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
        
    }
    
    if ([sender.name isEqualToString:@"back"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("back button pressed\n");
        
        [menuButton removeAllActions];
        menuButton.enabled = YES;
        menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        menuButton.colorBlendFactor = 1.0;
        [menuButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX-self.size.width, self.size.height*.5) duration:0.4]];
        
        [screenshotView runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.enabled = NO;
        [backButton runAction:[SKAction moveTo:CGPointMake(22.0-self.size.width,self.size.height-22.0) duration:0.4]];
        
        SKAction *waitC = [SKAction waitForDuration:0.4];
        SKAction *goC = [SKAction runBlock:^{
            screenshotView.zPosition = -1;
            backButton.zPosition = -1;
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
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
    
    printf("haccp scene dealloc\n");
}

@end
