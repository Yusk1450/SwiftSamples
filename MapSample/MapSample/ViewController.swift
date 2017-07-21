//
//  ViewController.swift
//  MapSample
//
//  Created by Yusk1450 on 2017/07/19.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
	@IBOutlet weak var mapView: MKMapView!
	var locationManager:CLLocationManager = CLLocationManager()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
		self.mapView.userTrackingMode = .followWithHeading
		
		if (CLLocationManager.locationServicesEnabled())
		{
			self.locationManager.delegate = self
			self.locationManager.distanceFilter = kCLDistanceFilterNone
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
	{
		switch status
		{
		case .notDetermined:
			self.locationManager.requestWhenInUseAuthorization()
			
		case .authorizedWhenInUse:
			self.locationManager.startUpdatingLocation()
			
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}

}

