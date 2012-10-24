//
//  WordList.m
//  Hangman
//
//  Gina Luciano (HUID: 90846027)
//  Harvard Extension Course CS76
//  luciano.gina@gmail.com
//
//

#import "WordList.h"

@implementation WordList

@synthesize words = _words;
//@synthesize newWordListArray = _newWordListArray;
//@synthesize equivalenceClasses = _equivalenceClasses;

- (id)init
{
    self = [super init];
    if (self) {        
        // load words
        NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
        NSArray *words = [NSArray arrayWithContentsOfFile:path];
        self.words = words;
        
        [words release];
    }
    
    return self;
}

- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}

/*
- (void)createEquivalenceClasses {
    
    NSMutableDictionary *newEquivalenceClasses = [[NSMutableDictionary dictionary] retain];
    NSString *word = [NSString string];
    
    for (word in self.newWordListArray) {
        
        // array for equivalence class
        //NSMutableArray *equivClass = [[NSMutableArray alloc] init];
        //NSMutableArray *equivClass = [[NSMutableArray array] retain];
        //NSMutableArray *equivClass = [NSMutableArray array];
        
        // get length of each word
        NSUInteger length = [word length];
        
        // get word length settings
        NSUInteger maxLength = (NSUInteger)_wordLength;
        
        unichar letterGuessed = [[self.newLetter capitalizedString] characterAtIndex:0];
        unichar notLetterGuessed = '-';
        
        NSString *wordKey = [[NSString alloc] initWithFormat:@""];
        
        // skip letters that are already fixed >> start with wordLabel (ex: --- or -E-) and only override if a hyphen
        NSString *currentWord = self.wordLabel.text;
        
        // if word length matches the user settings, allocate it to the appropriate equivalence class        
        if (length == maxLength) { 
            
            // for word string (array of characters), get the value of character 0, 1, 2,... maxLength
            for (int i = 0; i < (int)maxLength; i++){
                
                NSUInteger n = (NSUInteger)i;
                unichar letterInWord = [word characterAtIndex:n];                
                unichar letterInCurrentWord = [currentWord characterAtIndex:n];
                
                if(letterInCurrentWord == notLetterGuessed){
                    
                    if (letterInWord == letterGuessed) {                   
                        // set character of KEY to letterGuessed
                        NSString *addChar = [NSString stringWithFormat:@"%C", letterGuessed]; 
                        wordKey = [wordKey stringByAppendingString: addChar];   
                        //[addChar autorelease];
                    }
                    else if (letterInWord != letterGuessed) {                    
                        // set character of KEY to notLetterGuessed (hyphen)
                        NSString *addBlankChar = [NSString stringWithFormat:@"%C", notLetterGuessed]; 
                        wordKey = [wordKey stringByAppendingString: addBlankChar]; 
                        //[addBlankChar release];
                    }   
                    
                } else if (letterInCurrentWord != notLetterGuessed) {
                    // set character of KEY to letter already confirmed
                    NSString *confirmedLetter = [NSString stringWithFormat:@"%C", letterInCurrentWord]; 
                    wordKey = [wordKey stringByAppendingString: confirmedLetter]; 
                    //[confirmedLetter release];
                }
                
            }
            
            // if equivalance class exists, get array; else create array 
            // add word to array & add array (equivalence class) with KEY to newEquivalenceClasses NSMutableDictionary
            
            if ([newEquivalenceClasses valueForKey:wordKey] == nil) {
                NSMutableArray *equivClass = [NSMutableArray array];
                [equivClass addObject: word]; 
                [newEquivalenceClasses setObject:equivClass forKey:wordKey];
                
                
            } else {
                NSMutableArray *equivClass = [NSMutableArray array];
                equivClass = [newEquivalenceClasses valueForKey:wordKey];
                //equivClass = [newEquivalenceClasses valueForKey:wordKey];
                [equivClass addObject: word]; 
                [newEquivalenceClasses setObject:equivClass forKey:wordKey];
            }
            
        } 
        
    }
    
    // set equivalence classes property to newEquivalenceClasses (NSMutableDictionary)    
    self.equivalenceClasses = [newEquivalenceClasses retain];      
    
    // find largest equivalence class
    NSDictionary *sortEquivalenceClasses = [[NSDictionary alloc] init];
    sortEquivalenceClasses = self.equivalenceClasses;
    
    int largestWordCount = 0;
    //NSString *largestEquivClass = [[NSString alloc]init];
    NSString *largestEquivClass = [NSString string];
    NSString *equivClassKey = [NSString string];
    
    // for...in (fast enumeration) through arrays to get length and sort in descending order; get largest (at index 0)
    for (equivClassKey in sortEquivalenceClasses) {
        
        NSArray *equivClassArray = [[NSArray alloc] init];
        equivClassArray = [_equivalenceClasses valueForKey:equivClassKey];
        
        NSUInteger wordCount = [equivClassArray count];
        
        if((int)wordCount > largestWordCount) {
            largestWordCount = (int)wordCount;
            largestEquivClass = equivClassKey;
            
            // set the new word list to the largest equivalence class
            self.newWordListArray = equivClassArray;
        }
        
        [equivClassArray release];
    }
    
    // display KEY of largest equivalence class in word label
    self.wordLabel.text = largestEquivClass;
    
    // if newWordListArray is only one word & word label contains that word, display "you win" message and end game
    if (([_newWordListArray count] == 1) && ([[_newWordListArray objectAtIndex:0] isEqualToString: _wordLabel.text] == TRUE)) {
        NSLog(@"You win");
        self.gameOver = YES;
        return;
        
    } else {
        NSLog(@"Keep playing");
        self.gameOver = NO;
    }
    
    //[newEquivalenceClasses release];
    [sortEquivalenceClasses release];
    
    // TEST
    //NSLog(@"%@", _newWordListArray);    
}
 */

@end
