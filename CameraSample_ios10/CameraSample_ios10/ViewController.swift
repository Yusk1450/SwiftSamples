//
//  ViewController.swift
//  CameraSample
//
//  Created by Yusk1450 on 2017/07/14.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	var camera:CamCapture = CamCapture()
	var previewLayer:CALayer?
	
	var resultImg:UIImageView?
	
	var isProcessing = false
	var isResult = false
	
	/* -------------------------------------------------
	* ビューが読み込まれたときに呼び出される
	------------------------------------------------- */
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.resultImg = UIImageView()
		self.resultImg?.frame = self.view.frame
		self.resultImg?.alpha = 0.0
		self.view.addSubview(self.resultImg!)
		
		// カメラをセットアップする
		self.setupCamera(cameraSize: self.view.frame.size)
	}
	
	/* -------------------------------------------------
	* カメラをセットアップする
	------------------------------------------------- */
	private func setupCamera(cameraSize:CGSize)
	{
		self.previewLayer = self.camera.previewLayerWithFrame(CGRect(
			x: self.view.frame.size.width/2.0 - cameraSize.width/2.0,
			y: self.view.frame.size.height/2.0 - cameraSize.height/2.0,
			width: cameraSize.width,
			height: cameraSize.height))
		
		if let previewLayer = self.previewLayer
		{
			self.view.layer.addSublayer(previewLayer)
		}
	}
	
	/* -------------------------------------------------
	* 撮影する
	------------------------------------------------- */
	private func shoot()
	{
		if (self.isProcessing)
		{
			return
		}
		
		// キャプチャ
		self.camera.capture { (img) in
			self.isProcessing = true
			
			if let resultImg = self.resultImg
			{
				resultImg.image = img
				resultImg.alpha = 1.0
				self.view.bringSubview(toFront: resultImg)
				
				self.isResult = true
			}
			
			self.isProcessing = false
		}
	}
	
	/* -------------------------------------------------
	* タップして指を離したときに呼び出される
	------------------------------------------------- */
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		if (self.isResult)
		{
			if let resultImg = self.resultImg
			{
				resultImg.alpha = 0.0
				self.view.sendSubview(toBack: resultImg)
				self.isResult = false
			}
		}
		else
		{
			// 撮影する
			self.shoot()
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
}

