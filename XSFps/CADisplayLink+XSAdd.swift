//
//  CADisplayLink+XSAdd.swift
//  XSFps
//
//  Created by le on 2018/4/12.
//  Copyright © 2018年 le. All rights reserved.
//

import Foundation
extension CADisplayLink{
    
    
    /// The preferred frame rate for the display link callback.
    var framesPerSecond:Int{
        if #available(iOS 10.0, *){
            return self.preferredFramesPerSecond
        }else{
            return self.frameInterval
        }
        
    }
    open override var debugDescription: String{
        return "\(framesPerSecond)"
    }
    open override var description: String{
        return "\(framesPerSecond)"
    }
    
}
