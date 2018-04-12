//
//  XSFps.swift
//  XSFps
//
//  Created by le on 2018/4/12.
//  Copyright © 2018年 le. All rights reserved.
//

import UIKit
typealias Label = UILabel


class XSFps: Label {
    private var link: CADisplayLink?
    private let defaultFPS = 60.0
    private var count: TimeInterval = 0
    private var lastTime:TimeInterval = 0
    private var   lastSecondOfFrameTimes:[TimeInterval] = []
    private var frameNumber:UInt = 0
    private var frameDuration = 1.0
    override var text: String?{
        didSet{
            textAlignment = .center
            font = UIFont.boldSystemFont(ofSize: 13)
            self.frame.size = CGSize(width: 25, height: 15)
            textColor = UIColor.red
        }
    }
    
    @objc func toggleDrage(sender:UIPanGestureRecognizer){
        let view = sender.view
        let newPoint = sender.translation(in: view)
        let x:CGFloat = (sender.view?.center.x)! + newPoint.x
        
        let y: CGFloat = (sender.view?.center.y)! + newPoint.y
        sender.view?.center = CGPoint(x: x, y: y)
        
        
        sender.setTranslation(.zero, in: view?.superview)
        
        
    }
    deinit {
        if (link != nil) {
            link?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0 ... Int(defaultFPS) {
            lastSecondOfFrameTimes.append(0)
        }
        addPan()
        
        link = CADisplayLink(target: self, selector: #selector(start(aLink:)))
        link?.add(to: RunLoop.main
            , forMode: RunLoopMode.commonModes)
        
    }
    private func addPan(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(toggleDrage(sender:)))
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(pan)
    }
    override func removeFromSuperview() {
        link?.invalidate()
        super.removeFromSuperview()
    }
    @objc func start(aLink:CADisplayLink){
        frameNumber += 1
        let currentFrameIndex = Int(frameNumber) % Int(defaultFPS)
        lastSecondOfFrameTimes[currentFrameIndex] = (link?.timestamp)!
        var droppedFrameCount = 0
        let lastFrameTime = CACurrentMediaTime() - frameDuration
        for i in 0..<Int(defaultFPS) {
            if (1.0 <= lastFrameTime - lastSecondOfFrameTimes[i]) {
                droppedFrameCount += 1
            }
        }
        let currentFPS = Int(defaultFPS) - droppedFrameCount
        #if (arch(i386) || arch(x86_64)) && debug
        
        text = "\(aLink.timestamp)\n \(aLink.duration) \n\(aLink.framesPerSecond) \n \(currentFPS)"
        
        #else
        text = "\(currentFPS)"
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for _ in 0 ... Int(defaultFPS) {
            lastSecondOfFrameTimes.append(0)
        }
        addPan()
        link = CADisplayLink(target: self, selector: #selector(start(aLink:)))
        link?.add(to: RunLoop.main
            , forMode: RunLoopMode.commonModes)
    }
    
}
