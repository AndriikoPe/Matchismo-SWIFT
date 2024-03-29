//
//  ViewController.m
//  Matchismo OBJC
//
//  Created by Пермяков Андрей on 6/21/19.
//  Copyright © 2019 Пермяков Андрей. All rights reserved.
//

#import "CardGameViewController.h"
#import "Model/PlayingCardDeck.h"
#import "Model/PlayingCard.h"
#import "Model/CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) Card *card;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *matchDescriptionLabel;
@property (nonatomic, strong) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (Card *)card {
    if (!_card) _card = [[PlayingCard alloc] init];
    return _card;
}

- (IBAction)newGame {
    self.gameModeSegmentedControl.enabled = YES;
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateView];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    self.gameModeSegmentedControl.enabled = NO;
    self.game.numberOfCardMatchingMode = [self.gameModeSegmentedControl selectedSegmentIndex] ? 3 : 2;
    // if selectedSegmentIndex is 0, then false => returns 2, if it is 1, then true => returns 3
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateView];
}

- (void)updateView {
    for (UIButton *button in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        button.enabled = !card.isMatched;
        self.matchDescriptionLabel.text = self.game.matchDesctiption;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed: card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
