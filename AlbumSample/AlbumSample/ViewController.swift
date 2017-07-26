//
//  ViewController.swift
//  AlbumSample
//
//  Created by Yusk1450 on 2017/07/26.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		PHPhotoLibrary.requestAuthorization { (status) in
			switch(status)
			{
				case .authorized:
					print("Authorized")
				case .denied:
					print("Denid")
				case .notDetermined:
					print("NotDetermined")
				case .restricted:
					print("Restricted")
			}
		}
	}
	
	@IBAction func btnAction(_ sender: Any)
	{
		PHPhotoLibrary.shared().performChanges({

			let albumName = "TestAlbum"

			self.existsAlbum(name: albumName, completionHandler: { (exists) in
				
				if (exists)
				{
					print("すでに存在しています")
					return
				}
				
				PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
			})
		}) { (isSuccess, error) in
			if (isSuccess)
			{
				print("Success!")
			}
			else
			{
				print("Failed")
			}
		}
	}
	
	func existsAlbum(name:String, completionHandler: @escaping (_ exists:Bool) -> Void)
	{
		PHPhotoLibrary.shared().performChanges({
			
			var exists = false
			
			// アルバムリストを取得する
			let list = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album,
			                                                   subtype: PHAssetCollectionSubtype.any,
			                                                   options: nil)
			// アルバムを検索する
			list.enumerateObjects({ (album, index, isStop) in
				
				if (album.localizedTitle == name)
				{
					exists = true
					
					let stop:ObjCBool = false
					isStop.initialize(to: stop)
				}
			})
			
			completionHandler(exists)
			
		}, completionHandler: nil)
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
}

