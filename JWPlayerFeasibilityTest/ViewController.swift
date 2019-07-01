//
//  ViewController.swift
//  JWPlayerFeasibilityTest
//
//  Created by KingpiN on 14/06/19.
//  Copyright © 2019 KingpiN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CanRotate {

    @IBOutlet weak var containerView: UIView!

    var player: JWPlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpRightBarButton()
        let config = JWConfig()
        config.file = "https://cdn.jwplayer.com/manifests/KxDoH4cW.m3u8"
        config.advertising = .none
        config.displayDescription = false
        config.displayTitle = false
        config.repeat = false

        config.playbackRateControls = true
        config.related = .none
        config.controls = true
        config.autostart = true
        config.stretching = .uniform
        config.sources = [JWSource.init(file: "https://cdn.jwplayer.com/manifests/vPbEl0xR.m3u8", label: "240"),
                          JWSource.init(file: "https://cdn.jwplayer.com/manifests/vPbEl0xR.m3u8", label: "720"),
                          JWSource.init(file: "https://cdn.jwplayer.com/manifests/vPbEl0xR.m3u8", label: "1080")]
        
        let logo = JWLogo.init()
        logo.file = "https://betterbutterbucket.s3.amazonaws.com/editorial/f17b0a72-a404-4e96-b52f-ca9798b2e434.png"
        logo.hide = false
        logo.position = .topRight
        config.logo = logo
        
        self.player = JWPlayerController.init(config: config)
        self.player.view.frame = self.containerView.frame
        self.player.delegate = self
        self.containerView.addSubview(self.player.view)
        
        self.player.view.translatesAutoresizingMaskIntoConstraints = false
        if let playerView = self.player.view {
            let topConstraint = NSLayoutConstraint.init(item: playerView, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 0)
            let leftConstraint = NSLayoutConstraint.init(item: playerView, attribute: .left, relatedBy: .equal, toItem: self.containerView, attribute: .left, multiplier: 1.0, constant: 0)
            let rightConstraint = NSLayoutConstraint.init(item: playerView, attribute: .right, relatedBy: .equal, toItem: self.containerView, attribute: .right, multiplier: 1.0, constant: 0)
            let bottomConstraint = NSLayoutConstraint.init(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 0)
            let constraints = [topConstraint, leftConstraint, rightConstraint, bottomConstraint]
            self.containerView.addConstraints(constraints)
        }
        print(self.player as Any)
        self.view.backgroundColor = .black
        self.containerView.backgroundColor = .black
    }
    
    func setUpRightBarButton() {
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.style = UIBarButtonItem.Style.plain
        rightBarButtonItem.target =  self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let selector =  #selector(self.closeButton(barButtonItem:))
        rightBarButtonItem.action = selector
        // TODO: ADD CLOSE IMAGE
        rightBarButtonItem.title = "CLOSE"
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func closeButton(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ViewController: JWPlayerDelegate {
    func onFullscreen(_ event: (JWEvent & JWFullscreenEvent)!) {
        if let isFullScreen = event?.fullscreen {
            if isFullScreen {
                if let deviceOrientation = UIDevice.current.value(forKey: "orientation") as? Int, deviceOrientation == 1 {
                    UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
                    ViewController.attemptRotationToDeviceOrientation()
                }
            } else {
                if let deviceOrientation = UIDevice.current.value(forKey: "orientation") as? Int, deviceOrientation != 1 {
                    UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                    ViewController.attemptRotationToDeviceOrientation()
                }
            }
        }
    }
}
