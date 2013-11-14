//
//  DBViewController.m
//  DBLocationCompass
//
//  Created by Alex Tarrago on 11/13/13.
//  Copyright (c) 2013 Dribba Development. All rights reserved.
//

#import "DBViewController.h"

@implementation DBViewController

@synthesize compass = _compass;

- (void)    viewDidLoad
{
    [super viewDidLoad];
    
    /* Initiate with a coordinate */
    //NSString *latitude = @"41.3825";
    //NSString *longitude = @"2.1769444444444";
    //[_latitude setText:latitude];
    //[_longitude setText:longitude];
    //compass   = [[DBCompass alloc] initWithCoordinate:CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue])];
    
    /* Initiate with an address */
    NSDictionary *addressDictionary = [[NSDictionary alloc] initWithObjects:@[@"Charles Darwin", @"66", @"08329", @"Teia", @"Barcelona"] forKeys:@[@"Street", @"Number", @"ZIP", @"Town", @"Province"]];
    compass     = [[DBCompass alloc] initWithAddress:addressDictionary];
    
    [compass setPointingTolerance:0.2];
    [compass setGetDistanceInKilometers:YES];
    [compass setDelegate:self];
}


#pragma mark - 
#pragma mark DBCompassDelegate
- (void)    compass:(id)controller compassIsPointingLocationWithError:(float)angle
{
    [_label3 setHidden:NO];
    [_label2 setHidden:YES];
}

- (void)    compass:(id)controller compassIsNotPointingLocationWithError:(float)angle
{
    [_label3 setHidden:YES];
    [_label2 setHidden:NO];
}

- (void)    compass:(id)controller compassDidFailedLoadingAddressWithError:(NSError *)error
{
#warning Handle the error for not getting the coordinate from geocoding.
    NSLog(@"Error: %@", [error description]);
}

- (void)    compass:(id)controller compassDidSucceedLoadingAddress:(CLLocationCoordinate2D)location
{
    [_latitude setText:[NSString stringWithFormat:@"%f", location.latitude]];
    [_longitude setText:[NSString stringWithFormat:@"%f", location.longitude]];
}

- (void)    compass:(id)controller compassDidChangeHeading:(float)angle
{
    [_label1 setText:[NSString stringWithFormat:@"%4f", angle]];
    [_directionImage setTransform:CGAffineTransformMakeRotation(angle)];
}

- (void)    compass:(id)controller distanceFromRemoteLocation:(float)distance
{
    [_distance setText:[NSString stringWithFormat:@"%f", distance]];
}


@end
