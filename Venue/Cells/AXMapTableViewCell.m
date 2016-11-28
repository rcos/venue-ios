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
		anno = [[MKPointAnnotation alloc] init];
		
		mapView.showsUserLocation = YES;
		[mapView addAnnotation:anno];
		
		[mapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];
	}
	return self;
}

-(void)configureWithEvent:(AXEvent*)event {
	anno.coordinate = event.coords;
	anno.title = event.name;
	
	[mapView setRegion:MKCoordinateRegionMake(event.coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
}

@end
