//
//  TypingIndicatorView.swift
//  SwiftCoding
//
//  Created by NFPradeep on 26/07/17.
//  Copyright © 2017 Pradeep Reddy. All rights reserved.
//


import UIKit

class TypingIndicatorView: UIView {
    
    var baseView = UIView()
    
    var typingView = UIView()
    var dotView1 = UIView()
    var dotView2 = UIView()
    var dotView3 = UIView()
    
    var dotViewWidth: CGFloat = 0.0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.configureUI()
//        showTyping()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        baseView = UIView()
        baseView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        baseView.backgroundColor = UIColor.clear
        self .addSubview(baseView)
        
        dotViewWidth = 6
        
        typingView = UIView()
        typingView.frame = CGRect(x: 0, y: 0, width: baseView.frame.size.width, height: baseView.frame.size.height)
        typingView.layer.cornerRadius = 8.0
        typingView.layer.masksToBounds = true
        baseView .addSubview(typingView)
        
        dotView1 = UIView()
        dotView1.backgroundColor = UIColor.white
        dotView1.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
        //    dotView1.layer.masksToBounds = YES;
        typingView.addSubview(dotView1)
        
        dotView2 = UIView()
        dotView2.backgroundColor = UIColor.white
        dotView2.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
        //    dotView2.layer.masksToBounds = YES;
        typingView.addSubview(dotView2)
        
        dotView3 = UIView()
        dotView3.backgroundColor = UIColor.white
        dotView3.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
        //    dotView3.layer.masksToBounds = YES;
        typingView.addSubview(dotView3)
        
        dotView1.frame = CGRect(x: 22, y: (typingView.frame.height / 2) - CGFloat(dotViewWidth / 2) - 5, width: dotViewWidth, height: dotViewWidth)
        dotView2.frame = CGRect(x: 33, y: (typingView.frame.height / 2) - (dotViewWidth / 2) - 5, width: dotViewWidth, height: dotViewWidth)
        dotView3.frame = CGRect(x: 44, y: (typingView.frame.height / 2) - (dotViewWidth / 2) - 5, width: dotViewWidth, height: dotViewWidth)
        
        dotView1.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
        dotView2.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
        dotView3.layer.cornerRadius = (CGFloat(dotViewWidth / 2))
    }
    func showTyping() {
//        self.animateStepsWithIndex(0)
        self.startAnimate()
    }
    /*
    func startAnimate()
    {
        let animateDur: CGFloat = 0.6
        
        UIView.animate(withDuration: TimeInterval(animateDur), delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.animateStepsWithIndex(0)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                self.animateStepsWithIndex(1)
                UIView.animate(withDuration: TimeInterval(animateDur), delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    self.animateStepsWithIndex(2)
                }, completion: {(_ finished: Bool) -> Void in
                    if finished {
                        //                        self.animateStepsWithIndex(2)
                        self.startAnimate()
                    }
                })
            }
        })
    }
    */
    func animateStepsWithIndex(_ stepIndex : NSInteger){
        print(stepIndex)
        print(Date())
        
        if stepIndex == 0 {
            dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
            dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
            dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.3)
        }else if stepIndex == 1{
            dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.3)
            dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
            dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
        }else if stepIndex == 2{
            dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
            dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.3)
            dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
        }
    }
    func startAnimate()
    {
        let animateDur: CGFloat = 0.3
        
        UIView.animate(withDuration: TimeInterval(animateDur), delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            
            self.dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
            self.dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
            self.dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.3)
            
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                
                UIView.animate(withDuration: TimeInterval(animateDur), delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    
                    self.dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
                    self.dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
                    self.dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
                    
                }, completion: {(_ finished: Bool) -> Void in
                    if finished {
                        
                        UIView.animate(withDuration: TimeInterval(animateDur), delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                            
                            self.dotView1.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.3)
                            self.dotView2.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(0.7)
                            self.dotView3.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor().withAlphaComponent(1.0)
                            
                            
                        }, completion: {(_ finished: Bool) -> Void in
                            if finished {
                                
                                let animDelay: Int = Int(animateDur*2)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(animDelay))
                                {
                                    self.startAnimate()
                                }
                                
                            }
                        })
                        
                    }
                })
                
            }
        })
        
    }
    
}
