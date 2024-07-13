#import "SimpleViewController.h"

@interface SimpleViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set background color
    self.view.backgroundColor = [UIColor whiteColor];

    // Initialize and configure the label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 220, 40)];
    self.label.text = @"Hello, World!";
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];

    // Initialize and configure the button
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(100, 200, 120, 40);
    [self.button setTitle:@"Change Text" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

- (void)buttonTapped {
    self.label.text = @"Text Changed!";
}

@end
