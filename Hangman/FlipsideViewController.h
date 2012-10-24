//
//  FlipsideViewController.h
//  Hangman
//
//  Gina Luciano (HUID: 90846027)
//  Harvard Extension Course CS76
//  luciano.gina@gmail.com
//
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)flipsideViewControllerCancel:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *wordLengthLabel;
@property (nonatomic, retain) IBOutlet UISlider *wordLengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *maxGuessesLabel;
@property (nonatomic, retain) IBOutlet UISlider *maxGuessesSlider;
@property (nonatomic, retain) IBOutlet UIButton *background;


- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)displayWordLength:(id)sender;
- (void)displayWordLength;
- (IBAction)displayMaxGuesses:(id)sender;
- (void)displayMaxGuesses;

@end
