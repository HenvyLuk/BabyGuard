//
//  TapableView.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

protocol SeatViewProtocol: NSObjectProtocol {
    
    func tapableView (view: UIView, tappedWithRecognizer recognizer: UITapGestureRecognizer)
    
    func tapableView(view: UIView, longPressedWithRecognizer recognizer: UILongPressGestureRecognizer)
    
}
class TapableView: UIView {
    weak var theDelegate: SeatViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapableView.tappedByRecognizer(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TapableView.longPressedByRecognizer(_:)))
        self.addGestureRecognizer(longTapRecognizer)
        
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapableView.tappedByRecognizer(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TapableView.longPressedByRecognizer(_:)))
        self.addGestureRecognizer(longTapRecognizer)
        
    }
    

    func tappedByRecognizer(recognizer :UITapGestureRecognizer) {
        self.theDelegate?.tapableView(self, tappedWithRecognizer: recognizer)
        
    }
    
    func longPressedByRecognizer(recognizer :UILongPressGestureRecognizer) {
        self.theDelegate?.tapableView(self, longPressedWithRecognizer: recognizer)
    }
    
    
    
    
}
