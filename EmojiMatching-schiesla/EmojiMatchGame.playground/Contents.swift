import Foundation
import UIKit

class EmojiMatchingGame: CustomStringConvertible {

    enum GameState: String {
        case noClick = "Waiting for first selection"
        case oneClick = "Waiting for second selection"
        case turnOver = "Turn complete"
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
//        var index = 0;
        for card in cards {
            cheetSheet += card.description
        }
        return cheetSheet
    }
    
    func cardPressed(_ index: Int) {
        if cardStates[index] == .hidden {
            cardsOnBoard[index] = cards[index].description
            cardStates[index] = .shown
        }
        checkForMatch()
    }
    
    func checkForMatch() {
        
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

//---------------------TEST----------------------
var game = EmojiMatchingGame(numPairs: 10)
game.cards
