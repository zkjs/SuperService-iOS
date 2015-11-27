//
//  EMBubbleView+Card.m
//  SVIP
//
//  Created by Hanton on 11/25/15.
//  Copyright © 2015 zkjinshi. All rights reserved.
//

#import "EMBubbleView+Card.h"

@implementation EaseBubbleView (Card)

#pragma mark - private

- (void)_setupCardBubbleMarginConstraints
{
  NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.locationImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
  NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.locationImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
  NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.locationImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
  NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.locationImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
  
  [self.marginConstraints removeAllObjects];
  [self.marginConstraints addObject:marginTopConstraint];
  [self.marginConstraints addObject:marginBottomConstraint];
  [self.marginConstraints addObject:marginLeftConstraint];
  [self.marginConstraints addObject:marginRightConstraint];
  
  [self addConstraints:self.marginConstraints];
}

- (void)_setupCardBubbleConstraints
{
  [self _setupCardBubbleMarginConstraints];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeHeight multiplier:0.3 constant:0]];
}

#pragma mark - public

- (void)setupCardBubbleView
{
  self.locationImageView = [[UIImageView alloc] init];
  self.locationImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.locationImageView.backgroundColor = [UIColor clearColor];
  [self.backgroundImageView addSubview:self.locationImageView];
  
  self.locationLabel = [[UILabel alloc] init];
  self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.locationLabel.numberOfLines = 2;
  self.locationLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
  [self.locationImageView addSubview:self.locationLabel];
  
  [self _setupCardBubbleConstraints];
}

- (void)updateCardMargin:(UIEdgeInsets)margin
{
  if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
    return;
  }
  _margin = margin;
  
  [self removeConstraints:self.marginConstraints];
  [self _setupCardBubbleMarginConstraints];
}

@end
