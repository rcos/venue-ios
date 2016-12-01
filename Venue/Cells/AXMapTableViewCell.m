//
//  AXMapTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXMapTableViewCell.h"
#import <MapKit/MapKit.h>
#import <Masonry.h>
@interface AXMapTableViewCell () {
	MKMapView* mapView;
	MKPointAnnotation* anno;
}
@end

@implementation AXMapTableViewCell

- (instancetype)init
{
	self = [super init];
	if (self) {
		mapView = [[MKMapView alloc] init];
		[mapView setDelegate:self];
		[self.view addSubview:mapView];
		
		anno = [[MKPointAnnotation alloc] init];
		
		mapView.showsUserLocation = YES;
		[mapView addAnnotation:anno];
		
		[mapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
			make.height.equalTo(@150);
		}];
	}
	return self;
}

-(void)configureWithEvent:(AXEvent*)event {
	anno.coordinate = event.coords;
	anno.title = event.name;
	
	[mapView setRegion:MKCoordinateRegionMake(event.coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if([annotation isKindOfClass:MKUserLocation.class]) {
		return nil;
	}
	
	MKAnnotationView* annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"annoview"];
	if(annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annoview"];
		annotationView.canShowCallout = false;
	} else {
		annotationView.annotation = annotation;
	}
	
	return annotationView;
}

@end
