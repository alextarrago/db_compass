//
//  DBViewController.h
//  DBLocationCompass
//
//  Created by Alex Tarrago on 11/13/13.
//  Copyright (c) 2013 Dribba Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCompass.h"

@interface DBViewController : UIViewController <DBCompassDelegate> {
    DBCompass *compass;
}

@property (nonatomic, strong) DBCompass *compass;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIImageView *directionImage;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
