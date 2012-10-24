//
//  FlipsideViewController.m
//  Hangman
//
//  Gina Luciano (HUID: 90846027)
//  Harvard Extension Course CS76
//  luciano.gina@gmail.com
//
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize wordLengthLabel = _wordLengthLabel;
@synthesize wordLengthSlider = _wordLengthSlider;
@synthesize maxGuessesLabel = _maxGuessesLabel;
@synthesize maxGuessesSlider = _maxGuessesSlider;
@synthesize background = _background;

#pragma mark - Settings View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor]; 
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int maxGuesses = [defaults integerForKey:@"maxGuesses"];
    int wordLength = [defaults integerForKey:@"wordLength"];
    
    self.maxGuessesSlider.value = (long)maxGuesses;
    self.wordLengthSlider.value = (long)wordLength;
    [self.maxGuessesSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_pink.png"] forState:UIControlStateNormal];
    [self.maxGuessesSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.wordLengthSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_pink.png"] forState:UIControlStateNormal];
    [self.wordLengthSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    
    //display current settings
    [self displayWordLength];
    [self displayMaxGuesses];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)save:(id)sender {    
    
    // Store settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    int maxGuesses = (int)self.maxGuessesSlider.value;
    int wordLength = (int)self.wordLengthSlider.value;
    
    [defaults setInteger: maxGuesses forKey:@"maxGuesses"];
    [defaults setInteger: wordLength forKey:@"wordLength"];
    
    [defaults synchronize];
    
    // Display MainView with new settings (and start new game)
    [self.delegate flipsideViewControllerDidFinish:self];
    
}

- (IBAction)cancel:(id)sender {    
    
    // Display MainView without saving settings (and continue game in progress)
    [self.delegate flipsideViewControllerCancel:self];
    
}

- (IBAction)displayWordLength:(id)sender {
    
    // Display value of slider in wordLengthLabel
    [self displayWordLength];
}

- (void)displayWordLength {
    
    NSString *wordLengthStr = [NSString stringWithFormat:@"Word length: %d", (int)self.wordLengthSlider.value];
    self.wordLengthLabel.text = wordLengthStr;    
}

- (IBAction)displayMaxGuesses:(id)sender {
    
    // Display value of slider in wordLengthLabel
    [self displayMaxGuesses];
}

- (void)displayMaxGuesses {
    
    NSString *maxGuessesStr = [NSString stringWithFormat:@"Maximum number of guesses: %d", (int)self.maxGuessesSlider.value];
    self.maxGuessesLabel.text = maxGuessesStr;    
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
    _wordLengthLabel = nil;
    _wordLengthSlider = nil;
    _maxGuessesLabel = nil;
    _maxGuessesSlider = nil;    
    
    [super viewDidUnload];
}

- (void)dealloc {
    [_wordLengthLabel release];
    [_wordLengthSlider release];
    [_maxGuessesLabel release];
    [_maxGuessesSlider release];
    
    [super dealloc];
}

@end
