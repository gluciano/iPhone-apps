//
//  MainViewController.m
//  Hangman
//
//  Gina Luciano (HUID: 90846027)
//  Harvard Extension Course CS76
//  luciano.gina@gmail.com
//
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize textField=_textField;
@synthesize wordLabel = _wordLabel;
@synthesize guessesRemainingLabel=_guessesRemainingLabel;
@synthesize guessesRemainingSlider = _guessesRemainingSlider;
@synthesize lettersGuessedLabel=_lettersGuessedLabel;
@synthesize largeMessageLabel = _largeMessageLabel;
@synthesize smallMessageLabel = _smallMessageLabel;
@synthesize settingsButton = _settingsButton;
@synthesize newGameButton = _newGameButton;
@synthesize validEntry = _validEntry;
@synthesize gameOver = _gameOver;
@synthesize maxGuesses = _maxGuesses;
@synthesize wordLength = _wordLength;
@synthesize guessesRemaining=_guessesRemaining;
@synthesize newLetter = _newLetter;
@synthesize lettersGuessed=_lettersGuessed;
@synthesize wordList = _wordList;
@synthesize initialWordListArray = _initialWordListArray;
@synthesize newWordListArray = _newWordListArray;
@synthesize equivalenceClasses = _equivalenceClasses;
@synthesize newEquivalenceClasses = _newEquivalenceClasses;
@synthesize keyboardDisplayed = _keyboardDisplayed;
@synthesize successfulGuess = _successfulGuess;

#pragma mark - Game Setup

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // display countdown bar (#guesses remaining)
    self.guessesRemainingSlider.transform = CGAffineTransformRotate(_guessesRemainingSlider.transform, 1.5 * M_PI);
    self.guessesRemainingSlider.frame = CGRectMake(10, 75, 22, 140);
    //[self.guessesRemainingSlider setThumbImage:[UIImage imageNamed:@"slider_man.png"] forState:UIControlStateNormal];
    
    UIImage *hangmanImg = [UIImage imageNamed:@"slider_hangman.png"];
    //hangmanImg.transform = CGAffineTransformRotate(hangmanImg.transform, 1.5 * M_PI);
    
    [self.guessesRemainingSlider setThumbImage:hangmanImg forState:UIControlStateNormal];
    
    [self.guessesRemainingSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_bottom.png"] forState:UIControlStateNormal];
    
    // hide textField and display the keyboard when the app loads & start the game
    [self.textField setHidden:YES];
    [self.textField becomeFirstResponder];
    self.keyboardDisplayed = YES;

    // get initial word list (load words.plist into _newWordListArray)
    [self createInitialWordList];
    
    //start Game
    [self startGame];
    
}

- (void)createInitialWordList {
    //get words from plist & add to initialWordListArray
    WordList *wordList = [[WordList alloc] init];
    self.wordList = wordList;
    self.initialWordListArray = _wordList.words;
    
    [wordList release];
}

- (void)startGame {
    
    // set initial gamePlayState (used to indicate whether gamePlay is in progress)
    self.gameOver = NO;
    
    // set initial value for successfulGuess (will be used later to dictate message displayed to user)
    self.successfulGuess = NO;
    
    // set working list of words to initial word list (i.e. - full dictionary)
    self.newWordListArray = _initialWordListArray;
    
    // Get stored settings (from FlipsideView)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    
    // Get the stored value for max # of guesses & display initial # guesses, based on user's maxGuesses setting 
    _maxGuesses = [defaults integerForKey:@"maxGuesses"];
    NSString *guesses = [NSString stringWithFormat:@"%d", _maxGuesses];
    self.guessesRemainingLabel.text = [NSString stringWithFormat:@"%@", guesses];    
    self.guessesRemainingSlider.maximumValue = (long)_maxGuesses;
    self.guessesRemainingSlider.value = (long)(_maxGuesses - _maxGuesses);
    
    // Get the stored value for word length and display a blank word, with a dash for each letter   
    _wordLength = [defaults integerForKey:@"wordLength"];
    NSString *wordPlaceholder = [NSString stringWithFormat:@""];
    unichar blank = '-';    
    for (int i = 0; i < (int)_wordLength; i++){
        NSString *addBlank = [NSString stringWithFormat:@"%C", blank]; 
        wordPlaceholder = [wordPlaceholder stringByAppendingString: addBlank];
    }
    self.wordLabel.text = [NSString stringWithFormat:@"%@", wordPlaceholder];
    
    // Clear the lettersGuessed & lettersGuessedLabel
    _lettersGuessedLabel.text = [NSString stringWithFormat:@""];
    _lettersGuessed = nil;
    
    // Display a message to the user
    self.smallMessageLabel.text = [NSString stringWithFormat:@"game on!"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Settings (flipside view)

- (IBAction)showSetings:(id)sender {    
    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
    [self startGame];
    if(_keyboardDisplayed == NO) {
        [self toggleKeyboard];
    }
}

- (void)flipsideViewControllerCancel:(FlipsideViewController *)controller {    
    [self dismissModalViewControllerAnimated:YES];
    [self tryAgain];
    if(_keyboardDisplayed == NO) {
        [self toggleKeyboard];
    }
}

#pragma mark - Game Play: Actions

- (IBAction)newGuess:(id)sender {
    [self validateNewGuess];    
}

//background button is clicked
- (IBAction)toggleKeyboard:(id)sender {
    [self toggleKeyboard];
}

- (IBAction)newGame:(id)sender {
    [self startGame];
    if(_keyboardDisplayed == NO) {
        [self toggleKeyboard];
    }
}

#pragma mark - Game Play: methods

- (void)validateNewGuess {

    _validEntry = YES;
    
    // check whether there are any guesses remaining    
    int numGuessesRemaining = [self.guessesRemainingLabel.text intValue];
    if(_gameOver == YES){
        [self toggleKeyboard];        
        return;
    }
    
    // get new guess enterred by the user
    self.newLetter = self.textField.text;
    NSString *newGuess = [NSString stringWithFormat:@" %@", _newLetter];
    NSUInteger numLettersGuessed = 0; 
    
    // validate that entry is a single letter (1 character and no punctuation or numbers)
    NSUInteger length = [newGuess length];
    NSCharacterSet *alphaSet = [NSCharacterSet letterCharacterSet];
    BOOL invalidCharacter = [[newGuess stringByTrimmingCharactersInSet:alphaSet] isEqualToString:newGuess];
    
    if ((length - 1) == 1) {
        if (invalidCharacter == YES) {
            _validEntry = NO;
            self.smallMessageLabel.text = [NSString stringWithFormat:@"that wasn't a letter, try again"];
            [self tryAgain];
            return;
        } else {
            _validEntry = YES;
        }
    } else {
        // fails validation, prompt user to try another entry in order to continue game play
        _validEntry = NO;        
        return;
    }
    
    // if this is not the first guess, validate whether new guess is in letters already guessed
    if (self.lettersGuessed == nil) {    
        self.lettersGuessed = @"";
    } else {
        
        numLettersGuessed = [_lettersGuessed length];
        
        // iterate through letters in the string to determine whether new letter has already been guessed 
        for (int i = 1; i < (int)numLettersGuessed; i++){
            
            NSUInteger n = (NSUInteger)i;
            unichar letterGuessed = [[_lettersGuessed uppercaseString] characterAtIndex:n];                
            unichar newLetter = [[_newLetter uppercaseString] characterAtIndex:0];
            
            if((letterGuessed != newLetter) || (_lettersGuessed == @"") || (_lettersGuessed == nil)){                
                // passes validation, continue game play
                _validEntry = YES; 
            } else {
                // promt user to guess again
                self.smallMessageLabel.text = [NSString stringWithFormat:@"you already guessed that"];
                _validEntry = NO;                
                break;                
            }            
        }
    }
    
    if(_validEntry == YES) {
        
        numGuessesRemaining = [self.guessesRemainingLabel.text intValue];  
        if (numGuessesRemaining > 0) {
            // decrement number of guesses remaining and display
            numGuessesRemaining--;
            NSString *str = [NSString stringWithFormat:@"%d", numGuessesRemaining];
            self.guessesRemainingLabel.text = [NSString stringWithFormat:@"%@", str];
            self.guessesRemainingSlider.value = (long)(_maxGuesses - numGuessesRemaining);
            
            // stop game play if that was the last guess
            if (numGuessesRemaining == 0) {
                [self youLost];
                return;
            }
        }
        else {
            [self youLost];
            return;
        }
        
        // add new letter to letters guessed
        if (self.lettersGuessed == nil) {
            self.lettersGuessed = [newGuess uppercaseString];
        } else {
            self.lettersGuessed = [self.lettersGuessed stringByAppendingString: newGuess];  
            self.lettersGuessedLabel.text = [self.lettersGuessed uppercaseString]; 
        }
        
        [self createEquivalenceClasses];        
        
        // clear text field for a new guess 
        self.textField.text = nil;
        
    } else {
        // promt user to guess again
        [self tryAgain];
        return;
    }
    
}

- (void)createEquivalenceClasses {
     
    self.newEquivalenceClasses = [NSMutableDictionary dictionary];
    
    NSString *word = [NSString string];
    
    for (word in self.newWordListArray) {
               
        // get length of each word
        NSUInteger length = [word length];
        
        // get word length settings
        NSUInteger maxLength = (NSUInteger)_wordLength;
        
        //unichar letterGuessed = [[self.newLetter capitalizedString] characterAtIndex:0]; 
        unichar letterGuessed = [[self.newLetter uppercaseString] characterAtIndex:0];
        unichar notLetterGuessed = '-';
        
        NSString *wordKey = [[NSString alloc] initWithFormat:@""];
        
        // skip letters that are already fixed >> start with wordLabel (ex: --- or -E-) and only override if a hyphen
        NSString *displayedWord = self.wordLabel.text;
        
        // if word length matches the user settings, allocate it to the appropriate equivalence class        
        if (length == maxLength) { 
            
            // for word string (array of characters), get the value of character 0, 1, 2,... maxLength
            for (int i = 0; i < (int)maxLength; i++){
                
                NSUInteger n = (NSUInteger)i;
                unichar letterInWord = [word characterAtIndex:n];                
                unichar letterInDisplayedWord = [displayedWord characterAtIndex:n];
                
                if(letterInDisplayedWord == notLetterGuessed){
                
                    if (letterInWord == letterGuessed) {                   
                        // set character of KEY to letterGuessed
                        NSString *addChar = [NSString stringWithFormat:@"%C", letterGuessed]; 
                        wordKey = [wordKey stringByAppendingString: addChar];   
                        addChar = nil;
                    }
                    else if (letterInWord != letterGuessed) {                    
                        // set character of KEY to notLetterGuessed (hyphen)
                        NSString *addBlankChar = [NSString stringWithFormat:@"%C", notLetterGuessed]; 
                        wordKey = [wordKey stringByAppendingString: addBlankChar]; 
                        addBlankChar = nil;
                    }   
                    
                } else if (letterInDisplayedWord != notLetterGuessed) {
                    // set character of KEY to letter already confirmed
                    NSString *confirmedLetter = [NSString stringWithFormat:@"%C", letterInDisplayedWord]; 
                    wordKey = [wordKey stringByAppendingString: confirmedLetter]; 
                    confirmedLetter = nil;
                }
                
            }
            
            // if equivalance class exists, get array; else create array 
            // add word to array & add array (equivalence class) with KEY to newEquivalenceClasses NSMutableDictionary
                        
            if ([_newEquivalenceClasses valueForKey:wordKey] == nil) {
                NSMutableArray *equivClass = [NSMutableArray array];
                NSArray *tempArray = [NSArray array];
                [equivClass addObject: word]; 
                tempArray = equivClass;
                [_newEquivalenceClasses setObject:tempArray forKey:wordKey];
                                
                word = nil;
                wordKey = nil;
                equivClass = nil;
                [equivClass release];
                tempArray = nil;
                [tempArray autorelease];
                
            } else {
                NSMutableArray *equivClass = [_newEquivalenceClasses valueForKey:wordKey];
                NSArray *tempArray = [NSArray array];
                [equivClass addObject: word]; 
                tempArray = equivClass;
                [_newEquivalenceClasses setObject:tempArray forKey:wordKey];
                
                word = nil;
                wordKey = nil;
                equivClass = nil;
                [equivClass release];
                tempArray = nil;
                [tempArray autorelease];
            }

        } 

    }
    
    // set equivalence classes property to newEquivalenceClasses (NSMutableDictionary)        
    self.equivalenceClasses = _newEquivalenceClasses;
    
    _newEquivalenceClasses = nil;
    [_newEquivalenceClasses release];

    // find largest equivalence class
    NSDictionary *findLargestEquivalenceClass = [[NSDictionary alloc] init];
    findLargestEquivalenceClass = self.equivalenceClasses;
    
    int largestWordCount = 0;
    
    NSString *largestEquivClass = [NSString string];
    NSString *equivClassKey = [NSString string];
    
    // for...in (fast enumeration) through arrays to get length and sort in descending order; get largest (at index 0)
    for (equivClassKey in findLargestEquivalenceClass) {
    
        NSArray *equivClassArray = [NSArray array];
        equivClassArray = [_equivalenceClasses valueForKey:equivClassKey];
        
        NSUInteger wordCount = [equivClassArray count];
        
        if((int)wordCount > largestWordCount) {
            largestWordCount = (int)wordCount;
            largestEquivClass = equivClassKey;
            
            // set the new word list to the largest equivalence class
            self.newWordListArray = equivClassArray;
            
            equivClassArray = nil;
            [equivClassArray release];
        }
        
    }
    
    // display KEY of largest equivalence class in word label
    self.wordLabel.text = largestEquivClass; 
    
    /*///////////////////////////////////////////////////////////////////////////
    if word label contains the letter guessed, congratulate user
    ///////////////////////////////////////////////////////////////////////////*/
    
    // if newWordListArray is only one word & word label contains that word, display "you win" message and end game
    if (([_newWordListArray count] == 1) && ([[_newWordListArray objectAtIndex:0] isEqualToString: _wordLabel.text] == TRUE)) {
        [self youWon];
        return;
        
    } else {
        self.gameOver = NO;
        self.smallMessageLabel.text = [NSString stringWithFormat:@"guess another letter"];
    }
    

    [findLargestEquivalenceClass release];
    
    // TEST
    //NSLog(@"%@", _newWordListArray);    
}

- (void)tryAgain {    
    // clear text field for a new guess
    self.textField.text = nil;
}

- (void)toggleKeyboard {
    
    if ((_keyboardDisplayed == NO) && (_gameOver == NO)) {
        //display the keyboard 
        [_textField becomeFirstResponder];
        _keyboardDisplayed = YES;
    } else {
        [_textField resignFirstResponder];
        _keyboardDisplayed = NO;
        
        // clear text field for a new guess 
        self.textField.text = nil;
    }    
}

- (void)youLost {
    self.gameOver = YES;    
    self.smallMessageLabel.text = [NSString stringWithFormat:@"game over"];
    self.largeMessageLabel.text = [NSString stringWithFormat:@"Rematch?"];
    [self toggleKeyboard];            
    return;
}

- (void)youWon {
    self.gameOver = YES;
    self.smallMessageLabel.text = [NSString stringWithFormat:@"congratulations!"];
    self.largeMessageLabel.text = [NSString stringWithFormat:@"You won!"];
    [self toggleKeyboard];            
    return;
}

#pragma mark - View Life Cycle

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
        
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    _textField = nil;
    _guessesRemainingLabel = nil;
    _guessesRemainingSlider = nil;
    _lettersGuessedLabel = nil;
    _settingsButton = nil;
    _newGameButton = nil;
    _lettersGuessed = nil;
    _wordList = nil;
    _initialWordListArray = nil;
    _newWordListArray = nil;
    _equivalenceClasses = nil;
    _newEquivalenceClasses = nil;
    
    [super viewDidUnload];

}

- (void)dealloc {
    [_textField release];
    [_wordLabel release];
    [_guessesRemainingLabel release];
    [_guessesRemainingSlider release];
    [_lettersGuessedLabel release];
    [_settingsButton release];
    [_newGameButton release];
    [_lettersGuessed release];
    [_wordList release];
    [_initialWordListArray release];
    [_newWordListArray release];
    [_equivalenceClasses release];
    [_newEquivalenceClasses release];
    
    [super dealloc];
}

@end
