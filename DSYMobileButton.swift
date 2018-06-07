//
//  DSYMobileButton.swift
//  滑动按钮
//
//  Created by DSY on 2018/6/5.
//  Copyright © 2018年 DSY. All rights reserved.
//

import UIKit


enum DSYMobileType:Int{
    ///不可移动
    case None = 0
    ///跟随手指移动
    case Follow
    ///只能垂直移动
    case Vertical
    ///只能水平移动
    case Horizontal
    ///跟随手指移动 靠边
    case PullOver
    
}

class DSYMobileButton: UIButton {
    /// 最大的宽
     static let maxHeight = UIScreen.main.bounds.height
    /// 最大的高
     static let maxWidth = UIScreen.main.bounds.width
    /// 跟随手指移动 靠边时 设置本属性 设置最大的上下开始靠边距离
    var maxPullOver:CGFloat = 60
    ///滑动类型
    var mobileType:DSYMobileType = .None
    /// 滑动边界值
    var edgeInset:UIEdgeInsets = UIEdgeInsets.zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() -> Void {
        self.isUserInteractionEnabled = true
        ///换行显示
        self.titleLabel?.lineBreakMode = .byWordWrapping
        /// 添加滑动手势
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(changePostion(pan:))))
        
        
    }
    
    /// 滑动操作
    @objc func changePostion(pan:UIPanGestureRecognizer) -> Void {
        let point = pan.translation(in: self)
        var originalFrame:CGRect = self.frame
        
        switch mobileType {
        case .None:
            return
        case .Follow:
            originalFrame = changeYWithFrame(point,originalFrame)
            originalFrame = changeXWithFrame(point,originalFrame)
            break
        case .Horizontal:
            originalFrame = changeXWithFrame(point,originalFrame)
            break
        case .Vertical:
            originalFrame = changeYWithFrame(point,originalFrame)
            break
        case .PullOver:
            originalFrame = changeYWithFrame(point,originalFrame)
            originalFrame = changeXWithFrame(point,originalFrame)
            break
            
            
        }
        
        UIView.animate(withDuration: 0) {
            self.frame = originalFrame
        }
        pan.setTranslation(CGPoint.zero, in: self)
        /// 设置按钮在拖动是不可点击
        switch pan.state {
        case .began:
            self.isEnabled = false
            break
        case .changed:
            
            //            self.isEnabled = true
            break
        default:
            if mobileType == .PullOver {
                centerBeyondBoundaryTreatment()
            }else{
                centerBeyondBoundaryTreatment()
            }
            
            self.isEnabled = true
            break
        }
        
    }
    
}
//MARK:  方法处理
extension DSYMobileButton {
    /// 超出边界处理
    func beyondBoundaryTreatment() -> Void {
        var frame:CGRect  = self.frame
        
        var isOver:Bool = false
        if (frame.origin.x < edgeInset.left) {
            frame.origin.x = edgeInset.left
            isOver = true;
            
        }
            
        else if (frame.origin.x + frame.size.width > DSYMobileButton.maxWidth-edgeInset.right) {
            frame.origin.x = DSYMobileButton.maxWidth - frame.size.width-edgeInset.right
            isOver = true
        }
        
        if (frame.origin.y < edgeInset.top) {
            frame.origin.y = edgeInset.top
            isOver = true
            
        } else if (frame.origin.y+frame.size.height > DSYMobileButton.maxHeight-edgeInset.bottom) {
            frame.origin.y = DSYMobileButton.maxHeight - frame.size.height-edgeInset.bottom
            isOver = true
        }
        if isOver {
            //如果越界-跑回来
            UIView.animate(withDuration: 0.3) {
                self.frame = frame
            }
        }
        
    }
    
    /// 超出边界居中处理
    func centerBeyondBoundaryTreatment() -> Void {
        
        var isOver:Bool = false
        var frame:CGRect  = self.frame
        
        if frame.origin.y <= edgeInset.top+maxPullOver
        {
            frame.origin.y = edgeInset.top
            isOver = true
        }
        
        if frame.origin.y > edgeInset.top+maxPullOver && frame.origin.y < DSYMobileButton.maxHeight*0.5 {
            
            if frame.origin.x+frame.size.width >= DSYMobileButton.maxWidth*0.5{
                frame.origin.x = DSYMobileButton.maxWidth - frame.size.width-edgeInset.right
            }else{
                frame.origin.x = edgeInset.left
            }
            
            isOver = true
        }
        
        
        if (frame.origin.y+frame.size.height >= DSYMobileButton.maxHeight-edgeInset.bottom - maxPullOver) {
            frame.origin.y = DSYMobileButton.maxHeight-edgeInset.bottom
            isOver = true
        }
        
        
        if frame.origin.y+frame.size.height >= DSYMobileButton.maxHeight*0.5 && frame.origin.y+frame.size.height <= DSYMobileButton.maxHeight-edgeInset.bottom - maxPullOver  {
            if frame.origin.x+frame.size.width >= DSYMobileButton.maxWidth*0.5{
                frame.origin.x = DSYMobileButton.maxWidth - frame.size.width-edgeInset.right
            }else{
                frame.origin.x = edgeInset.left
            }
            isOver = true
        }
        
        
        if (frame.origin.x < edgeInset.left) {
            frame.origin.x = edgeInset.left
            isOver = true;
            
        }
        if (frame.origin.x + frame.size.width > DSYMobileButton.maxWidth-edgeInset.right) {
            frame.origin.x = DSYMobileButton.maxWidth - frame.size.width-edgeInset.right
            isOver = true
        }
        
        if (frame.origin.y < edgeInset.top) {
            frame.origin.y = edgeInset.top
            isOver = true
            
        }
        if (frame.origin.y+frame.size.height > DSYMobileButton.maxHeight-edgeInset.bottom) {
            frame.origin.y = DSYMobileButton.maxHeight - frame.size.height-edgeInset.bottom
            isOver = true
        }
        
        if isOver {
            //如果越界-跑回来
            UIView.animate(withDuration: 0.3) {
                self.frame = frame
            }
        }
        
    }
    
    //拖动改变控件的水平方向x值
    func changeXWithFrame(_ point:CGPoint,_ originalFrame:CGRect) -> CGRect {
        
        var originalFrameNew = originalFrame
        let x1:Bool = originalFrameNew.origin.x >= 0
        let x2:Bool = originalFrameNew.origin.x + originalFrame.size.width <= DSYMobileButton.maxWidth
        if x1 && x2{
            
            originalFrameNew.origin.x += point.x
        }
        return originalFrameNew
    }
    
    func changeYWithFrame(_ point:CGPoint,_ originalFrame:CGRect) -> CGRect {
        var originalFrameNew = originalFrame
        let y1:Bool = originalFrameNew.origin.y >= 0
        let y2:Bool = originalFrameNew.origin.y + originalFrame.size.height <= DSYMobileButton.maxHeight
        if y1 && y2{
            
            originalFrameNew.origin.y += point.y
        }
        return originalFrameNew
    }
    
}





