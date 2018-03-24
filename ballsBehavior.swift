//
//  ballsBehavior.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 7/28/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import UIKit

class ballsBehavior: UIDynamicBehavior {
    
    
  
       
//        // dx -ve bc it goes in the -ve direction
//       let distance = CGVector(dx: stopImg.x - touchCoordinates.xTouchPos , dy:   stopImg.y - touchCoordinates.yTouchPos)
//        
//        // radian result
//        let angle : Double = Double(atan(distance.dy/distance.dx))
//
//        
//        let totalTime : CGFloat =  sqrt(2 * sqrt(pow(distance.dx, 2) + pow(distance.dy, 2))/pow(1000,1))
//        
//        touchCoordinates.totalTime = Double(totalTime)
//        print(" TRIALM: \(cos(angle))  : \(sin(angle)) : \(distance.dy) : \(distance.dx) ")
//
//        let lazyGravity = UIGravityBehavior()
//        
//       // we are leaving in the second quadrant where in this world (-,-)
//        var correctX : CGFloat = 0;
//        var correctY : CGFloat = 0;
//         if(stopImg.x > touchCoordinates.xTouchPos)
//         {correctX = 1}
//         else {correctX =  -1}
//        if(stopImg.y > touchCoordinates.yTouchPos){
//        correctY = 1
//        }
//        
//        else {correctY =  -1}
//        
//        
//        
//        lazyGravity.gravityDirection = CGVector(dx: correctX * abs(touchCoordinates.dV * CGFloat(cos(angle))), dy: correctY * abs(touchCoordinates.dV * CGFloat(sin(angle) )))
//        

    
    // crating collider
    // creating it this way bc i want to figure it out
    
    // and also bc i cant initaillise the animator
    
    
    // and also bc i cant initaillise the animator
    lazy var collider : UICollisionBehavior = {
        
        let lazyCollider = UICollisionBehavior()
        
        // setting boundary
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        lazyCollider.collisionMode = .everything
        return lazyCollider
    }()
    
    lazy var ballsBh : UIDynamicItemBehavior = {
        
        let lazyballsBh = UIDynamicItemBehavior()
        lazyballsBh.allowsRotation = false
        lazyballsBh.resistance = 0.5;
        // 1 is perfect elasticity
        lazyballsBh.elasticity = 0.6
        return lazyballsBh
    }()
    

    override init() {
        super.init()
  
        addChildBehavior(collider)
        addChildBehavior(ballsBh)
    }
    
    func stadium (_ path: UIBezierPath, named name: String){
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func addDrop(_ drop: UIView)  {
        // does add it to reference and animator
        dynamicAnimator?.referenceView?.addSubview(drop)
        collider.addItem(drop)
        ballsBh.addItem(drop)
    }
    
    func removeDrop(_ drop: UIView)  {
 
        collider.removeItem(drop)
        ballsBh.removeItem(drop)
     
       
    }
    
}
