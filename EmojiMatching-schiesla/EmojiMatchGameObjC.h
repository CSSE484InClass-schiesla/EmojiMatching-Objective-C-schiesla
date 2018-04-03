//
//  EmojiMatchGameObjC.h
//  EmojiMatching-schiesla
//
//  Created by CSSE Department on 4/3/18.
//  Copyright © 2018 Rose-Hulman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GameState) {
    GameStateNoClick,
    GameStateOneClick,
    GameStateTurnOver,
    GameStateWin
};

typedef NS_ENUM(NSInteger, CardState) {
    CardStateHidden,
    CardStateShown,
    CardStateRemoved
};

@interface EmojiMatchGameObjC : NSObject

@property (nonatomic) GameState gameState;
@property (nonatomic) NSMutableArray* cardStates;
@property (nonatomic) NSArray* cards;
@property (nonatomic) NSString* cardBack;
@property (nonatomic) NSMutableArray* cardsOnBoard;
@property (nonatomic) NSArray* allCardBacks;
@property (nonatomic) NSArray* callEmojiCharacters;

@property (nonatomic) NSInteger numPairs;

- (NSString*) getGameStateString;
- (NSString*) getCardStateString:(CardState) cardState;
- (id) initWithNumPairs:(NSInteger) numPairs;
//description?
- (NSString*) getGameBoardCheetSheet;
- (void) cardPressed:(NSInteger) index;
- (void) checkForMatch;
- (void) checkForGameOver;

@end
