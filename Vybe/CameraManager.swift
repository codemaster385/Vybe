//
//  CameraManager.swift
//  camera
//
//  Created by Param Terlecka on 10/10/14.
//  Copyright (c) 2016  All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

public enum CameraState {
    case Ready, AccessDenied, NoDeviceFound, NotDetermined
}

public enum CameraDevice {
    case Front, Back
}

public enum CameraFlashMode: Int {
    case Off, On, Auto
}

public enum CameraOutputMode {
    case StillImage, VideoWithMic, VideoOnly
}

public enum CameraOutputQuality: Int {
    case Low, Medium, High
}

/// Class for handling iDevices custom camera usage
public class CameraManager: NSObject, AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate {

    // MARK: - Public properties
    
    /// Capture session to customize camera settings.
    public var captureSession = AVCaptureSession()
    
    /// Property to determine if the manager should show the error for the user. If you want to show the errors yourself set this to false. If you want to add custom error UI set showErrorBlock property. Default value is false.
    public var showErrorsToUsers = false
    
    /// Property to determine if the manager should show the camera permission popup immediatly when it's needed or you want to show it manually. Default value is true. Be carful cause using the camera requires permission, if you set this value to false and don't ask manually you won't be able to use the camera.
    public var showAccessPermissionPopupAutomatically = true
    
    /// A block creating UI to present error message to the user. This can be customised to be presented on the Window root view controller, or to pass in the viewController which will present the UIAlertController, for example.
    public var showErrorBlock:(erTitle: String, erMessage: String) -> Void = { (erTitle: String, erMessage: String) -> Void in
        
//        var alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .Alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in  }))
//        
//        if let topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
//            topController.presentViewController(alertController, animated: true, completion:nil)
//        }
    }

    /// Property to determine if manager should write the resources to the phone library. Default value is true.
    public var writeFilesToPhoneLibrary = false
    
    /// Property to determine if manager should follow device orientation. Default value is true.
    public var shouldRespondToOrientationChanges = true {
        didSet {
            if shouldRespondToOrientationChanges {
                _startFollowingDeviceOrientation()
            } else {
                _stopFollowingDeviceOrientation()
            }
        }
    }
    
    /// The Bool property to determine if the camera is ready to use.
    public var cameraIsReady: Bool {
        get {
            return cameraIsSetup
        }
    }
    
    /// The Bool property to determine if current device has front camera.
    public var hasFrontCamera: Bool = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == .Front) {
                return true
            }
        }
        return false
    }()
    
    /// The Bool property to determine if current device has flash.
    public var hasFlash: Bool = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == .Back) {
                return captureDevice.hasFlash
            }
        }
        return false
        }()
    
    /// Property to change camera device between front and back.
    public var cameraDevice = CameraDevice.Back {
        didSet {
            if cameraIsSetup {
                if cameraDevice != oldValue {
                    _updateCameraDevice(cameraDevice)
                    _setupMaxZoomScale()
                    _zoom(0)
                }
            }
        }
    }

    /// Property to change camera flash mode.
    public var flashMode = CameraFlashMode.Off {
        didSet {
            if cameraIsSetup {
                if flashMode != oldValue {
                    _updateFlasMode(flashMode)
                }
            }
        }
    }

    /// Property to change camera output quality.
    public var cameraOutputQuality = CameraOutputQuality.High {
        didSet {
            if cameraIsSetup {
                if cameraOutputQuality != oldValue {
                    _updateCameraQualityMode(cameraOutputQuality)
                }
            }
        }
    }

    /// Property to change camera output.
    public var cameraOutputMode = CameraOutputMode.StillImage {
        didSet {
            if cameraIsSetup {
                if cameraOutputMode != oldValue {
                    _setupOutputMode(cameraOutputMode, oldCameraOutputMode: oldValue)
                    _setupMaxZoomScale()
                    _zoom(0)
                }
            }
        }
    }
    
    /// Property to check video recording duration when in progress
    public var recordedDuration : CMTime { return movieOutput?.recordedDuration ?? kCMTimeZero }
    
    /// Property to check video recording file size when in progress
    public var recordedFileSize : Int64 { return movieOutput?.recordedFileSize ?? 0 }

    
    // MARK: - Private properties

    private weak var embeddingView: UIView?
    private var videoCompletition: ((videoURL: NSURL?, error: NSError?) -> Void)?

    private var sessionQueue: dispatch_queue_t = dispatch_queue_create("CameraSessionQueue", DISPATCH_QUEUE_SERIAL)

    private lazy var frontCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        return devices.filter{$0.position == .Front}.first
    }()
    
    private lazy var backCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        return devices.filter{$0.position == .Back}.first
    }()
    
    private lazy var mic: AVCaptureDevice? = {
        return AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
    }()
    
    private var stillImageOutput: AVCaptureStillImageOutput?
    private var movieOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var library: ALAssetsLibrary?

    private var cameraIsSetup = false
    private var cameraIsObservingDeviceOrientation = false

    private var zoomScale       = CGFloat(1.0)
    private var beginZoomScale  = CGFloat(1.0)
    private var maxZoomScale    = CGFloat(1.0)

    private var tempFilePath: NSURL = {
        let tempPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("tempMovie").URLByAppendingPathExtension("mp4").absoluteString
        if NSFileManager.defaultManager().fileExistsAtPath(tempPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(tempPath)
            } catch { }
        }
        return NSURL(string: tempPath)!
    }()
    
    
    // MARK: - CameraManager

    /**
    Inits a capture session and adds a preview layer to the given view. Preview layer bounds will automaticaly be set to match given view. Default session is initialized with still image output.

    :param: view The view you want to add the preview layer to
    :param: cameraOutputMode The mode you want capturesession to run image / video / video and microphone
    :param: completition Optional completition block
    
    :returns: Current state of the camera: Ready / AccessDenied / NoDeviceFound / NotDetermined.
    */
    public func addPreviewLayerToView(view: UIView) -> CameraState {
        return addPreviewLayerToView(view, newCameraOutputMode: cameraOutputMode)
    }
    public func addPreviewLayerToView(view: UIView, newCameraOutputMode: CameraOutputMode) -> CameraState {
        return addPreviewLayerToView(view, newCameraOutputMode: newCameraOutputMode, completition: nil)
    }
    public func addPreviewLayerToView(view: UIView, newCameraOutputMode: CameraOutputMode, completition: (Void -> Void)?) -> CameraState {
        if _canLoadCamera() {
            if let _ = embeddingView {
                if let validPreviewLayer = previewLayer {
                    validPreviewLayer.removeFromSuperlayer()
                }
            }
            if cameraIsSetup {
                _addPreviewLayerToView(view)
                cameraOutputMode = newCameraOutputMode
                if let validCompletition = completition {
                    validCompletition()
                }
            } else {
                _setupCamera({ Void -> Void in
                    self._addPreviewLayerToView(view)
                    self.cameraOutputMode = newCameraOutputMode
                    if let validCompletition = completition {
                        validCompletition()
                    }
                })
            }
        }
        dispatch_async(sessionQueue) {
            if self.movieOutput == nil
            {
            self.movieOutput = AVCaptureMovieFileOutput()
            
                /*
                 AVCaptureDevice *device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                 NSError *error = nil;
                 NSLog(@"start      3");
                 AVCaptureDeviceInput *input =
                 [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                 if (!input) {
                 NSLog(@"Error");
                 }
                 [session addInput:input];
                 */
                let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                let input = try! AVCaptureDeviceInput(device:device)
            self.captureSession.addInput(input)
                let connection = self.movieOutput!.connectionWithMediaType(AVMediaTypeVideo)
                if connection.supportsVideoStabilization
                {
                    connection.preferredVideoStabilizationMode = .Auto
                }
            if self.captureSession.canAddOutput(self.movieOutput!) {
                self.captureSession.beginConfiguration()
                self.captureSession.addOutput(self.movieOutput!)
                self.captureSession.commitConfiguration()
            }
               self.stillImageOutput = AVCaptureStillImageOutput()
                if self.captureSession.canAddOutput(self.stillImageOutput!) {
                    self.captureSession.beginConfiguration()
                    self.captureSession.addOutput(self.stillImageOutput!)
                    self.captureSession.commitConfiguration()
                }
                /*
                 if ([session canAddOutput:stillImageOutput])
                 {
                 [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
                 [session addOutput:stillImageOutput];
                 [self setStillImageOutput:stillImageOutput];
                 }
                 */
            }

        }
        return _checkIfCameraIsAvailable()
    }

    /**
    Asks the user for camera permissions. Only works if the permissions are not yet determined. Note that it'll also automaticaly ask about the microphone permissions if you selected VideoWithMic output.
    
    :param: completition Completition block with the result of permission request
    */
    public func askUserForCameraPermissions(completition: Bool -> Void) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (alowedAccess) -> Void in
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio, completionHandler: { (granted) -> Void in
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.currentMicPermission = granted
                    })
                })
            
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.currentMicPermission = alowedAccess
                })

            
        })

    }

    /**
    Stops running capture session but all setup devices, inputs and outputs stay for further reuse.
    */
    public func stopCaptureSession() {
        captureSession.stopRunning()
        _stopFollowingDeviceOrientation()
    }

    /**
    Resumes capture session.
    */
    public func resumeCaptureSession() {
            if !captureSession.running && cameraIsSetup {
                captureSession.startRunning()
                _startFollowingDeviceOrientation()
            }
        
            if _canLoadCamera() {
                if cameraIsSetup {
                    stopAndRemoveCaptureSession()
                }
                _setupCamera({Void -> Void in
                    if let validEmbeddingView = self.embeddingView {
                        self._addPreviewLayerToView(validEmbeddingView)
                    }
                    self._startFollowingDeviceOrientation()
                })
            }
        
    }

    /**
    Stops running capture session and removes all setup devices, inputs and outputs.
    */
    public func stopAndRemoveCaptureSession() {
        stopCaptureSession()
        cameraDevice = .Back
        cameraIsSetup = false
        previewLayer = nil
        frontCameraDevice = nil
        backCameraDevice = nil
        mic = nil
        stillImageOutput = nil
        movieOutput = nil
    }

    /**
    Captures still image from currently running capture session.

    :param: imageCompletition Completition block containing the captured UIImage
    */
    public func capturePictureWithCompletition(imageCompletition: (UIImage?, NSError?) -> Void) {
        if cameraIsSetup {
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
//            if cameraOutputMode == .StillImage {
                dispatch_async(sessionQueue, {
                    self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler: { [weak self] (sample: CMSampleBuffer!, error: NSError!) -> Void in
                        if (error != nil) {
                            dispatch_async(dispatch_get_main_queue(), {
                                if let weakSelf = self {
                                    weakSelf._show(NSLocalizedString("Error", comment:""), message: error.localizedDescription)
                                }
                            })
                            imageCompletition(nil, error)
                        } else {
                            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sample)
                            if let weakSelf = self {
                                if weakSelf.writeFilesToPhoneLibrary {
                                    if let validLibrary = weakSelf.library {
                                        validLibrary.writeImageDataToSavedPhotosAlbum(imageData, metadata:nil, completionBlock: {
                                            (picUrl, error) -> Void in
                                            if (error != nil) {
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    weakSelf._show(NSLocalizedString("Error", comment:""), message: error.localizedDescription)
                                                })
                                            }
                                        })
                                    }
                                }
                            }
                            imageCompletition(UIImage(data: imageData), nil)
                        }
                    })
                })
//            } else {
//                _show(NSLocalizedString("Capture session output mode video", comment:""), message: NSLocalizedString("I can't take any picture", comment:""))
//            }
        } else {
            _show(NSLocalizedString("No capture session setup", comment:""), message: NSLocalizedString("I can't take any picture", comment:""))
        }
    }

    /**
    Starts recording a video with or without voice as in the session preset.
    */
    public func startRecordingVideo() {
       // if cameraOutputMode != .StillImage {
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            dispatch_async(sessionQueue, {
                
            self.movieOutput?.startRecordingToOutputFileURL(self.tempFilePath, recordingDelegate: self)
            })
            
//        } else {
//            _show(NSLocalizedString("Capture session output still image", comment:""), message: NSLocalizedString("I can only take pictures", comment:""))
//        }
    }

    /**
    Stop recording a video. Save it to the cameraRoll and give back the url.
    */
    public func stopRecordingVideo(completition:(videoURL: NSURL?, error: NSError?) -> Void) {
        if let runningMovieOutput = movieOutput {
            if runningMovieOutput.recording {
                videoCompletition = completition
                runningMovieOutput.stopRecording()
            }
        }
    }

    var currentCameraPermission = false
    var currentMicPermission = false
    /**
    Current camera status.
    
    :returns: Current state of the camera: Ready / AccessDenied / NoDeviceFound / NotDetermined
    */
    public func currentCameraStatus() -> CameraState {
        return _checkIfCameraIsAvailable()
    }
    
    /**
    Change current flash mode to next value from available ones.
    
    :returns: Current flash mode: Off / On / Auto
    */
    public func changeFlashMode() -> CameraFlashMode {
        flashMode = CameraFlashMode(rawValue: (flashMode.rawValue+1)%3)!
        return flashMode
    }
    
    /**
    Change current output quality mode to next value from available ones.
    
    :returns: Current quality mode: Low / Medium / High
    */
    public func changeQualityMode() -> CameraOutputQuality {
        cameraOutputQuality = CameraOutputQuality(rawValue: (cameraOutputQuality.rawValue+1)%3)!
        return cameraOutputQuality
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate

    public func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        captureSession.beginConfiguration()
        if flashMode != .Off {
            _updateTorch(flashMode)
        }
        captureSession.commitConfiguration()
    }

    public func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        _updateTorch(.Off)
        if (error != nil) {
            _show(NSLocalizedString("Unable to save video to the iPhone", comment:""), message: error.localizedDescription)
        } else {
            if let validLibrary = library {
                if writeFilesToPhoneLibrary {
                    validLibrary.writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: { (assetURL: NSURL?, error: NSError?) -> Void in
                        if (error != nil) {
                            self._show(NSLocalizedString("Unable to save video to the iPhone.", comment:""), message: error!.localizedDescription)
                            self._executeVideoCompletitionWithURL(nil, error: error)
                        } else {
                            if let validAssetURL = assetURL {
                                self._executeVideoCompletitionWithURL(validAssetURL, error: error)
                            }
                        }
                    })
                } else {
                    _executeVideoCompletitionWithURL(outputFileURL, error: error)
                }
            }
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    
    private func attachZoom(view: UIView) {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(CameraManager._zoomStart(_:)))
        view.addGestureRecognizer(pinch)
        pinch.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKindOfClass(UIPinchGestureRecognizer) {
            beginZoomScale = zoomScale;
        }
        
        return true
    }

    @objc
    private func _zoomStart(recognizer: UIPinchGestureRecognizer) {
        guard let view = embeddingView,
            previewLayer = previewLayer
            else { return }

        var allTouchesOnPreviewLayer = true
        let numTouch = recognizer.numberOfTouches()

        for i in 0 ..< numTouch {
            let location = recognizer.locationOfTouch(i, inView: view)
            let convertedTouch = previewLayer.convertPoint(location, fromLayer: previewLayer.superlayer)
            if !previewLayer.containsPoint(convertedTouch) {
                allTouchesOnPreviewLayer = false
                break
            }
        }
        if allTouchesOnPreviewLayer {
            _zoom(recognizer.scale)
        }
    }
    
    private func _zoom(scale: CGFloat) {
        do {
            let captureDevice = AVCaptureDevice.devices().first as? AVCaptureDevice
            try captureDevice?.lockForConfiguration()

            zoomScale = max(1.0, min(beginZoomScale * scale, maxZoomScale))
            
            captureDevice?.videoZoomFactor = zoomScale

            captureDevice?.unlockForConfiguration()
            
        } catch {
            print("Error locking configuration")
        }
    }
    
    // MARK: - CameraManager()

    private func _updateTorch(flashMode: CameraFlashMode) {
        captureSession.beginConfiguration()
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == AVCaptureDevicePosition.Back) {
                let avTorchMode = AVCaptureTorchMode(rawValue: flashMode.rawValue)
                if (captureDevice.isTorchModeSupported(avTorchMode!)) {
                    do {
                        try captureDevice.lockForConfiguration()
                    } catch {
                        return;
                    }
                    captureDevice.torchMode = avTorchMode!
                    captureDevice.unlockForConfiguration()
                }
            }
        }
        captureSession.commitConfiguration()
    }
    
    private func _executeVideoCompletitionWithURL(url: NSURL?, error: NSError?) {
        if let validCompletition = videoCompletition {
            validCompletition(videoURL: url, error: error)
            videoCompletition = nil
        }
    }

    private func _getMovieOutput() -> AVCaptureMovieFileOutput {
        
        
        var shouldReinitializeMovieOutput = movieOutput == nil
        if !shouldReinitializeMovieOutput {
            if let connection = movieOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                shouldReinitializeMovieOutput = shouldReinitializeMovieOutput || !connection.active
            }
        }
        
        if shouldReinitializeMovieOutput {
          
           
            movieOutput = AVCaptureMovieFileOutput()

            if captureSession.canAddOutput(movieOutput!) {
                captureSession.beginConfiguration()
                captureSession.addOutput(movieOutput!)
                captureSession.commitConfiguration()
            }
            
            
        }
        return movieOutput!
    }
    
    private func _getStillImageOutput() -> AVCaptureStillImageOutput {
        var shouldReinitializeStillImageOutput = stillImageOutput == nil
        if !shouldReinitializeStillImageOutput {
            if let connection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                shouldReinitializeStillImageOutput = shouldReinitializeStillImageOutput || !connection.active
            }
        }
        if shouldReinitializeStillImageOutput {
            stillImageOutput = AVCaptureStillImageOutput()
            
            captureSession.beginConfiguration()
            captureSession.addOutput(stillImageOutput)
            captureSession.commitConfiguration()
        }
        return stillImageOutput!
    }
    
    @objc private func _orientationChanged() {
        var currentConnection: AVCaptureConnection?;
        switch cameraOutputMode {
        case .StillImage:
            currentConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        case .VideoOnly, .VideoWithMic:
            currentConnection = _getMovieOutput().connectionWithMediaType(AVMediaTypeVideo)
        }
        if let validPreviewLayer = previewLayer {
            if let validPreviewLayerConnection = validPreviewLayer.connection {
                if validPreviewLayerConnection.supportsVideoOrientation {
                    validPreviewLayerConnection.videoOrientation = _currentVideoOrientation()
                }
            }
            if let validOutputLayerConnection = currentConnection {
                if validOutputLayerConnection.supportsVideoOrientation {
                    validOutputLayerConnection.videoOrientation = _currentVideoOrientation()
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let validEmbeddingView = self.embeddingView {
                    validPreviewLayer.frame = validEmbeddingView.bounds
                }
            })
        }
    }

    private func _currentVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft:
            return .LandscapeRight
        case .LandscapeRight:
            return .LandscapeLeft
        default:
            return .Portrait
        }
    }

    private func _canLoadCamera() -> Bool {
        let currentCameraState = _checkIfCameraIsAvailable()
        return currentCameraState == .Ready || (currentCameraState == .NotDetermined && showAccessPermissionPopupAutomatically)
    }

    private func _setupCamera(completition: Void -> Void) {
        
        dispatch_async(sessionQueue, {
                self.captureSession.beginConfiguration()
                self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
                self._updateCameraDevice(self.cameraDevice)
                self._setupOutputs()
                self._setupOutputMode(self.cameraOutputMode, oldCameraOutputMode: nil)
                self._setupPreviewLayer()
                self.captureSession.commitConfiguration()
                self._updateFlasMode(self.flashMode)
                self._updateCameraQualityMode(self.cameraOutputQuality)
                self.captureSession.startRunning()
                self._startFollowingDeviceOrientation()
                self.cameraIsSetup = true
                self._orientationChanged()
                
                self.askUserForCameraPermissions({ (granted) in
                    
                })
                
                completition()
            
        })
    }

    private func _startFollowingDeviceOrientation() {
        if shouldRespondToOrientationChanges && !cameraIsObservingDeviceOrientation {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraManager._orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
            cameraIsObservingDeviceOrientation = true
        }
    }

    private func _stopFollowingDeviceOrientation() {
        if cameraIsObservingDeviceOrientation {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
            cameraIsObservingDeviceOrientation = false
        }
    }

    private func _addPreviewLayerToView(view: UIView) {
        embeddingView = view
        attachZoom(view)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            guard let _ = self.previewLayer else {
                return
            }
            self.previewLayer!.frame = view.layer.bounds
            view.clipsToBounds = true
            view.layer.addSublayer(self.previewLayer!)
        })
    }
    
    private func _setupMaxZoomScale() {
        var maxZoom = CGFloat(1.0)
        beginZoomScale = CGFloat(1.0)
        
        if cameraDevice == .Back {
            maxZoom = (backCameraDevice?.activeFormat.videoMaxZoomFactor)!
        }
        else if cameraDevice == .Front {
            maxZoom = (frontCameraDevice?.activeFormat.videoMaxZoomFactor)!
        }

        maxZoomScale = maxZoom
    }

    private func _checkIfCameraIsAvailable() -> CameraState {
        let deviceHasCamera = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
        if deviceHasCamera {
            let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
            let userAgreedToUseIt = authorizationStatus == .Authorized
            if userAgreedToUseIt {
                self.currentCameraPermission = true
                self.currentMicPermission = true
                return .Ready
            } else if authorizationStatus == AVAuthorizationStatus.NotDetermined {
                return .NotDetermined
            } else {
                _show(NSLocalizedString("Camera access denied", comment:""), message:NSLocalizedString("You need to go to settings app and grant acces to the camera device to use it.", comment:""))
                return .AccessDenied
            }
        } else {
            _show(NSLocalizedString("Camera unavailable", comment:""), message:NSLocalizedString("The device does not have a camera.", comment:""))
            return .NoDeviceFound
        }
    }
    
    private func _setupOutputMode(newCameraOutputMode: CameraOutputMode, oldCameraOutputMode: CameraOutputMode?) {
        captureSession.beginConfiguration()
        
        if let cameraOutputToRemove = oldCameraOutputMode {
            // remove current setting
            switch cameraOutputToRemove {
            case .StillImage:
                if let validStillImageOutput = stillImageOutput {
                    captureSession.removeOutput(validStillImageOutput)
                }
            case .VideoOnly, .VideoWithMic:
                if let validMovieOutput = movieOutput {
                    captureSession.removeOutput(validMovieOutput)
                }
                if cameraOutputToRemove == .VideoWithMic {
                    _removeMicInput()
                }
            }
        }
        
        // configure new devices
        switch newCameraOutputMode {
        case .StillImage:
            if (stillImageOutput == nil) {
                _setupOutputs()
            }
            if let validStillImageOutput = stillImageOutput {
                captureSession.addOutput(validStillImageOutput)
            }
        case .VideoOnly, .VideoWithMic:
            captureSession.addOutput(_getMovieOutput())
            
            if newCameraOutputMode == .VideoWithMic {
                if let validMic = _deviceInputFromDevice(mic) {
                    captureSession.addInput(validMic)
                }
            }
        }
        captureSession.commitConfiguration()
        _updateCameraQualityMode(cameraOutputQuality)
        _orientationChanged()
    }
    
    private func _setupOutputs() {
        if (stillImageOutput == nil) {
            stillImageOutput = AVCaptureStillImageOutput()
        }
        if (movieOutput == nil) {
            movieOutput = AVCaptureMovieFileOutput()
            movieOutput!.movieFragmentInterval = kCMTimeInvalid
        }
        if library == nil {
            library = ALAssetsLibrary()
        }
    }

    private func _setupPreviewLayer() {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
    }
    
    private func _updateCameraDevice(deviceType: CameraDevice) {
            captureSession.beginConfiguration()
            let inputs = captureSession.inputs as! [AVCaptureInput]
            
            for input in inputs {
                if let deviceInput = input as? AVCaptureDeviceInput {
                    if deviceInput.device == backCameraDevice && cameraDevice == .Front {
                        captureSession.removeInput(deviceInput)
                        break;
                    } else if deviceInput.device == frontCameraDevice && cameraDevice == .Back {
                        captureSession.removeInput(deviceInput)
                        break;
                    }
                }
            }
            switch cameraDevice {
            case .Front:
                if hasFrontCamera {
                    if let validFrontDevice = _deviceInputFromDevice(frontCameraDevice) {
                        if !inputs.contains(validFrontDevice) {
                            captureSession.addInput(validFrontDevice)
                        }
                    }
                }
            case .Back:
                if let validBackDevice = _deviceInputFromDevice(backCameraDevice) {
                    if !inputs.contains(validBackDevice) {
                        captureSession.addInput(validBackDevice)
                    }
                }
            }
            captureSession.commitConfiguration()
        
    }
    
    private func _updateFlasMode(flashMode: CameraFlashMode) {
        captureSession.beginConfiguration()
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == AVCaptureDevicePosition.Back) {
                let avFlashMode = AVCaptureFlashMode(rawValue: flashMode.rawValue)
                if (captureDevice.isFlashModeSupported(avFlashMode!)) {
                    do {
                        try captureDevice.lockForConfiguration()
                    } catch {
                        return
                    }
                    captureDevice.flashMode = avFlashMode!
                    captureDevice.unlockForConfiguration()
                }
            }
        }
        captureSession.commitConfiguration()
    }
    
    private func _updateCameraQualityMode(newCameraOutputQuality: CameraOutputQuality) {
            var sessionPreset = AVCaptureSessionPresetLow
            switch (newCameraOutputQuality) {
            case CameraOutputQuality.Low:
                sessionPreset = AVCaptureSessionPresetLow
            case CameraOutputQuality.Medium:
                sessionPreset = AVCaptureSessionPresetMedium
            case CameraOutputQuality.High:
                if cameraOutputMode == .StillImage {
                    sessionPreset = AVCaptureSessionPresetPhoto
                } else {
                    sessionPreset = AVCaptureSessionPresetHigh
                }
            }
            if captureSession.canSetSessionPreset(sessionPreset) {
                captureSession.beginConfiguration()
                captureSession.sessionPreset = sessionPreset
                captureSession.commitConfiguration()
            } else {
                _show(NSLocalizedString("Preset not supported", comment:""), message: NSLocalizedString("Camera preset not supported. Please try another one.", comment:""))
            }
        
    }

    private func _removeMicInput() {
        guard let inputs = captureSession.inputs as? [AVCaptureInput] else { return }
        
        for input in inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                if deviceInput.device == mic {
                    captureSession.removeInput(deviceInput)
                    break;
                }
            }
        }
    }
    
    private func _show(title: String, message: String) {
        if showErrorsToUsers {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showErrorBlock(erTitle: title, erMessage: message)
            })
        }
    }
    
    private func _deviceInputFromDevice(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let outError {
            _show(NSLocalizedString("Device setup error occured", comment:""), message: "\(outError)")
            return nil
        }
    }

    deinit {
        stopAndRemoveCaptureSession()
        _stopFollowingDeviceOrientation()
    }
}
