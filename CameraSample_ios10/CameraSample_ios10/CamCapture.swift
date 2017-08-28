//
//  CamCapture.swift
//  CameraTest
//
//  Created by 石郷 祐介 on 2015/02/25.
//  Copyright (c) 2015年 Yusk. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo

class CamCapture: NSObject, AVCapturePhotoCaptureDelegate
{
	private var captureSession:AVCaptureSession?
	private var dataOutput:AVCapturePhotoOutput?
	private var videoConnection:AVCaptureConnection?
	private var isCapturing:Bool = false
	
	private var captureCompProc:((_ img:UIImage) -> Void)?
	
	override init()
	{
		super.init()
		
		self.setupAVCapture()
	}
	
	deinit
	{
		self.disposeAVCapture()
	}
	
	/* -----------------------------------------------------
	* 初期化処理
	------------------------------------------------------ */
	func setupAVCapture()
	{
		self.captureSession = AVCaptureSession()
		
		if let captureSession = self.captureSession
		{
			captureSession.sessionPreset = AVCaptureSessionPresetPhoto
			
			let input:AVCaptureDeviceInput? = self.captureDeviceInput()
			if (captureSession.canAddInput(input))
			{
				captureSession.addInput(input)
			}
			
			self.dataOutput = captureDataOutput()
			if (captureSession.canAddOutput(self.dataOutput))
			{
				captureSession.addOutput(self.dataOutput)
			}
			
			// 露出固定
			//		var err:NSErrorPointer = nil
			//		let captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
			//		captureDevice.lockForConfiguration(err)
			//		captureDevice.exposureMode = AVCaptureExposureMode.Locked
			//		captureDevice.unlockForConfiguration()
			
			self.videoConnection = self.dataOutput?.connection(withMediaType: AVMediaTypeVideo)
			self.videoConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
			
			captureSession.startRunning()
		}
	}
	
	/* -----------------------------------------------------
	* 終了処理
	------------------------------------------------------ */
	func disposeAVCapture()
	{
		if let captureSession = self.captureSession
		{
			captureSession.stopRunning()
			
			for output in captureSession.outputs
			{
				captureSession.removeOutput(output as! AVCaptureOutput)
			}
			
			for input in captureSession.inputs
			{
				captureSession.removeInput(input as! AVCaptureInput)
			}
		}
		self.dataOutput = nil
	}
	
	/* -----------------------------------------------------
	* プレビューレイヤーを返す
	------------------------------------------------------ */
	func previewLayerWithFrame(_ frame:CGRect) -> AVCaptureVideoPreviewLayer
	{
		let videoPreviewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
		
		// 指定したframeと実際のカメラ画像のサイズ（captureSession.sessionPresetに指定）を比較して、
		// 差が少ない辺に合わせ、アスペクト比を変更しないで、はみ出した部分は隠す
		videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		videoPreviewLayer.frame = frame
		
		// フロントカメラの場合は反転する
		//		videoPreviewLayer.setAffineTransform(CGAffineTransformMakeScale(-1.0, 1.0))
		
		return videoPreviewLayer
	}
	
	/* -----------------------------------------------------
	* キャプチャする
	------------------------------------------------------ */
	func capture(captureCompProc:@escaping (_ img:UIImage) -> Void)
	{
		if (self.isCapturing)
		{
			return
		}
		
		self.isCapturing = true
		
		self.captureCompProc = captureCompProc
		
		let settings = AVCapturePhotoSettings()
		settings.flashMode = .off
		settings.isAutoStillImageStabilizationEnabled = true
		settings.isHighResolutionPhotoEnabled = false
		
		self.dataOutput?.capturePhoto(with: settings, delegate: self)
		
		/*
		self.dataOutput?.captureStillImageAsynchronously(
		from: self.videoConnection,
		completionHandler: { [weak self] (imageDataSampleBuffer, err) -> Void in
		guard let wself = self else
		{
		return
		}
		
		let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
		
		
		let img:UIImage? = UIImage(data: imageDataJpeg!)
		
		capture(img: img!)
		wself.isCapturing = false
		})
		*/
	}
	
	func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)
	{
		if let sampleBuffer = photoSampleBuffer
		{
			if let imageDataJpeg = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
			{
				if let img = UIImage(data: imageDataJpeg), let captureCompProc = self.captureCompProc
				{
					captureCompProc(img)
				}
			}
		}
		
		self.isCapturing = false
	}
	
	private func captureDeviceInput() -> AVCaptureDeviceInput?
	{
		let captureDevice = AVCaptureDevice.defaultDevice(
			withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
		
		if (captureDevice == nil)
		{
			print("ERROR: Missing camera.")
			return nil
		}
		
		let deviceInput:AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: captureDevice)
		return deviceInput
	}
	
	fileprivate func captureDataOutput() -> AVCapturePhotoOutput
	{
		let dataOutput = AVCapturePhotoOutput()
		//dataOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		
		for connection in dataOutput.connections
		{
			if ((connection as! AVCaptureConnection).isVideoOrientationSupported)
			{
				(connection as! AVCaptureConnection).videoOrientation = AVCaptureVideoOrientation.portrait
			}
		}
		
		return dataOutput
	}
}
