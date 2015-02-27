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

#import "UIImage+ImageEffects.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation iphoneMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        menuOut = NO;
        
        touched = NO;
        
        self.backgroundColor = [SKColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        // primary scale is used to scale assets such that only one 4x iPad Retina asset needs to be included in the binary
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            primaryScale = 0.5;
        } else {
            if (IS_RETINA)
                primaryScale = 1.0;
            else
                primaryScale = 1.0;
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
        if (IS_IPAD) {
            iphoneAddY = (1024-568.0)/2.0;
            iphoneAddX = (580.0-320.0)/2.0;
        }
        
        //printf("iphoneAddY: %f\n",iphoneAddY);
        
        solarSystem = [[SKEffectNode alloc] init];
        solarSystem.position = CGPointMake(0.0,0.0);
        [self addChild:solarSystem];

        menuButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"menu_button"];
        [menuButton initButton];
        menuButton.name = @"menu";
        menuButton.delegate = self;
        menuButton.scale = primaryScale;
        menuButton.zPosition = 14;
        if (IS_IPAD) {
            menuButton.position = CGPointMake(22.0*2,self.size.height-22.0*2);
            menuButton.colorBlendFactor = 1.0;
            menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        } else {
            menuButton.position = CGPointMake(22.0,self.size.height-22.0);
        }
        [self addChild:menuButton];

        backButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"back_button"];
        [backButton initButton];
        backButton.name = @"back";
        backButton.delegate = self;
        backButton.scale = primaryScale;
        if (IS_IPAD) {
            backButton.position = CGPointMake(22.0*2-self.size.width,self.size.height-22.0*2);
        } else {
            backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        }
        backButton.zPosition = -1;
        backButton.enabled = NO;
        [self addChild:backButton];

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
        if (IS_IPAD) {
            spacing = 10.0;
            buttonScale = 1.7;
            iphoneAddY -= 220.0;
        }
        
        buttonSize = buttonSize * buttonScale;
        
        SKButtonNodeJRTB *button_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_01_02"];
        [button_02 initButton];
        button_02.name = @"01";
        button_02.delegate = self;
        button_02.position = CGPointMake(self.size.width/2.0-buttonSize/2.0-spacing/2.0,buttonSize/2.0+buttonSize*1.0+spacing*2.0+iphoneAddY/2.0);
        button_02.scale = buttonScale;
        [solarSystem addChild:button_02];

        SKButtonNodeJRTB *button_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_02_02"];
        [button_03 initButton];
        button_03.name = @"02";
        button_03.delegate = self;
        button_03.position = CGPointMake(self.size.width/2.0+buttonSize/2.0+spacing/2.0,buttonSize/2.0+buttonSize*1.0+spacing*2.0+iphoneAddY/2.0);
        button_03.scale = buttonScale;
        [solarSystem addChild:button_03];

        SKButtonNodeJRTB *button_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_03_02"];
        [button_04 initButton];
        button_04.name = @"03";
        button_04.delegate = self;
        button_04.position = CGPointMake(self.size.width/2.0-buttonSize/2.0-spacing/2.0,buttonSize/2.0+buttonSize*0.0+spacing*1.0+iphoneAddY/2.0);
        button_04.scale = buttonScale;
        [solarSystem addChild:button_04];

        SKButtonNodeJRTB *button_05 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"main_menu_button_04_02"];
        [button_05 initButton];
        button_05.name = @"04";
        button_05.delegate = self;
        button_05.position = CGPointMake(self.size.width/2.0+buttonSize/2.0+spacing/2.0,buttonSize/2.0+buttonSize*0.0+spacing*1.0+iphoneAddY/2.0);
        button_05.scale = buttonScale;
        [solarSystem addChild:button_05];

        SKLabelNode *aLetter = [SKLabelNode labelNodeWithFontNamed:@"Univers LT Std 57 Condensed"];
        if (IS_IPHONE_4)
            aLetter.position = CGPointMake(self.size.width*.5, button_05.size.height*2.0+spacing*4.0+iphoneAddY*.5+16.0);
        else if (IS_IPAD)
            aLetter.position = CGPointMake(self.size.width*.5, button_05.size.height*2.0+spacing*4.0+iphoneAddY*.5+58.0);
        else
            aLetter.position = CGPointMake(self.size.width*.5, button_05.size.height*2.0+spacing*4.0+iphoneAddY*.5+32.0);
        aLetter.text = @"Food Safety and HACCP";
        if (IS_IPAD)
            aLetter.fontSize = 52.0;
        else
            aLetter.fontSize = 26.0;
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
            aLetter.fontSize += 8;
        aLetter.zPosition = 1;
        aLetter.fontColor = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        aLetter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        aLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [solarSystem addChild:aLetter];

        video1 = [SKSpriteNode spriteNodeWithImageNamed:@"fs350_01_firstframe"];
        if (IS_IPAD) {
            video1.size = CGSizeMake(self.size.width*0.775, self.size.width*0.8/2.0);
        } else {
            video1.size = CGSizeMake(self.size.width, self.size.width/2.0);
        }
        video1.anchorPoint = CGPointMake(0.5, 1.0);
        video1.position = CGPointMake(self.size.width*.5,self.size.height);
        [solarSystem addChild: video1];

        playButton = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"play_button_red"];
        [playButton initButton];
        playButton.name = @"play";
        playButton.delegate = self;
        playButton.scale = primaryScale*.75;
        if (IS_IPAD)
            playButton.position = CGPointMake(self.size.width - playButton.size.width - spacing * 4-40,self.size.height + playButton.size.height - video1.size.height+spacing * 4);
        else
            playButton.position = CGPointMake(self.size.width - playButton.size.width - spacing * 4,self.size.height + playButton.size.height - video1.size.height+spacing * 4);
        playButton.zPosition = 3;
        [solarSystem addChild:playButton];

        videoReady = NO;
        
        //printf("getting here\n");

        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        screenshotView = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.95] size:CGSizeMake(self.size.width, self.size.height)];
        screenshotView.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
        screenshotView.alpha = 0.0;
        screenshotView.zPosition = -1;
        [self addChild:screenshotView];

        overlay = [SKSpriteNode spriteNodeWithImageNamed:@"menu_overlay2"];
        overlay.zPosition = 10;
        if (IS_IPAD) {
            overlay.position = CGPointMake(self.size.width/2-self.size.width*1.2, self.size.height/2);
            overlay.scale = 1.6;
        } else {
            overlay.position = CGPointMake(self.size.width/2-self.size.width, self.size.height/2);
        }
        [self addChild:overlay];
        
        SKButtonNodeJRTB *overlayButton_01 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_01_2"];
        [overlayButton_01 initButton];
        overlayButton_01.name = @"overlay_01";
        overlayButton_01.delegate = self;
        overlayButton_01.position = CGPointMake(-32.0,67.0);
        overlayButton_01.zPosition = 3;
        [overlay addChild:overlayButton_01];

        SKButtonNodeJRTB *overlayButton_02 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_02_2"];
        [overlayButton_02 initButton];
        overlayButton_02.name = @"overlay_02";
        overlayButton_02.delegate = self;
        overlayButton_02.position = CGPointMake(-32.0,67.0-55.0);
        overlayButton_02.zPosition = 3;
        [overlay addChild:overlayButton_02];

        SKButtonNodeJRTB *overlayButton_03 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_03_2"];
        [overlayButton_03 initButton];
        overlayButton_03.name = @"overlay_03";
        overlayButton_03.delegate = self;
        overlayButton_03.position = CGPointMake(-32.0,67.0-55.0*2);
        overlayButton_03.zPosition = 3;
        [overlay addChild:overlayButton_03];

        SKButtonNodeJRTB *overlayButton_04 = [SKButtonNodeJRTB spriteNodeWithImageNamed:@"side_menu_button_04_2"];
        [overlayButton_04 initButton];
        overlayButton_04.name = @"overlay_04";
        overlayButton_04.delegate = self;
        overlayButton_04.position = CGPointMake(-32.0,67.0-55.0*3);
        overlayButton_04.zPosition = 3;
        [overlay addChild:overlayButton_04];
        /*
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
         */
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
        
        SKAction *waitC = [SKAction waitForDuration:0.01];
        SKAction *goC = [SKAction runBlock:^{
            [self setupVideo];
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
    }
    return self;
}

/*
- (void)playVideoWithId:(NSString *)videoId {
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.frame.size.width, self.frame.size.height, videoId];
    
    [self loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
}
*/

/*
- (void) playNewStyleYoutubeVideo :(NSString*) videoId
{
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    GameViewController *vc = (GameViewController *) delegate.window.rootViewController;

    static NSString *youTubeVideoHTML = @"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 90, self.size.width, self.size.height-90)];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.delegate = self;
    [vc.view addSubview:webView];
    
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, self.frame.size.width, self.frame.size.height, videoId];
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[[NSBundle mainBundle] resourceURL]];

}
*/

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
            menuButton.colorBlendFactor = 1.0;
            menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
}

- (void) handleSwipeGestureRight: (id) sender
{
    printf("swipe right\n");
    
    if (!menuOut) {
        
        menuOut = YES;
        
        menuButton.enabled = NO;
        [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
        
        [self removeAllActions];
        [self stopMovie];
        
        [overlay removeAllActions];
        [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
        
        screenshotView.zPosition = 5;
        [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        [backButton removeAllActions];
        backButton.zPosition = 41;
        if (IS_IPAD)
            backButton.position = CGPointMake(44.0-self.size.width,self.size.height-44.0);
        else
            backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
        backButton.enabled = YES;
        if (IS_IPAD)
            [backButton runAction:[SKAction moveTo:CGPointMake(44.0,self.size.height-44.0) duration:0.4]];
        else
            [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
        
        //screenshotView.alpha = 1.0;
        
    }
    
}

- (void) setupVideo
{
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    videoLength = 673.0+2.0;
    
    //int actualMovieNum = 0;
    
    [vc resetVideo:@"fs350_01"];
    
    [[vc video] pause];
    
    [[vc video] setPosition:CGPointMake(self.size.width*.5,self.size.height)];
    [[vc video] setAnchorPoint:CGPointMake(0.5, 1.0)];
    [[vc video] setSize:CGSizeMake(self.size.width, self.size.width/2.0)];
    //[[vc video] setScale:primaryScale];
    [[vc video] setZPosition:-1];
    [[vc video] setAlpha:0.0];
    [self addChild:[vc video]];

    videoReady = YES;
    
}

- (void) stopMovie
{
    
    if (videoReady) {

        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [vc killVideo];
        
        [[vc player] removeAllItems];
        [[vc video] removeFromParent];
        
        [playButton setEnabled:YES];
        [playButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
        
        videoReady = NO;

    }
    
}

- (void) getScreenshot {
    
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0);
    
    // There he is! The new API method
    [delegate.window drawViewHierarchyInRect:CGRectMake(0,0,self.size.width,self.size.height) afterScreenUpdates:YES];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    screenshot = snapshotImage;
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [screenshot applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    if (screenshotView)
        [screenshotView removeFromParent];
    
    screenshotView = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:blurredSnapshotImage]];
    //screenshotView.scale = 1.0 / blurredSnapshotImage.scale;
    screenshotView.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    //screenshotView.anchorPoint = CGPointMake(1.0, 1.0);
    screenshotView.zPosition = -1;
    //screenshotView.zRotation = SK_DEGREES_TO_RADIANS(90);
    screenshotView.alpha = 0.0;
    [self addChild:screenshotView];
    
//    NSLog(@"image size %@, scale %f", NSStringFromCGSize(blurredSnapshotImage.size), blurredSnapshotImage.scale);
//    NSLog(@"texture from image, size %@", NSStringFromCGSize(screenshotView.size));
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    
}

/*
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
*/

- (void) buttonPushed: (SKButtonNodeJRTB *) sender {
    
    if ([sender.name isEqualToString:@"overlay_01"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_02"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HACCP2];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_03"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_04"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_05"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }
    if ([sender.name isEqualToString:@"overlay_06"]) {
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        [self clean];
        [vc setScreenToggle:MENU];
        [vc replaceTheScene];
    }

    if ([sender.name isEqualToString:@"01"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("prereq button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];

        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:PREREQ];
        [vc replaceTheScene];
        
    }

    if ([sender.name isEqualToString:@"02"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("haccp button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:HACCP2];
        [vc replaceTheScene];
        
    }

    if ([sender.name isEqualToString:@"03"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("careers button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:CAREERS];
        [vc replaceTheScene];
        
    }

    if ([sender.name isEqualToString:@"04"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("howling cow button pressed\n");
        
        [self removeAllActions];
        [self stopMovie];
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [self clean];
        
        [vc setScreenToggle:HOWLINGCOW];
        [vc replaceTheScene];
        
    }

    if ([sender.name isEqualToString:@"menu"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("menu button pressed\n");
        
        if (!menuOut) {
            
            menuOut = YES;
            
            menuButton.enabled = NO;
            [menuButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.4]];
            
            [self removeAllActions];
            [self stopMovie];
            
            [overlay removeAllActions];
            [overlay runAction:[SKAction moveTo:CGPointMake(self.size.width*.5-iphoneAddX, self.size.height*.5) duration:0.4]];
            
            screenshotView.zPosition = 5;
            [screenshotView runAction:[SKAction fadeAlphaTo:1.0 duration:0.4]];
            
            [backButton removeAllActions];
            backButton.zPosition = 41;
            if (IS_IPAD)
                backButton.position = CGPointMake(44.0-self.size.width,self.size.height-44.0);
            else
                backButton.position = CGPointMake(22.0-self.size.width,self.size.height-22.0);
            backButton.enabled = YES;
            if (IS_IPAD)
                [backButton runAction:[SKAction moveTo:CGPointMake(44.0,self.size.height-44.0) duration:0.4]];
            else
                [backButton runAction:[SKAction moveTo:CGPointMake(22.0,self.size.height-22.0) duration:0.4]];
            
        }

    }
    
    if ([sender.name isEqualToString:@"back"]) {
        
        //AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        printf("back button pressed\n");
        
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
                menuButton.colorBlendFactor = 1.0;
                menuButton.color = [SKColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            }];
            [self runAction:[SKAction sequence:@[waitC,goC]]];
            
            //screenshotView.alpha = 1.0;

        }
        
    }
    
    if ([sender.name isEqualToString:@"play"]) {
        
        AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        GameViewController *vc = (GameViewController *) delegate.window.rootViewController;
        
        [playButton setEnabled:NO];
        [playButton runAction:[SKAction fadeAlphaTo:0.0 duration:0.1]];
        
        SKAction *waitC = [SKAction waitForDuration:0.1];
        SKAction *goC = [SKAction runBlock:^{
            //printf("attempting to play\n");
            [[vc video] setZPosition:4];
            [[vc video] setSize:video1.size];
            [[vc video] setPosition:video1.position];
            [[vc video] setAlpha:1.0];
            [[vc video] play];
        }];
        [self runAction:[SKAction sequence:@[waitC,goC]]];
        
        SKAction *waitD = [SKAction waitForDuration:videoLength];
        SKAction *goD = [SKAction runBlock:^{
            [self stopMovie];
        }];
        [self runAction:[SKAction sequence:@[waitD,goD]]];
        
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    printf("touched A\n");

    //if (!touched) {
        
        touched = YES;
        
        printf("touched B\n");
        
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
            
        }
        
    //}
}

- (void) clean
{
    AppDelegate *delegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    GameViewController *vc = (GameViewController *) delegate.window.rootViewController;

    [vc killVideo];
    
    [[vc player] removeAllItems];
    [[vc video] removeFromParent];


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
