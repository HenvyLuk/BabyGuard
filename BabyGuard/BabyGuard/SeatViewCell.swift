//
//  SeatViewCell.swift
//  BabyGuard
//
//  Created by csh on 16/7/3.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

protocol SeatCellProtocol:NSObjectProtocol {
    func seatCell(cell :SeatViewCell, didSelectAtIndex index :NSInteger)
    func seatCell(cell :SeatViewCell, didLongPressAtIndex index :NSInteger)
    
}

class SeatViewCell: UITableViewCell, SeatViewProtocol{

    var theDelegate: SeatCellProtocol?
    var row = NSInteger()
    var seatViewArray = NSArray()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        let appSize = XDeviceHelper.appSize()
        let bgImgView = UIImageView(frame: CGRectMake(0, 0, appSize.width, 90))
        
        self.contentView .addSubview(bgImgView)
        let interSpce = (appSize.width - 4 * 58 - 20) * 0.25
        let array = NSMutableArray()
        for i in 0..<4 {
            let i = CGFloat(i)
            let view = SeatView(frame: CGRectMake(10 + interSpce * (i + 0.5) + 58 * i, 5, 58, 81))
            view.tag = NSInteger(i)
            
            //view.backgroundColor = UIColor.blueColor()
            view.theDelegate = self
            array.addObject(view)
            self.contentView.addSubview(view)
            
        }
        self.seatViewArray = array
        
    }
    
    func setCellWithSeatArray(seatArray: NSArray) {
        var index = 0
        
        while index < seatArray.count {
            let view = self.seatViewArray[index] as! SeatView
            view.showSeatInformation(seatArray.objectAtIndex(index) as! SeatInfo)
            view.hidden = false
            index += 1
        }
        
        while index < 4 {
            let view = self.seatViewArray[index] as! SeatView
            view.hidden = true
            index += 1
        }
    }
    
    
    func tapableView (view: UIView, tappedWithRecognizer recognizer: UITapGestureRecognizer){
        self.theDelegate?.seatCell(self, didSelectAtIndex: self.row * 4 + view.tag)
        print("tappedWithRecognizer \(self.row)")
    }
    
    func tapableView(view: UIView, longPressedWithRecognizer recognizer: UILongPressGestureRecognizer){
        self.theDelegate?.seatCell(self, didLongPressAtIndex: self.row * 4 + view.tag)
        print("longPressedWithRecognizer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
