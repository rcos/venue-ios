//
//  AXMapTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXMapTableViewCell.h"
#import <MapKit/MapKit.h>

@interface AXMapTableViewCell () {
	MKMapView* mapView;
	MKPointAnnotation* annotation;
}
@end

@implementation AXMapTableViewCell

- (instancetype)init
{
	self = [super init];
	if (self) {
        mapView    = [[MKMapView alloc] init];
        annotation = [[MKPointAnnotation alloc] init];
        
        [mapView setUserInteractionEnabled:NO];
        [mapView setShowsUserLocation:YES];
        [mapView addAnnotation:annotation];
		[mapView setDelegate:self];
        
		[self.view addSubview:mapView];
		[mapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
			make.height.equalTo(@150);
		}];
	}
	return self;
}

-(void)configureWithEvent:(AXEvent*)event {
    annotation.coordinate = event.coords;
    annotation.title      = event.name;
	
	[mapView setRegion:MKCoordinateRegionMake(event.coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)localAnnotation {
	if([localAnnotation isKindOfClass:MKUserLocation.class]) {
		return nil;
	}
	
	MKAnnotationView* annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"annoview"];
	if(annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:localAnnotation reuseIdentifier:@"annoview"];
		annotationView.canShowCallout = false;
	} else {
		annotationView.annotation = localAnnotation;
	}
	
	return annotationView;
}

@end
