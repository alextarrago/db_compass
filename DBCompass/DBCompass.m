//
//  DBCompass.m
//  DBLocationCompass
//
//  Created by Alex Tarrago on 11/13/13.
//  Copyright (c) 2013 Dribba Development. All rights reserved.
//

#import "DBCompass.h"

@implementation DBCompass

@synthesize locationManager = _locationManager;

#pragma mark -
#pragma mark Class Methods
- (id)      initWithCoordinate:(CLLocationCoordinate2D) location
{
    if (self = [super init]) {
        pointing_latitude           = location.latitude;
        pointing_longitude          = location.longitude;
        _pointingTolerance          = 0.2;
        _getDistanceInKilometers    = FALSE;
        _getDistanceInMiles         = FALSE;
        [self start];
    }
    return self;
}

- (id)      initWithAddress:(NSDictionary *)addressDictionary
{
    if (self = [super init]) {
        _pointingTolerance          = 0.2;
        _getDistanceInKilometers    = FALSE;
        _getDistanceInMiles         = FALSE;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        if (kCompassTesting) NSLog(@"Start geocoding...");
        
        [geocoder geocodeAddressDictionary:addressDictionary completionHandler:^(NSArray *placemarks, NSError *error)
        {
            for (CLPlacemark *placemark in placemarks)
            {
                if (kCompassTesting) NSLog(@"Placemark found...");
                if (kCompassTesting) NSLog(@"Setting coordinate...");
                
                pointing_longitude  = placemark.location.coordinate.longitude;
                pointing_latitude   = placemark.location.coordinate.latitude;
            }
            
            if  (error)
            {
                if (kCompassTesting) NSLog(@"Geocoding has given an error. 'compassDidFailedLoadingAddressWithError' has been triggered.");
                
                [[self delegate] compass:self compassDidFailedLoadingAddressWithError:error];
            }
            else
            {
                if (kCompassTesting) NSLog(@"All perfect!");
                [[self delegate] compass:self compassDidSucceedLoadingAddress:CLLocationCoordinate2DMake(pointing_latitude, pointing_longitude)];
                [self start];
            }
        }];
    }
    return self;
}

- (void)    start
{
    if (kCompassTesting) NSLog(@"---");
    if (kCompassTesting) NSLog(@"Setting the compass attributes...");
    
    geoAngle = 0;
    self.locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    [[self locationManager] startUpdatingHeading];
    
    if (kCompassTesting) NSLog(@"Starting compass");
    if (kCompassTesting) NSLog(@"---");
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)    locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    geoAngle = [self setLatLonForDistanceAndAngle:[locations objectAtIndex:0] withRemoteLat:pointing_latitude andLong:pointing_longitude];
    if (_getDistanceInMiles)
    {
         [[self delegate] compass:self distanceFromRemoteLocation:[self getDistanceBetweenUserLocationAndRemoteLocation] * kMetersToMiles];
    }
    else
    {
        if (_getDistanceInKilometers)
        {
            [[self delegate] compass:self distanceFromRemoteLocation:[self getDistanceBetweenUserLocationAndRemoteLocation]/kMetersToKM];
        }
        else
        {
            [[self delegate] compass:self distanceFromRemoteLocation:[self getDistanceBetweenUserLocationAndRemoteLocation]];
        }
    }
}

- (void)    locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    float direction =   -[newHeading magneticHeading];
    float newAngle  =   direction * (M_PI / 180);

    [[self delegate] compass:self compassDidChangeHeading:newAngle + geoAngle];
    
    if (geoAngle >= -newAngle - _pointingTolerance && geoAngle <= -newAngle + _pointingTolerance)
    {
        [[self delegate] compass:self compassIsPointingLocationWithError:geoAngle + newAngle];
    }
    else
    {
        [[self delegate] compass:self compassIsNotPointingLocationWithError:geoAngle + newAngle];
    }
}

- (float)   setLatLonForDistanceAndAngle:(CLLocation *)userlocation withRemoteLat:(float)lat andLong:(float)lon
{
    float latitude          = [self degreesToRadians:[userlocation coordinate].latitude];
    float longitude         = [self degreesToRadians:[userlocation coordinate].longitude];
    
    float newLatitude       = [self degreesToRadians:lat];
    float newLongitude      = [self degreesToRadians:lon];
    
    float dLon = newLongitude - longitude;
    
    float y = sin(dLon) * cos(newLatitude);
    float x = cos(latitude) * sin(newLatitude) - sin(latitude) * cos(newLatitude) * cos(dLon);
    
    float radiansBearing    = atan2(y, x);
    
    if (radiansBearing < 0.0) radiansBearing += 2 * M_PI;
    
    return radiansBearing;
}

- (float)   getDistanceBetweenUserLocationAndRemoteLocation
{
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:pointing_latitude longitude:pointing_longitude];
    
    CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    
    return [firstLocation distanceFromLocation:secondLocation];
}


#pragma mark -
#pragma mark Other math stuff
- (float)   degreesToRadians:(float)degrees
{
    return (degrees * M_PI / 180.0);
}

- (float)   radiansToDegrees:(float)radians
{
    return (radians * 180.0 / M_PI);
}


@end
