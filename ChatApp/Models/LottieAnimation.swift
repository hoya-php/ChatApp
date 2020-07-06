//
//  Animation.swift
//  ChatApp
//
//  Created by 伊藤和也 on 2020/07/06.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import Foundation
import Lottie
import Firebase

class LottieAnimation {
    
    let animationView = AnimationView()
    
    //Lottie Make Animation Set
    func lodingAnimation(viewWidth: CGFloat, viewHeight: CGFloat) -> UIView {
        
        let loadingAnimation = Animation.named("loading")
        
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: viewWidth,
                                     height: viewHeight)
        
        animationView.animation = loadingAnimation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
        
    }
    
    //Lottie Make Animation Stop
    func stopAnimation() {
        
        animationView.removeFromSuperview()
        
    }
}
