//
//  HSGlobalState.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSGlobalState.h"

#define kGameType  @"Game Type"
#define kTheme     @"Theme"
#define kBoardSize @"Board Size"
#define kBestScore @"Best Score"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface HSGlobalState ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, readwrite) NSInteger winningLevel;
@property (nonatomic, readwrite) NSInteger tileSize;
@property (nonatomic, readwrite) NSInteger borderWidth;
@property (nonatomic, readwrite) NSInteger cornerRadius;
@property (nonatomic, readwrite) NSInteger horizontalOffset;
@property (nonatomic, readwrite) NSInteger verticalOffset;
@property (nonatomic, readwrite) NSTimeInterval animationDuration;
@property (nonatomic, readwrite) HSGameType gameType;
@property (nonatomic) NSInteger theme;

@end


@implementation HSGlobalState

+ (HSGlobalState *)state
{
    static HSGlobalState *state = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        state = [[HSGlobalState alloc] init];
    });
    
    return state;
}


- (instancetype)init
{
    if (self = [super init]) {
        [self setupDefaultState];
        [self loadGlobalState];
    }
    return self;
}

- (void)setupDefaultState
{
    NSDictionary *defaultValues = @{kGameType: @0,
                                    kTheme: @0,
                                    kBoardSize: @1,
                                    kBestScore: @0,
                                    };
  [Settings registerDefaults:defaultValues];
}

- (void)loadGlobalState
{
    self.dimension = [Settings integerForKey:kBoardSize] + 7;
    self.borderWidth = 5;
    self.cornerRadius = 4;
    self.animationDuration = 0.1;
    self.gameType = [Settings integerForKey:kGameType];
    self.horizontalOffset = [self horizontalOffset];
    self.verticalOffset = [self verticalOffset];
    self.theme = [Settings integerForKey:kTheme];
    self.needRefresh = NO;
}


- (NSInteger)tileSize
{
    return 30;
}


- (NSInteger)horizontalOffset
{
    CGFloat width = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth;
    return ([[UIScreen mainScreen] bounds].size.width - width) / 2;
}


- (NSInteger)verticalOffset
{
    CGFloat height = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth + 120;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}


- (NSInteger)winningLevel
{
    if (GSTATE.gameType == HSGameTypePowerOf3) {
        switch (self.dimension) {
            case 3: return 4;
            case 4: return 5;
            case 5: return 6;
            default: return 5;
        }
    }
    
    NSInteger level = 11;
    if (self.dimension == 3) return level - 1;
    if (self.dimension == 5) return level + 2;
    return level;
}


- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2
{
    if (self.gameType == HSGameTypeFibonacci) {
        return abs((int)level1 - (int)level2) == 1;
    }
    return level1 == level2;
}


- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2
{
    if (![self isLevel:level1 mergeableWithLevel:level2]) return 0;
    
    if (self.gameType == HSGameTypeFibonacci) {
        return (level1 + 1 == level2) ? level2 + 1 : level1 + 1;
    }
    return level1 + 1;
}


- (NSInteger)valueForLevel:(NSInteger)level
{
    if (self.gameType == HSGameTypeFibonacci) {
        NSInteger a = 1;
        NSInteger b = 1;
        for (NSInteger i = 0; i < level; i++) {
            NSInteger c = a + b;
            a = b;
            b = c;
        }
        return b;
    } else {
        NSInteger value = 1;
        NSInteger base = self.gameType == HSGameTypePowerOf2 ? 2 : 3;
        for (NSInteger i = 0; i < level; i++) {
            value *= base;
        }
        return value;
    }
}

- (UIColor *)colorForLevel:(NSInteger)level
{
    //return [[M2Theme themeClassForType:self.theme] colorForLevel:level];
    
    switch (level) {
        case 1:
            return RGB(238, 228, 218);
        case 2:
            return RGB(237, 224, 200);
        case 3:
            return RGB(242, 177, 121);
        case 4:
            return RGB(245, 149, 99);
        case 5:
            return RGB(246, 124, 95);
        case 6:
            return RGB(246, 94, 59);
        case 7:
            return RGB(237, 207, 114);
        case 8:
            return RGB(237, 204, 97);
        case 9:
            return RGB(237, 200, 80);
        case 10:
            return RGB(237, 197, 63);
        case 11:
            return RGB(237, 194, 46);
        case 12:
            return RGB(173, 183, 119);
        case 13:
            return RGB(170, 183, 102);
        case 14:
            return RGB(164, 183, 79);
        case 15:
        default:
            return RGB(161, 183, 63);
    }
}


- (UIColor *)textColorForLevel:(NSInteger)level
{
    switch (level) {
        case 1:
        case 2:
            return RGB(118, 109, 100);
        default:
            return [UIColor whiteColor];
    }
}

- (CGFloat)textSizeForValue:(NSInteger)value
{
    NSInteger offset = self.dimension == 5 ? 2 : 0;
    if (value < 100) {
        return 32 - offset;
    } else if (value < 1000) {
        return 28 - offset;
    } else if (value < 10000) {
        return 24 - offset;
    } else if (value < 100000) {
        return 20 - offset;
    } else if (value < 1000000) {
        return 16 - offset;
    } else {
        return 13 - offset;
    }
}


# pragma mark - Position to point conversion

- (CGPoint)locationOfPosition:(HSPosition)position
{
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset,
                       [self yLocationOfPosition:position] + self.verticalOffset);
}


- (CGFloat)xLocationOfPosition:(HSPosition)position
{
    return position.y * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}


- (CGFloat)yLocationOfPosition:(HSPosition)position
{
    return position.x * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}


- (CGVector)distanceFromPosition:(HSPosition)oldPosition toPosition:(HSPosition)newPosition
{
    CGFloat unitDistance = GSTATE.tileSize + GSTATE.borderWidth;
    return CGVectorMake((newPosition.y - oldPosition.y) * unitDistance,
                        (newPosition.x - oldPosition.x) * unitDistance);
}



@end
