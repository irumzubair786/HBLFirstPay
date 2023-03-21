//////
//////  QRSccanerVc.swift
//////  First Pay
//////
//////  Created by Syed Uzair Ahmed on 29/06/2021.
//////  Copyright © 2021 FMFB Pakistan. All rights reserved.
//////
////
//import UIKit
//import AVFoundation
////class QRSccanerVc: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
//
////    var captureSession: AVCaptureSession!
////    var previewLayer: AVCaptureVideoPreviewLayer!
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        view.backgroundColor = UIColor.black
////         captureSession = AVCaptureSession()
////        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
////                let videoInput: AVCaptureDeviceInput
////
////                do {
////                    videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
////                } catch {
////                    return
////                }
////        if (captureSession.canAddInput(videoInput)) {
////            captureSession.addInput(videoInput)
////        } else {
////            failed()
////            return
////        }
////
////        let metadataOutput = AVCaptureMetadataOutput()
////
////        if (captureSession.canAddOutput(metadataOutput)) {
////            captureSession.addOutput(metadataOutput)
////
////            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
////            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
////        } else {
////            failed()
////            return
////        }
////        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////                previewLayer.frame = view.layer.bounds
////                previewLayer.videoGravity = .resizeAspectFill
////                view.layer.addSublayer(previewLayer)
////
////                captureSession.startRunning()
////
////    }
////
////    func failed() {
////            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
////            ac.addAction(UIAlertAction(title: "OK", style: .default))
////            present(ac, animated: true)
////            captureSession = nil
////        }
////    override func viewWillAppear(_ animated: Bool) {
////            super.viewWillAppear(animated)
////
////            if (captureSession?.isRunning == false) {
////                captureSession.startRunning()
////            }
////        }
////
////        override func viewWillDisappear(_ animated: Bool) {
////            super.viewWillDisappear(animated)
////
////            if (captureSession?.isRunning == true) {
////                captureSession.stopRunning()
////            }
////        }
////    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
////            captureSession.stopRunning()
////
////            if let metadataObject = metadataObjects.first {
////                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
////                guard let stringValue = readableObject.stringValue else { return }
////                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
////                found(code: stringValue)
////            }
////
////            dismiss(animated: true)
////        }
////
////        func found(code: String) {
////            print(code)
////        }
////
////        override var prefersStatusBarHidden: Bool {
////            return true
////        }
////    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
////            return .portrait
////        }
////
////}
//class QRSccanerVc: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//    fileprivate var captureSession: AVCaptureSession!        // use for QRCode reading
//    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
//
//    // To get the image of the QRCode
//    private var photoOutputQR: AVCapturePhotoOutput!
//    private var isCapturing = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var accessGranted = false
//       //  switch AVCaptureDevice.authorizationStatus(for: .video) {
//// HERE TEST FOR ACCESS RIGHT. WORKS OK ;
//// But is .video enough ?
//        }
//
//        if !accessGranted {  return }
//        captureSession = AVCaptureSession()
//
//        photoOutputQR = AVCapturePhotoOutput()        // IS IT THE RIGHT PLACE AND THE RIGHT THING TO DO ?
//        captureSession.addOutput(photoOutputQR)   // Goal is to capture an image of QRCode once acquisition is done
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {  return }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)        // SO I have 2 output in captureSession. IS IT RIGHT ?
//
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]  // For QRCode video acquisition
//
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
//        previewLayer.frame.origin.y += 40
//        previewLayer.frame.size.height -= 40
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//        captureSession.startRunning()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//        if (captureSession?.isRunning == false) {
//            captureSession.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//
//        super.viewWillDisappear(animated)
//        if (captureSession?.isRunning == true) {
//            captureSession.stopRunning()
//        }
//    }
//
//    // MARK: - scan Results
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//        captureSession.stopRunning()
//
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//        }
//        // ### Get image - IS IT THE RIGHT PLACE TO DO IT ?
//        // https://stackoverflow.com/questions/37869963/how-to-use-avcapturephotooutput
//        print("Do I get here ?", isCapturing)
//        let photoSettings = AVCapturePhotoSettings()
//        let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first!
//        print("previewPixelType", previewPixelType)
//        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                             kCVPixelBufferWidthKey as String: 160,
//                             kCVPixelBufferHeightKey as String: 160]
//        photoSettings.previewPhotoFormat = previewFormat
//        if !isCapturing {
//            isCapturing = true
//            photoOutputQR.capturePhoto(with: photoSettings, delegate: self)
//        }
//        dismiss(animated: true)
//    }
//
//}
//extension ScannerViewController: AVCapturePhotoCaptureDelegate {
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//
//        isCapturing = false
//        print("photo", photo, photo.fileDataRepresentation())
//        guard let imageData = photo.fileDataRepresentation() else {
//            print("Error while generating image from photo capture data.");
//            return
//        }
//     }
//
//}
