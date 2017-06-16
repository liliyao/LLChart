//
//  LLShowInfoView.swift
//  LLChart
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

//长按后出现的弹框
class LLShowInfoView: UILabel {
    override init(frame: CGRect) {
        super.init(frame:frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func updateFrame(frame:CGRect,borderColor:UIColor) {
        UIView.animate(withDuration:0.5) { 
            self.layer.borderColor = borderColor.cgColor
            self.center = CGPoint(x:frame.origin.x, y:frame.origin.y)
        }
    }
}
