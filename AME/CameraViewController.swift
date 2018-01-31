//
//  CameraViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 11/28/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//


import UIKit
import AVKit

@available(iOS 11.0, *)
class CameraViewController: UIViewController, AVCaptureDepthDataOutputDelegate, AVCapturePhotoCaptureDelegate {
    
    let capturePhotoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    let settings = AVCapturePhotoSettings()
    
    var parentVC: NewMeetingViewController?
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        
        self.capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        print(self.parentVC!)
        if let par = self.parentVC {
            let image = UIImage(cgImage: (photo.cgImageRepresentation()?.takeUnretainedValue())!, scale: 1.0, orientation: .up)
            
            //Create UIImage from depth data
            let depthCIImage = CIImage(cvPixelBuffer: (photo.depthData?.depthDataMap)!)
            let context = CIContext()
            let depthCGImage = context.createCGImage(depthCIImage, from: depthCIImage.extent)
            let depthImage = UIImage(cgImage: depthCGImage!, scale: 1.0, orientation: .up)
            
            //pass images to HomeViewController
            par.depthImageView.image = depthImage
            par.imageView.image = image
            
            //Save Image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(depthImage, nil, nil, nil)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.captureSession.sessionPreset = .photo
        
        let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera, for: AVMediaType.video, position: .back)
        
        self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                if (captureSession.canAddOutput(capturePhotoOutput)) {
                    captureSession.addOutput(capturePhotoOutput)
                    capturePhotoOutput.connection(with: .video)!.isEnabled = true
                    captureSession.startRunning()
                    
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.imageView.layer.addSublayer(self.previewLayer!)
                    
                    capturePhotoOutput.isDepthDataDeliveryEnabled = true
                    settings.isDepthDataDeliveryEnabled = true
                    settings.embedsDepthDataInPhoto = true
                    //settings.isDepthDataFiltered = true
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.previewLayer?.frame = self.imageView.bounds
    }
    
}
