/*
 DSLCalendarDayView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLCalendarDayView.h"
#import "NSDate+DSLCalendarView.h"


@interface DSLCalendarDayView ()

@end


@implementation DSLCalendarDayView {
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
}


#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
        _positionInWeek = DSLCalendarDayViewMidWeek;
    }
    
    return self;
}


#pragma mark Properties

- (void)setSelectionState:(DSLCalendarDayViewSelectionState)selectionState {
    _selectionState = selectionState;
    [self setNeedsDisplay];
}

- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _labelText = [NSString stringWithFormat:@"%ld", (long)day.day];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents* aDayComponents = [calendar components:unitFlags fromDate:_dayAsDate];
    
    if ([nowComponents day] == [aDayComponents day]
        && [nowComponents month] == [aDayComponents month]
        && [nowComponents year] == [aDayComponents year]) {
        
        _inCurrentDay = YES;
    }
    else {
        _inCurrentDay = NO;
    }
    
    _day = nil;
}

- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}

- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
    if ([self isMemberOfClass:[DSLCalendarDayView class]]) {
        // If this isn't a subclass of DSLCalendarDayView, use the default drawing
        [self drawBackground];
        [self drawBorders];
        [self drawDayNumber];
    }
}


#pragma mark Drawing

- (void)drawBackground {
    

    
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        
        if (self.isInCurrentMonth) {
            
            if (self.isInCurrentDay) {
                [[UIColor colorWithWhite:245.0/255.0 alpha:1.0] setFill];
            
                [[UIImage imageNamed:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];
            }
            else {
                [[UIColor colorWithWhite:245.0/255.0 alpha:1.0] setFill];
            }
        }
        
        else {
            if (self.isInCurrentDay) {
                [[UIColor colorWithWhite:245.0/255.0 alpha:1.0] setFill];
                
                [[UIImage imageNamed:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];

            }
            else {
                [[UIColor colorWithWhite:245.0/255.0 alpha:1.0] setFill];
            }
        }
//        UIRectFill(self.bounds);
    }
    else {
        
        switch (self.selectionState) {
            case DSLCalendarDayViewNotSelected:
                if (self.isInCurrentDay) {
                    
                    UIImage* dotCurrentDayImage = [UIImage imageNamed:@"DSLCalendarDaySelectionCurrentDay"];
                    
                    [dotCurrentDayImage drawInRect:self.bounds];
                }
                break;
                
            case DSLCalendarDayViewStartOfSelection:
                if (self.isInCurrentDay) {
                    
                    [[self blendImage:@"DSLCalendarDaySelection-left" andImage:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];
                }
                else {
                    [[UIImage imageNamed:@"DSLCalendarDaySelection-left"] drawInRect:self.bounds];
                }
                
                break;
                
            case DSLCalendarDayViewEndOfSelection:
                if (self.isInCurrentDay) {
                    
                    [[self blendImage:@"DSLCalendarDaySelection-right" andImage:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];
                }
                else {
                    [[UIImage imageNamed:@"DSLCalendarDaySelection-right"] drawInRect:self.bounds];
                }
                
                break;
                
            case DSLCalendarDayViewWithinSelection:
                if (self.isInCurrentDay) {
                    
                    
                    [[self blendImage:@"DSLCalendarDaySelection-middle" andImage:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];
                    
                }
                else {
                    [[UIImage imageNamed:@"DSLCalendarDaySelection-middle"] drawInRect:self.bounds];
                }
                
                break;
                
            case DSLCalendarDayViewWholeSelection:
                if (self.isInCurrentDay) {
                    
                    
                    [[self blendImage:@"DSLCalendarDaySelection" andImage:@"DSLCalendarDaySelectionCurrentDay"] drawInRect:self.bounds];
                }
                else {
                    [[UIImage imageNamed:@"DSLCalendarDaySelection"] drawInRect:self.bounds];
                }
                
                break;
        }
    }
}

- (void)drawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:255.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.5, 0.5);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    if (self.isInCurrentMonth) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:185.0/255.0 alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.0, self.bounds.size.height - 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawDayNumber {
        
    if (DSLCalendarDayViewNotSelected != self.selectionState) {
        [[UIColor whiteColor] set];
    }
    else  {
        [[UIColor colorWithWhite:66.0/255.0 alpha:1.0] set];
    }
    
    UIFont *textFont = [UIFont boldSystemFontOfSize:17.0];
    CGSize textSize = [_labelText sizeWithFont:textFont];
    
    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)), ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    [_labelText drawInRect:textRect withFont:textFont];
}


-(UIImage*) blendImage:(UIImage*)firstImageName andImage:(UIImage*)secondImageName {
    
    UIImage* bgImage = [UIImage imageNamed:firstImageName];
    UIImage* fgImage = [UIImage imageNamed:secondImageName];
    
    // bgImage
    CGImageRef bgImageRef = bgImage.CGImage;
    CGFloat bgWidth = CGImageGetWidth(bgImageRef);
    CGFloat bgHeight = CGImageGetHeight(bgImageRef);
    
    // fgImage
    CGImageRef fgImageRef = fgImage.CGImage;
    CGFloat fgWidth = CGImageGetWidth(fgImageRef);
    CGFloat fgHeight = CGImageGetHeight(fgImageRef);
    
    CGSize mergedSize = CGSizeMake(bgWidth, bgHeight);
    
    UIGraphicsBeginImageContextWithOptions(mergedSize, YES, 0.0);
    
    // Draw images onto the context
    [bgImage drawInRect:CGRectMake(0, 0, bgWidth, bgHeight)];
    [fgImage drawInRect:CGRectMake(0, 0, fgWidth, fgHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

