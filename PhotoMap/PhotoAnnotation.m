//
//  PhotoAnnotation.m
//  PhotoMap
//
//  Created by taylorka on 7/8/19.
//  Copyright © 2019 Codepath. All rights reserved.
//


// PhotoAnnotation.m
#import "PhotoAnnotation.h"

@interface PhotoAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation PhotoAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%.2f, %.2f", self.coordinate.latitude, self.coordinate.longitude];
}



@end
