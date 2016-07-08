//
//  ClassViewCell.swift
//  BabyGuard
//
//  Created by csh on 16/7/6.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

protocol ClassCellProtocol:NSObjectProtocol {
    func ClassCell(cell :ClassViewCell, didSelectAtIndex index :NSInteger)
    func ClassCell(cell :ClassViewCell, didLongPressAtIndex index :NSInteger)
    
}

class ClassViewCell: UITableViewCell, SeatViewProtocol{

    var theDelegate: ClassCellProtocol?
    var row = NSInteger()
    var classViewArray = NSArray()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        let appSize = XDeviceHelper.appSize()

        let classWidth = (appSize.width - 4) * 0.5
        let array = NSMutableArray()
        for i in 0..<2 {
            let i = CGFloat(i)
            let view = ClassView.init(frame: CGRectMake(classWidth * i + i + 1, 0, classWidth, classWidth * 1.2))
            view.tag = NSInteger(i)
            view.theDelegate = self
            array.addObject(view)
            self.contentView.addSubview(view)
        }
        self.classViewArray = array
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellWithNameArray(nameArray: NSArray) {
        print("nameArray:\(nameArray)")
        var index = 0

        while index < nameArray.count {
            let view = self.classViewArray[index] as! ClassView
            view.className.text = nameArray[index] as? String
            view.hidden = false
            index += 1
        }
        
        while index < 2 {
            let view = self.classViewArray[index] as! ClassView
            view.hidden = true
            index += 1
        }
    }

    
    func tapableView (view: UIView, tappedWithRecognizer recognizer: UITapGestureRecognizer){
        self.theDelegate?.ClassCell(self, didSelectAtIndex: self.row * 2 + view.tag)
        print("tappedWithRecognizer \(self.row)")
    }
    
    func tapableView(view: UIView, longPressedWithRecognizer recognizer: UILongPressGestureRecognizer){
    
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
