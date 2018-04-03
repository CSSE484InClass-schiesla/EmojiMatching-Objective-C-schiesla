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
    var emojiGame = EmojiMatchGameObjC()
    var blockingUiIntentionally = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets icon fonts, picked a random font
        for button in gameButtons {
            if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
                button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 64)
            } else {
                button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 100)
            }
        }
        newGame()
    }

    func newGame() {
        //block intentionally to stop a new game from starting during a delay
        if blockingUiIntentionally == true {
            return
        }
        emojiGame = EmojiMatchGameObjC(numPairs: 10)
        for i in 0..<gameButtons.count {
            gameButtons[i].setTitle((emojiGame.cardsOnBoard[i] as! String), for: .normal)
        }
        
        //Cheet sheet
        //print(emojiGame)
    }
    
    func updateView() {
        for i in 0..<gameButtons.count {
            gameButtons[i].setTitle((emojiGame.cardsOnBoard[i] as! String), for: .normal)
        }
        
        //When the turns over, check for match and game over
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

