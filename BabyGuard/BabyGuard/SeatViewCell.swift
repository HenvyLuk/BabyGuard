//
//  SeatViewCell.swift
//  BabyGuard
//
//  Created by csh on 16/7/3.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

protocol CellProtocol:NSObjectProtocol {
    func seatCell(cell :SeatViewCell, didSelectAtIndex index :NSInteger)
    func seatCell(cell :SeatViewCell, didLongPressAtIndex index :NSInteger)
    
}

class SeatViewCell: UITableViewCell, SeatViewProtocol{

    var theDelegate: CellProtocol?
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
            view.theDelegate = self
            array.addObject(view)
            self.contentView.addSubview(view)
            
        }
        self.seatViewArray = array
        
    }
    
    func setSeatCellWithSeatArray(array: NSArray) {
        for i in self.seatViewArray {
            if i.isKindOfClass(SeatView) {
                
            }
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
