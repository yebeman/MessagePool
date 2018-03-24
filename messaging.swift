//
//  messaging.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 8/4/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import UIKit

class messaging: UIScrollView {
    let paddingX : CGFloat = 15;
    let paddingY : CGFloat = 15;
    
    var leftMessages : [UIView] = []
    var rightMessages : [UIView] = []
    
    let duration: TimeInterval = 0.2

    
    func rightMessage(_ height: CGFloat, type: Int, msg: String,addM: Bool)  -> Bool {
        let smallVilage : UIView = UIView()
        smallVilage.backgroundColor =  UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1)
        smallVilage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        smallVilage.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        smallVilage.layer.shadowOpacity = 2.0
        

        let viewWidth = self.frame.size.width
        
        
        
        let textView : UITextView = UITextView()
        textView.text = msg
        textView.backgroundColor =  UIColor.clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor =  UIColor.lightGray
        textView.font = UIFont(name:"HelveticaNeue-bold", size: 12.0)
        textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.frame.size.height += paddingX
        textView.sizeToFit()
        
        
        var tempWidth : CGFloat = 0;
        
        if textView.frame.width > 0.7 * viewWidth {
            tempWidth = 0.7 * viewWidth
            textView.frame.size.width = tempWidth
        }else{
            tempWidth = textView.frame.width
        }
     
        // bc it was updated apparently when i put it one place it wont work properly
        textView.sizeToFit()
        
        let tmpXPos : CGFloat =  viewWidth - tempWidth  - paddingX
        
        smallVilage.frame.origin = CGPoint(x: tmpXPos, y: -textView.frame.height)
        smallVilage.frame.size = CGSize(width: tempWidth, height: textView.frame.height)
        smallVilage.addSubview(textView)

        self.addSubview(smallVilage)
        rightMessages.append(smallVilage)

        
             UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.addView(smallVilage)
              } , completion: { (complete: Bool) in
            })
        

        return true
    }
    
    
    
    
    
    
    func leftMessage(_ height: CGFloat, type: Int , msg: String, addM: Bool)  -> Bool {
        
        let smallVilage : UIView = UIView()
        smallVilage.backgroundColor =  UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        smallVilage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        smallVilage.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        smallVilage.layer.shadowOpacity = 2.0

        let viewWidth = self.frame.size.width
        
        
        // textfield view modification
        let textView : UITextView = UITextView()
        textView.text = msg
        textView.backgroundColor =  UIColor.clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor =  UIColor.lightGray
        textView.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.sizeToFit()


        var tempWidth : CGFloat = 0;
        
        if textView.frame.width > 0.7 * viewWidth {
            tempWidth = 0.7 * viewWidth
            textView.frame.size.width = tempWidth
        }else{
            tempWidth = textView.frame.width
        }
        
        // bc it was updated apparently when i put it one place it wont work properly
        textView.sizeToFit()



        let tmpXPos : CGFloat = paddingX
        smallVilage.frame.origin = CGPoint(x: tmpXPos, y: -textView.frame.height)
        smallVilage.frame.size = CGSize(width: tempWidth, height: textView.frame.height)

        

        smallVilage.addSubview(textView)
        self.addSubview(smallVilage)
        
        leftMessages.append(smallVilage)

        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.addView(smallVilage)
            } , completion: { (complete: Bool) in
        })

        return true
    }
    
    
    func addView(_ smallVilage : UIView)  {


        for items in leftMessages{
            
            items.frame.origin.y += (smallVilage.bounds.height + paddingY)
        
        }
        
        for items in rightMessages{
            
            items.frame.origin.y += (smallVilage.bounds.height + paddingY)
            
        }
        
        self.contentSize.height += smallVilage.bounds.height + paddingY
        
    }
    
    
    
    
    
}
