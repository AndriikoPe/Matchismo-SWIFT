//  Converted to Swift 5 by Swiftify v5.0.31539 - https://objectivec2swift.com/
//
//  ViewController.h
//  Matchismo OBJC
//
//  Created by Пермяков Андрей on 6/21/19.
//  Copyright © 2019 Пермяков Андрей. All rights reserved.
//

//
//  ViewController.m
//  Matchismo OBJC
//
//  Created by Пермяков Андрей on 6/21/19.
//  Copyright © 2019 Пермяков Андрей. All rights reserved.
//

import UIKit

@objcMembers class CardGameViewController: UIViewController {
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var _card: Card?
    private var card: Card? {
        if _card == nil {
            _card = PlayingCard()
        }
        return _card
    }
    @IBOutlet private weak var gameModeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var matchDescriptionLabel: UILabel!

    private lazy var game = CardMatchingGame(cardCount: cardButtons.count, using: createDeck())
    
    func createDeck() -> Deck {
        return PlayingCardDeck()
    }

    @IBAction func newGame() {
        gameModeSegmentedControl.isEnabled = true
        game = CardMatchingGame(cardCount: cardButtons.count, using: createDeck())
        updateView()
    }

    @IBAction func touchCardButton(_ sender: UIButton) {
        if let chosenButtonIndex = cardButtons.firstIndex(of: sender) {
            gameModeSegmentedControl.isEnabled = false
            game?.numberOfCardMatchingMode = gameModeSegmentedControl.selectedSegmentIndex != 0 ? 3 : 2
            // if selectedSegmentIndex is 0, then false => returns 2, if it is 1, then true => returns 3
            game?.chooseCard(at: chosenButtonIndex)
            updateView()
        }
    }

    func updateView() {
        for button in cardButtons {
            if let cardButtonIndex = cardButtons.firstIndex(of: button), let card = game?.card(at: cardButtonIndex) {
                button.setTitle(title(for: card), for: .normal)
                button.setBackgroundImage(backgroundImage(for: card), for: .normal)
                button.isEnabled = !(card.isMatched)
                matchDescriptionLabel.text = game?.matchDesctiption
                scoreLabel.text = "Score: \(Int(game?.score ?? 0))"
            }
        }
    }

    func title(for card: Card) -> String? {
        return card.isChosen ? card.contents : ""
    }

    func backgroundImage(for card: Card) -> UIImage? {
        return UIImage(named: card.isChosen ? "cardFront" : "cardBack")
    }
}
