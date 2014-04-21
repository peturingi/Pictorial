//
//  ExternalViewController.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 21/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "ExternalViewController.h"

@implementation ExternalViewController
-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if(self){
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
