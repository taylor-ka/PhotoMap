//
//  PhotoAnnotation.h
//  PhotoMap
//
//  Created by taylorka on 7/8/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

// PhotoAnnotation.h
#import <Foundation/Foundation.h>
@import MapKit;

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) UIImage *photo;

@end
