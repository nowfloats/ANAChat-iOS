//
//  ConstraintsHelper.swift
//

import UIKit

class ConstraintsHelper: NSObject {
    class func addConstraints(_ leading: CGFloat , trailing : CGFloat, top : CGFloat , height : CGFloat , superView: UIView , subView: UIView) {
        superView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: top))
        superView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1.0, constant: leading))
        superView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1.0, constant: trailing))
        subView.addConstraint(NSLayoutConstraint.init(item: subView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height));
    }
    
    class func updateConstraint(_ superView: UIView , subView: UIView , constraintType : NSLayoutAttribute , constraintValue: CGFloat){
        for (_, element) in (subView.constraints.enumerated()) {
//            if let _ = element as? NSLayoutConstraint{
                if element.firstAttribute == constraintType{
                    if let _ = element.firstItem as? UIView{
                        if element.firstItem === subView{
                            element.constant = constraintValue
                            break
                        }
                    }

                }
//            }
        }
    }
}
