//
//  msgsScene.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 7/28/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import Foundation
import SpriteKit


public var msgSceneView : SKView!
 var msgSceneObj : msgsScene!

enum CardLevel :CGFloat {
    case board = 10
    case moving = 1
    case enlarged = 200
}


    var arrImages:[(name: String, pos: CGPoint)] = [(name: "round-pic-home-1", pos: CGPoint(x:  40, y: 40)), (name: "round-pic-home-2", pos: CGPoint(x: 80 , y: 80)), (name: "round-pic-home-3", pos: CGPoint(x: 120 , y: 120)), (name: "news-profile-pic-1", pos: CGPoint(x: 160 , y: 160)), (name: "news-profile-pic-2", pos: CGPoint(x: 200 , y: 200)), (name: "news-profile-pic-3", pos: CGPoint(x: 240 , y: 240)), (name: "news-profile-pic-4", pos: CGPoint(x: 280 , y: 280)), (name: "profile-pic", pos: CGPoint(x: 320 , y: 320))]



@objc(msgsScene) // this fixed the Terminating app due to uncaught exception 'NSInvalidUnarchiveOperationException' error
class msgsScene : SKScene ,  UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate, SKPhysicsContactDelegate{
    
    // these two help with throwing
    var viewController: msgViewController!
    var holding: Bool = false
    var touchPoint: CGPoint = CGPoint(x: 0,  y:0)
    var movingIcon: SKSpriteNode!
    var  shadow : SKShapeNode!
    let speedControll : Float = 0.1
    
    var panRecognizer:UIPanGestureRecognizer!
    var longRecognizer:UILongPressGestureRecognizer!
    var tapRecognizer: UITapGestureRecognizer!
    
    var menuAgent : optionsMenu!
    
    lazy var borderBody : SKPhysicsBody = {
        
        let lazyborderBody = SKPhysicsBody(edgeLoopFrom: (self.view?.bounds)!)
        
        return lazyborderBody
    }()
    
    

    
    
    // var borderBody : SKPhysicsBody =
    
    var dropSize : CGSize{
        let size = 48
        return CGSize(width: size , height: size)
    }
    
    //   var arrImages : [String] = ["profile-pic","round-pic-home-1","round-pic-home-2","round-pic-home-3", "news-profile-pic-1", "news-profile-pic-2", "news-profile-pic-3", "news-profile-pic-4"]
    
    
    
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        
        
        
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        
        
        if  let card = atPoint(touchLocation) as? msgIcon {
            
            
            
            // this is bc our anchor point is bottom left
            touchCoordinates.xTouchPos =  card.position.x - card.frame.width/2;
            touchCoordinates.yTouchPos =  self.frame.height - card.position.y - card.frame.height/2;
            touchCoordinates.imageName = String(card.textureName)
            
            //     print("LLLLLL : ME \(touchCoordinates.imageName)")
            
            // create a new viewcontroller
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let messageView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "receivedM")
            
            messageView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            
            
            
            self.view!.window?.rootViewController?.present(messageView, animated: false, completion: {      })
            
            
            
           self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
            
            
        }
        
        
    }
    
    
    var longPressed : Bool = false
    var contactHappendLong : Bool = false
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////// for more information. functionality :
    // go to profile page
    // delete
    // set as -> family member, ?fwb, lover/inrelatioin ship with/partner, hater,
    // play ->
    func handleLong(recognizer: UILongPressGestureRecognizer) {
        
       
        
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        
        // let translation = recognizer.translationInView(recognizer.view!)
        
        switch recognizer.state {
        case .began:
             longPressed = true
            if  let card = atPoint(touchLocation) as? msgIcon {
                
                card.zPosition = CardLevel.board.rawValue
                touchPoint = touchLocation
                movingIcon = card

            }
            break
        case .changed:
            
            
            
            
            !contactHappendLong ? touchPoint = touchLocation : ()
            
          //  touchPoint = touchLocation
            //    shadow.position = touchLocation
            holding = true
            
            break
        case .possible:
            fallthrough
        case .failed:
            fallthrough
        case .cancelled:
            fallthrough
        case .ended :
        
            contactHappendLong = false
       //     longPressed = false
            if holding && movingIcon != nil{
                
                movingIcon!.zPosition = 0
                recognizer.cancelsTouchesInView = false
                movingIcon = nil
                
            }
            
            
            holding = false
            
            break
        }
    }

    

    func menu(){
        view?.isPaused = true
        if(menuAgent.activateMenu(background: takeScreenshot("camera", current: true, view: self.view!))){
            //
        }
   
    }
    
    
    
  //  func
    func didBegin(_ contact: SKPhysicsContact) {
     // print("DING DONG1")
        //print("This is the result: \(contact.bodyB) : \(contact.contactNormal)")
        
        if longPressed && contact.bodyB.node == movingIcon{
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case constants.physicsCatagory.wallCategory | constants.physicsCatagory.msgIcon:
            //either the contactMask was the bro type or the ground type
           contactHappendLong = true
           menu()
           
            break
            
        default:
            return
            
            }
            
             longPressed = false
        }
    }
    
    
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        // let translation = recognizer.translationInView(recognizer.view!)
        
        switch recognizer.state {
        case .began:
            if  let card = atPoint(touchLocation) as? msgIcon {
                longPressed = false

                
                card.zPosition = CardLevel.board.rawValue
                touchPoint = touchLocation
                movingIcon = card
                
                
        //        card.removeActionForKey("drop")
       //         card.runAction(SKAction.scaleTo(1.2, duration: 0.25), withKey: "pickup")
                
            }
            break
        case .changed:
            
            touchPoint = touchLocation
            //    shadow.position = touchLocation
            holding = true
            
            break
        case .possible:
            fallthrough
        case .failed:
            fallthrough
        case .cancelled:
            fallthrough
        case .ended :
            
        //    longPressed = false
         
            if holding && movingIcon != nil{
                
                movingIcon!.zPosition = 0
//                movingIcon!.removeActionForKey("pickup")
//                movingIcon!.removeActionForKey("heart")
//                shadow.removeActionForKey("heart")
                recognizer.cancelsTouchesInView = false
                
  //              movingIcon!.runAction(SKAction.scaleTo(1.0, duration: 0.25), withKey: "drop")
   //             shadow.alpha = 0
                movingIcon = nil
             
            }
            
            
            holding = false
            
            break
        default:
 //           movingIcon!.runAction(SKAction.scaleTo(1.0, duration: 0.25), withKey: "drop")
//            movingIcon!.removeActionForKey("pickup")
//            movingIcon!.removeActionForKey("heart")
//            shadow.removeActionForKey("heart")
//            shadow.alpha = 0
            movingIcon = nil
            break
        }
        
        
        
        
    }
    

    
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.isUserInteractionEnabled = true
        
    
        tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(msgsScene.handleTap(recognizer:)))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        
        panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(msgsScene.handlePan(recognizer:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 1
        
        view.addGestureRecognizer(panRecognizer)
        
        longRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(msgsScene.handleLong(recognizer:)))
        longRecognizer.delegate = self
        view.addGestureRecognizer(longRecognizer)
       
        //view.backgroundColor = UIColor.blackColor()
        
        // set world
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        //physicsWorld.addJoint(<#T##joint: SKPhysicsJoint##SKPhysicsJoint#>)
        self.physicsBody = borderBody
        self.physicsBody?.friction = 0.2 // default
        self.physicsBody?.categoryBitMask = constants.physicsCatagory.wallCategory
        self.physicsBody?.collisionBitMask = constants.physicsCatagory.msgIcon
        self.physicsBody?.contactTestBitMask = constants.physicsCatagory.msgIcon
        self.physicsWorld.contactDelegate = self
        view.showsPhysics = true
        //print(" YAAA : \(self.borderBody.path)")
        
        
        
        let circleCenter : [CGPoint] = [CGPoint(x:120,  y:frame.height - 120), CGPoint(x:frame.width - 120, y:frame.height - 120), CGPoint(x:frame.width - 120, y:120), CGPoint(x:120, y:120)]
        
      
        let start : [Double] = [M_PI_2 ,2 * M_PI , 3/2 * M_PI, M_PI]
       
       
      
      // creating a stadium
        for walls in 0 ... 3 {
         
            let end = CGFloat(start[walls]) + CGFloat(2 * M_PI * decimalInput)
            let circlePath = UIBezierPath(arcCenter: circleCenter[walls], radius: circleRadius, startAngle: CGFloat(start[walls]), endAngle: end, clockwise: true)
            
            stadium = SKShapeNode(path: circlePath.cgPath)
            stadium.physicsBody = SKPhysicsBody(edgeChainFrom: circlePath.cgPath)
            stadium.strokeColor = UIColor.black
            stadium.physicsBody?.categoryBitMask = constants.physicsCatagory.stadiumCa
            stadium.physicsBody?.collisionBitMask =  constants.physicsCatagory.msgIcon
            self.addChild(stadium)
            
        }
   
     
        var nameCounter = 0;
        for (name, pos) in arrImages  {
            let msgIc : msgIcon  = msgIcon (iconType: .normal, frontIcon: name)
            iconProperty(msgIcon: msgIc , name: nameCounter , pos: pos)
            nameCounter += 1
        }
        
        
        
        msgSceneView = view
        msgSceneObj =  self

        
        /// set up menu
        // disable any other menu creations
        menuAgent = optionsMenu.init(frame: CGRect(x: 0, y: -20, width: frame.width, height:frame.height+20),view: viewController.view!)
        
        
        // send caller
        if menuAgent.setMenu(choice: menuCalls.msgSceneCnrl){
            self.view?.addSubview(menuAgent);
        }

    }


    
    
    func beforeLeaving (){
            for child in self.children {
                if child is SKSpriteNode {
                    arrImages[Int(child.name!)!].pos = child.position
                }
            }
        
    }
    
    var stadium : SKShapeNode!
    let circleRadius = CGFloat(120)
      let decimalInput = 0.25
    // let msgIc : [msgIcon]
    
    func applyPhysProp(msgIcon : SKSpriteNode){
        msgIcon.physicsBody = SKPhysicsBody(circleOfRadius: msgIcon.frame.height/2 - 1)
        msgIcon.physicsBody?.restitution = 0.6
        msgIcon.physicsBody?.friction = 0.2
        msgIcon.physicsBody?.affectedByGravity = true
        msgIcon.physicsBody?.isDynamic = true
        msgIcon.physicsBody?.allowsRotation = false
    }
    
    
    func iconProperty(msgIcon : SKSpriteNode, name : Int, pos : CGPoint){
        
             // print("DING DONG1")
        
        msgIcon.size = dropSize
        applyPhysProp(msgIcon: msgIcon)
        
        msgIcon.position = pos
        msgIcon.physicsBody?.categoryBitMask = constants.physicsCatagory.msgIcon
        msgIcon.physicsBody?.collisionBitMask = constants.physicsCatagory.wallCategory | constants.physicsCatagory.msgIcon  | constants.physicsCatagory.stadiumCa
        msgIcon.physicsBody?.contactTestBitMask = constants.physicsCatagory.wallCategory
        msgIcon.zPosition = 0
        msgIcon.name = String(name)
        self.addChild(msgIcon)
        
    }

    override func update(_ currentTime: CFTimeInterval) {
        
        if holding {
            if movingIcon != nil{
                let dt:CGFloat = 1.0/20.0
                let distance = CGVector(dx: touchPoint.x - (movingIcon?.position.x)!, dy: touchPoint.y-(movingIcon?.position.y)!)
                let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                movingIcon!.physicsBody!.velocity = velocity
            }
            
        }
    }
    
      func performJob(_ sender: UIButton!) {
        print(sender.titleLabel?.text!)
    }
}






