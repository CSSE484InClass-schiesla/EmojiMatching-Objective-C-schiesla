//
//  ViewController.swift
//  EmojiMatching-schiesla
//
//  Created by CSSE Department on 3/25/18.
//  Copyright © 2018 Rose-Hulman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func pressedNewGame(_ sender: Any) {
        newGame()
    }
    @IBAction func pressedGameTile(_ sender: Any) {
        if emojiGame.gameState == .win {
            return
        }
        if blockingUiIntentionally == true {
            return
        }
        let gameBoardButton = sender as! UIButton
        emojiGame.cardPressed(gameBoardButton.tag)
        updateView()
    }
    @IBOutlet var gameButtons: [UIButton]!
    var emojiGame = EmojiMatchingGame(numPairs: 10)
    var blockingUiIntentionally = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }

    func newGame() {
        if blockingUiIntentionally == true {
            return
        }
        emojiGame = EmojiMatchingGame(numPairs: 10)
        for i in 0..<gameButtons.count {
            gameButtons[i].setTitle(emojiGame.cardsOnBoard[i], for: .normal)
            if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
                gameButtons[i].titleLabel?.font = UIFont(name: "System", size: 64)
            } else {
                gameButtons[i].titleLabel?.font = UIFont(name: "System", size: 100)
            }
        }
        
        
        print(emojiGame.description)
    }
    
    func updateView() {
        for i in 0..<gameButtons.count {
            gameButtons[i].setTitle(emojiGame.cardsOnBoard[i], for: .normal)
            if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
                gameButtons[i].titleLabel?.font = UIFont(name: "System", size: 64)
            } else {
                gameButtons[i].titleLabel?.font = UIFont(name: "Times New Roman", size: 100)
            }
        }
        if emojiGame.gameState == .turnOver {
            blockingUiIntentionally = true
            delay(1.2) {
                self.emojiGame.checkForMatch()
                self.updateView()
                self.blockingUiIntentionally = false
                self.emojiGame.checkForGameOver()
            }
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }


}

