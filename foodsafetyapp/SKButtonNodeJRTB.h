//
//  SKButtonNodeJRTB.h
//  grandpainspace
//
//  Created by jrtb on 10/28/13.
//  Copyright (c) 2013 Fairlady Media, Inc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SKButtonNodeJRTB;
@protocol SKButtonNodeJRTBDelegate
- (void) buttonPushed: (SKButtonNodeJRTB *) sender;
@end

@interface SKButtonNodeJRTB : SKSpriteNode {
    
    NSString*               normalImage;
    NSString*               clickImage;
    
    BOOL                    enabled;

}

@property (nonatomic, weak) id <SKButtonNodeJRTBDelegate> delegate;
@property BOOL enabled;

- (void)initButton;
- (void)setNormalImage :(NSString*)withThisImage;
- (void)setClickImage :(NSString*)withThisImage;

@end
