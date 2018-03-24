//
//  msgViewController.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 7/28/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

public var msgViewContObj : UIViewController?
  public var switchArea : UIButton!



class msgViewController: UIViewController, UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate {


    @IBOutlet weak var trial: UIView!

    var controller : msgsScene! = msgsScene()
  
    var panRecognizerHome:UIPanGestureRecognizer!
    var nextController : UIView = UIView()
    var  currentController  : UIView = UIView()
    var overallView  : UIView = UIView()
    var ChangeTo : UIViewController = UIViewController()
    var type : Int = 0  // code expandability

    
    lazy var animator : UIDynamicAnimator = {
        let  lazyAnimator = UIDynamicAnimator(referenceView: self.view)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    lazy var ratioHW : CGFloat = {
        let  lazyratioHW : CGFloat = self.view.frame.width/self.view.frame.height
        return lazyratioHW
    }()
  

    
    func handleTap(sender: UIButton!) {
        overallView =  UIView(frame: CGRect(x:0,y:0, width:2 * view.frame.width, height:2 * view.frame.height))
        overallView.backgroundColor = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1)
        overallView.tag = 301
        
        currentController =  UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height))
            currentController.backgroundColor = UIColor(patternImage: takeScreenshot("messagesArena", current: true, view: view))
            
            connect.identifier = "home"
            connect.className = 0
            connect.slope = -1
            // this is where it should go
            connect.coord = CGPoint(x:  3/2 * view.frame.width, y: -1/2 * view.frame.height)
            animator.removeAllBehaviors()
            view.addSubview(overallView)
        nextController = UIView(frame: CGRect(x:-view.frame.width, y:view.frame.height, width:view.frame.width, height:view.frame.height))
            
            nextController.backgroundColor = UIColor(patternImage: takeScreenshot(connect.identifier, current: false, view: view))
            currentController.addSubview(nextController)
            currentController.tag = 300
            view.addSubview(currentController)
            let itemBehavior = UIDynamicItemBehavior(items: [currentController]);
            itemBehavior.allowsRotation = false
            animator.addBehavior(itemBehavior);
            
                let   snapBh = UISnapBehavior(item: currentController, snapTo: connect.coord )
                snapBh.damping = 1
                animator.addBehavior(snapBh)
                type = 1
        

        
      //  let scene =

        //scene?.beforeLeaving()
       // let controller = as msgsScene
controller.beforeLeaving()


    }
    

    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        
        if let item = self.view.viewWithTag(300) {
            item.removeFromSuperview()
        }
        if let item = self.view.viewWithTag(301) {
            item.removeFromSuperview()
        }
        
        switch type {
            
        case 1:

            
               ChangeTo = (self.storyboard?.instantiateViewController(withIdentifier: connect.identifier) as? HomeViewController)!
               ChangeTo.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
               self.navigationController?.pushViewController(ChangeTo, animated: false)
            break
        default:
            break
        }
        
        
        
    }
            
            
    override func viewDidLoad() {
    //    self.navigationController!.toolbarHidden = true;
        
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let userIcon = UIImage(named: "ic-signin");
        
        
        switchArea = UIButton(frame:CGRect(x: 0, y:  view.frame.height-(userIcon?.size.height)!, width: (userIcon?.size.width)!, height: (userIcon?.size.height)!))
        self.view.addSubview(switchArea)
        switchArea.setImage(userIcon, for: .normal)
        switchArea.tag = 30
        switchArea.addTarget(self, action: #selector(msgViewController.handleTap(sender:)), for: .touchDown)
        
        
        // setting view
        trial.frame.size = CGSize(width: view.frame.width,height: view.frame.height - 20 )
        
        
        if let view = trial as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            
            // for accelerating crash implement all true
            view.showsFPS = true
            view.showsNodeCount = false
            view.showsDrawCount = false
            view.showsFields = false
            if let scene: SKScene = msgsScene(fileNamed: "msgsScene" ) {
                // Set the scale mode to scale to fit the window
                

                scene.anchorPoint = CGPoint(x:0,y:0);

                //let scenePointer : msgsScene  = scene
               // scenePointer.beforeLeaving()
                
                controller  = scene as! msgsScene
                controller.viewController = self
                
                
                
               scene.scaleMode = .resizeFill


                // Present the scene
                view.presentScene(scene)
            }
        }
        
        msgViewContObj = self
        
        

        
    }

   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    
    var showStatusBar = true
    
    override var prefersStatusBarHidden: Bool {
        if showStatusBar {
            return false
        }
        return true
    }
    
    func showStatusBar(enabled: Bool) {
        switchArea.alpha = enabled ? 1 : 0
        showStatusBar = enabled
        _ = prefersStatusBarHidden;
    }

}

