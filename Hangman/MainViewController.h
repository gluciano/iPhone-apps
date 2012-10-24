//
//  MainViewController.h
//  Hangman
//
//  Gina Luciano (HUID: 90846027)
//  Harvard Extension Course CS76
//  luciano.gina@gmail.com
//
//

#import "FlipsideViewController.h"
#import "WordList.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *wordLabel;
@property (nonatomic, retain) IBOutlet UILabel *guessesRemainingLabel;
@property (nonatomic, retain) IBOutlet UISlider *guessesRemainingSlider;
@property (nonatomic, retain) IBOutlet UILabel *lettersGuessedLabel;
@property (nonatomic, retain) IBOutlet UILabel *largeMessageLabel;
@property (nonatomic, retain) IBOutlet UILabel *smallMessageLabel;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UIButton *newGameButton;
@property (assign, nonatomic) BOOL validEntry;
@property (assign, nonatomic) BOOL gameOver;
@property (assign, nonatomic) int maxGuesses;
@property (assign, nonatomic) int wordLength;
@property (assign, nonatomic) int guessesRemaining;
@property (nonatomic, copy) NSString *newLetter;
@property (nonatomic, copy) NSString *lettersGuessed;
@property (nonatomic, retain) WordList *wordList;
@property (nonatomic, retain) NSArray *initialWordListArray;
@property (nonatomic, retain) NSArray *newWordListArray;
@property (nonatomic, retain) NSMutableDictionary *equivalenceClasses;
@property (nonatomic, retain) NSMutableDictionary *newEquivalenceClasses;
@property (assign, nonatomic) BOOL keyboardDisplayed;
@property (assign, nonatomic) BOOL successfulGuess;


- (IBAction)showSetings:(id)sender;
- (IBAction)newGuess:(id)sender;
- (IBAction)toggleKeyboard:(id)sender;
- (IBAction)newGame:(id)sender;
- (void)startGame;
- (void)validateNewGuess; 
- (void)createInitialWordList;
- (void)tryAgain;
- (void)youLost;
- (void)youWon;
- (void)toggleKeyboard;
- (void)createEquivalenceClasses;


@end
