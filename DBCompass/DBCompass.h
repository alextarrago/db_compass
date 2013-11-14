//
//  DBCompass.h
//  DBLocationCompass
//
//  Created by Alex Tarrago on 11/13/13.
//  Copyright (c) 2013 Dribba Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kMetersToMiles  0.000621371192
#define kMetersToKM     1000

@protocol DBCompassDelegate <NSObject>

/*
 *      Method get called when the pointing direction has changed.
 */
- (void)    compass:(id)controller compassDidChangeHeading:(float)angle;

/*
 *      Method get called when the user is not pointing to the location in the range of pointingTolerance value.
 */
- (void)    compass:(id)controller compassIsNotPointingLocationWithError:(float)angle;

/*
 *      Method get called when the user is pointint to the location in the range of pointingTolerance value.
 */
- (void)    compass:(id)controller compassIsPointingLocationWithError:(float)angle;

/*
 *      Method get called when the geocoding process fails.
 */
- (void)    compass:(id)controller compassDidFailedLoadingAddressWithError:(NSError*)error;

/*
 *      Method get called then the geocoding process suceed.
 */
- (void)    compass:(id)controller compassDidSucceedLoadingAddress:(CLLocationCoordinate2D)location;

/*
 *      Method get called everytime the distance between the user's location and the pointing location changes.
 */
- (void)    compass:(id)controller distanceFromRemoteLocation:(float)distance;

@end


/*
 *      Change this value to NO to not be notified by NSLog events
 */
#warning Change to NO to not be notified (you can remove this warning line)
static BOOL const kCompassTesting = YES;


@interface DBCompass : NSObject <CLLocationManagerDelegate> {
    CLLocationManager   *locationManager;
    
    float               geoAngle;
    float               pointing_longitude;
    float               pointing_latitude;
}

@property (nonatomic, strong)   id <DBCompassDelegate> delegate;
@property (nonatomic, strong)   CLLocationManager *locationManager;

/*
 *      Assign the pointing to location value range.
 *      
 *      By default is set to 0.2
 */
@property (assign)              float pointingTolerance;
/*
 *      Assign this variable to YES to get the distance in Kilometers rather than Meters.
 *
 *      By default is set to NO
 */
@property (assign)              BOOL getDistanceInKilometers;
/*
 *      Assign this variable to YES to get the distance in Miles rather than Meters.
 *      
 *      By default is set to NO
 */
@property (assign)              BOOL getDistanceInMiles;


/*
 *      Inititates the compass with a simple CLLocationCoordinate2D structure.
 */
- (id)      initWithCoordinate:(CLLocationCoordinate2D)location;

/*
 *      Initiates the compass with a given address that will be geocoded. The dictionary has to contain the street name, the street number, the ZIP and the city or town to ensure the geocoding.
 */
- (id)      initWithAddress:(NSDictionary *)addressDictionary;


@end
