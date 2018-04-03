//
//  EmojiMatchGameObjC.m
//  EmojiMatching-schiesla
//
//  Created by CSSE Department on 4/3/18.
//  Copyright © 2018 Rose-Hulman. All rights reserved.
//

#import "EmojiMatchGameObjC.h"

@implementation EmojiMatchGameObjC

- (id) initWithNumPairs:(NSInteger) numPairs {
    self = [super init];
    if (self) {
        self.numPairs = numPairs;
        self.gameState = GameStateNoClick;
        self.cardsOnBoard = [[NSMutableArray alloc] init];
        self.cardStates = [[NSMutableArray alloc] init];
        NSArray* allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString:@","];
        NSArray* allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString:@","];
        
        
        // Randomly select emojiSymbols
        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
        while (emojiSymbolsUsed.count < numPairs) {
            NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
            if (![emojiSymbolsUsed containsObject:symbol]) {
                [emojiSymbolsUsed addObject:symbol];
            }
        }
        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
        // Shuffle the NSMutableArray before converting it to an NSArray.
        for (int i = 0; i < emojiSymbolsUsed.count; ++i) {
            UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];
        
        // Randomly select a card back.
        self.cardBack = allCardBacks[arc4random_uniform((UInt32) allCardBacks.count)];
        
        // Reset cardStates to ensure default values.
        for (int i = 0; i < self.cards.count; ++i) {
            self.cardStates[i] = [self getCardStateString:CardStateHidden];
            self.cardsOnBoard[i] = self.cardBack;
        }
    }
    return self;

}

- (NSString*) getGameBoardCheetSheet {
    return @"";
    
}

- (NSString*) getGameStateString {
    switch (self.gameState) {
        case GameStateNoClick:
            return @"noClick";
        case GameStateOneClick:
            return @"oneClick";
        case GameStateTurnOver:
            return @"turnOver";
        case GameStateWin:
            return @"win";
    }
}

- (NSString*) getCardStateString:(CardState) cardState {
    switch (cardState) {
        case CardStateShown:
            return @"shown";
        case CardStateHidden:
            return @"hidden";
        case CardStateRemoved:
            return @"removed";
    }
}

- (void) cardPressed:(NSInteger) index {
    if (self.cardStates[index] == [self getCardStateString:CardStateHidden]) {
        self.cardsOnBoard[index] = self.cards[index];
        self.cardStates[index] = [self getCardStateString:CardStateShown];
    } else {
        return;
    }
    
    if (self.gameState == GameStateNoClick) {
        self.gameState = GameStateOneClick;
    } else if (self.gameState == GameStateOneClick) {
        self.gameState = GameStateTurnOver;
    }
}

- (void) checkForMatch {
    NSMutableArray* picksClicked = [[NSMutableArray alloc] init];
    NSNumber* initNum = [NSNumber numberWithInt:-1];
    [picksClicked addObject:initNum];
    [picksClicked addObject:initNum];
    for (int j = 0; j < self.numPairs*2; j++) {
        if (self.cardStates[j] == [self getCardStateString:CardStateShown]) {
            if ([picksClicked[0] intValue] == -1) {
                picksClicked[0] = [NSNumber numberWithInt:j];
            } else if ([picksClicked[1] intValue] == -1) {
                picksClicked[1] = [NSNumber numberWithInt:j];
            } else {
                //error
            }
        }
    }
    
    if (self.cards[[picksClicked[0] intValue]] == self.cards[[picksClicked[1] intValue]]) {
        self.cardsOnBoard[[picksClicked[0] intValue]] = @"";
        self.cardStates[[picksClicked[0] intValue]] = [self getCardStateString:CardStateRemoved];
        self.cardsOnBoard[[picksClicked[1] intValue]] = @"";
        self.cardStates[[picksClicked[1] intValue]] = [self getCardStateString:CardStateRemoved];
    } else {
        self.cardsOnBoard[[picksClicked[0] intValue]] = self.cardBack;
        self.cardStates[[picksClicked[0] intValue]] = [self getCardStateString:CardStateHidden];
        self.cardsOnBoard[[picksClicked[1] intValue]] = self.cardBack;
        self.cardStates[[picksClicked[1] intValue]] = [self getCardStateString:CardStateHidden];
    }
    self.gameState = GameStateNoClick;
}

- (void) checkForGameOver {
    for (int i = 0; i < self.numPairs*2; i++) {
        if ((self.cardStates[i] == [self getCardStateString:CardStateShown]) || (self.cardStates[i] == [self getCardStateString:CardStateHidden])) {
            self.gameState = GameStateNoClick;
            return;
        } else {
            self.gameState = GameStateWin;
        }
    }
}

@end
