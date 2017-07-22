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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
	@IBOutlet weak var mapView: MKMapView!
	var locationManager:CLLocationManager = CLLocationManager()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		// 現在地を取得する準備
		if (CLLocationManager.locationServicesEnabled())
		{
			self.locationManager.delegate = self
			self.locationManager.distanceFilter = kCLDistanceFilterNone
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		}
		
		// マップの中心を現在地に設定する
		self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
		self.mapView.userTrackingMode = .followWithHeading

		// 長押しを取得する準備
		let longGesture = UILongPressGestureRecognizer()
		longGesture.addTarget(self, action: #selector(self.longPress(sender:)))
		self.mapView.addGestureRecognizer(longGesture)
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}

	// MARK: - CLLocationManager Delegate Methods
	
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
	
	// MARK: - UILongPressGestureRecognizer Methods
	
	func longPress(sender:UILongPressGestureRecognizer)
	{
		if (sender.state != .began)
		{
			return
		}
		
		let location = sender.location(in: self.mapView)
		let mapPoint = self.mapView.convert(location, toCoordinateFrom: self.mapView)
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = mapPoint
		annotation.title = "ピンのタイトル"
		annotation.subtitle = "ピンのサブタイトル"
		self.mapView.addAnnotation(annotation)
	}
	
	// MARK: - MKMapView Delegate Methods
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
	{
		let identifier = "PinAnnotationIdentifier"
		
		var pinView:MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

		if (pinView == nil)
		{
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			pinView?.animatesDrop = true
		}
		pinView?.annotation = annotation
		
		return pinView
	}
	

}

