db_compass
==========

DBCompass helps you to develop iOS apps in which you need to determine the heading of the user's phone (refering to a coordinate) or the distance between the user and a given location.

## Requirements

You should add the following frameworks to your project in order to work with db_compass

    CoreLocation.framework
    UIKit.framework

## Description

DBCompass helps you to develop applications that requires the use of the user's heading direction or distance between some locations.
The object could be initialized by two different ways:

    DBCompass * compass = [[DBCompass alloc] initWithCoordinate:CLLocationCoordinate2D(41.3825, 2.17694);

or

    NSDictionary *dictionary = [[NSDicionary alloc] initWithObjects:@[@"street", @"number", @"zip_code", @"town", @"province"] forKeys:@[@"street", @"number", @"zip_code", @"town", @"province"]];
    DBCompass * compass = [[DBCompass alloc] initWithAddress:address_dictionary];

then just send the 'start' message to the object

    [compass start];

----

## Options

### Testing or Debugging process

    //Change this value to NO to not be notified by NSLog events
    static BOOL const kCompassTesting = YES;

### Behaviour options

If you want to set a range for the delegate to notify you when the user is pointing to location. **By default is set to 0.2**.

    [compass setPointingTolerance: 0.4];

If you want to get the distance between user's location and the coordinate given in Kilometers. **By default is set to NO.**

    [compass setGetDistanceInKilometers: YES];

If you want to get the distance between user's location and the coordinate given in Miles. **By default is set to NO.**

    [compass setGetDistanceInMiles: YES];


## Delegate Methods

DBCompass offers you some delegate methods to simplify your work

    - (void)    compass:(id)controller compassDidChangeHeading:(float)angle;
    - (void)    compass:(id)controller compassIsNotPointingLocationWithError:(float)angle;
    - (void)    compass:(id)controller compassIsPointingLocationWithError:(float)angle;
    - (void)    compass:(id)controller compassDidFailedLoadingAddressWithError:(NSError*)error;
    - (void)    compass:(id)controller compassDidSucceedLoadingAddress:(CLLocationCoordinate2D)location;
    - (void)    compass:(id)controller distanceFromRemoteLocation:(float)distance;

LICENSE
==========

Licensed under Apache License v2.0. A copy can be found inside this folder.