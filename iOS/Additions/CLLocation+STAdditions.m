//
//  CLLocation+STAdditions.m
//
//  Created by Buzz Andersen on 3/8/11.
//  Copyright 2011 System of Touch. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "STUtils.h"


@implementation CLLocation (STAdditions)

- (BOOL)isZero;
{
    CLLocationCoordinate2D coordinates = self.coordinate;
    return coordinates.latitude == 0.0 && coordinates.longitude == 0.0;
}

// This will generate a Geo-Position header based on the draft RFC:
// http://tools.ietf.org/html/draft-daviel-http-geo-header-05
- (NSString *)HTTPHeaderValue;
{
    // cache the header formatter since we need it each time
    static NSNumberFormatter *HTTPHeaderFormatter = nil;
    if (!HTTPHeaderFormatter) {
        HTTPHeaderFormatter = [[NSNumberFormatter alloc] init];
        [HTTPHeaderFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    NSMutableString *headerValue = [[[NSMutableString alloc] init] autorelease];
    CLLocationCoordinate2D coordinate = self.coordinate;
    NSString *latitude = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:coordinate.latitude]];
    NSString *longitude = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:(coordinate.longitude)]];
    NSString *altitude = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:self.altitude]];
    [headerValue appendFormat:@"%@;%@;%@", latitude, longitude, altitude];
    
    // A negative value indicates that the coordinate’s latitude and longitude are invalid.
    CLLocationAccuracy locationAccuracy = self.horizontalAccuracy;
    if (locationAccuracy >= 0.0) {
        NSString *accuracy = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:locationAccuracy]];
        [headerValue appendFormat:@" epu=%@", accuracy];
    }
    
    // A negative value indicates an invalid direction.
    CLLocationDirection locationDirection = self.course;
    if (locationDirection >= 0.0) {
        NSString *direction = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:locationDirection]];
        [headerValue appendFormat:@" hdn=%@", direction];
    }
    
    // A negative value indicates an invalid speed.
    CLLocationSpeed locationSpeed = self.speed;
    if (locationSpeed >= 0.0) {
        NSString *speed = [HTTPHeaderFormatter stringFromNumber:[NSNumber numberWithDouble:locationSpeed]];
        [headerValue appendFormat:@" spd=%@", speed];
    }
    
    return headerValue;
}

@end
