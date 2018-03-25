//
//  EmojiMatchGame.swift
//  EmojiMatching-schiesla
//
//  Created by CSSE Department on 3/25/18.
//  Copyright © 2018 Rose-Hulman. All rights reserved.
//

import Foundation
import UIKit

class EmojiMatchingGame: CustomStringConvertible {
    
    enum GameState: String {
        case noClick = "Waiting for first selection"
        case oneClick = "Waiting for second selection"
        case turnOver = "Turn complete"
        case win = "Game Over, You Win!"
    }
    
    enum CardState: String {
        case hidden = "Hidden"
        case shown = "Shown"
        case removed = "Removed"
    }
    
    var gameState: GameState
    var cardStates: [CardState]
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    var cards : [Character]
    var cardBack : Character
    var cardsOnBoard : [String]
    
    init(numPairs: Int) {
        gameState = .noClick
        cardStates = [CardState](repeating: .hidden, count: numPairs*2)
        // Randomly select emojiSymbols
        var emojiSymbolsUsed = [Character]()
        while emojiSymbolsUsed.count < numPairs {
            let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let symbol = allEmojiCharacters[index]
            if !emojiSymbolsUsed.contains(symbol) {
                emojiSymbolsUsed.append(symbol)
            }
        }
        cards = emojiSymbolsUsed + emojiSymbolsUsed
        cards.shuffle()
        
        // Randomly select a card back for this round
        var index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        cardBack = allCardBacks[index]
        cardsOnBoard = [String](repeating: cardBack.description, count: numPairs*2)
    }
    
    var description: String {
        return getGameBoardCheetSheet()
    }
    
    func getGameBoardCheetSheet() -> String {
        var cheetSheet = ""
        var index = 1
        for card in cards {
            if index % 4 == 0 {
                cheetSheet += card.description + "\n"
            } else {
                cheetSheet += card.description
            }
            index += 1
        }
        return cheetSheet
    }
    
    func cardPressed(_ index: Int) {
        if cardStates[index] == .hidden {
            cardsOnBoard[index] = cards[index].description
            cardStates[index] = .shown
        }
        if gameState == .noClick {
            gameState = .oneClick
        } else if gameState == .oneClick {
            gameState = .turnOver
        }
    }
    
    func checkForMatch() {
        var picksClicked = [-1, -1]
            for i in 0..<cardStates.count {
                if cardStates[i] == .shown {
                    if picksClicked[0] == -1 {
                        picksClicked[0] = i
                    } else if picksClicked[1] == -1 {
                        picksClicked[1] = i
                    } else {
                        print("error 1")
                    }
                }
            }
            if (cards[picksClicked[0]] == cards[picksClicked[1]]) {
                cardsOnBoard[picksClicked[0]] = ""
                cardStates[picksClicked[0]] = .removed
                cardsOnBoard[picksClicked[1]] = ""
                cardStates[picksClicked[1]] = .removed
            } else {
                cardsOnBoard[picksClicked[0]] = cardBack.description
                cardStates[picksClicked[0]] = .hidden
                cardsOnBoard[picksClicked[1]] = cardBack.description
                cardStates[picksClicked[1]] = .hidden
            }
        gameState = .noClick
    }
    
    func checkForGameOver() {
        if cardStates.contains(.shown) || cardStates.contains(.hidden) {
            gameState = .noClick
        } else {
            gameState = .win
        }
    }
}

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}
