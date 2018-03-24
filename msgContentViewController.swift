//
//  msgContentViewController.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 7/30/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import UIKit

struct touchCoordinates {
    static var xTouchPos : CGFloat = 0
    static var yTouchPos : CGFloat = 0
    static var dV : CGFloat = 1
    static var totalTime : Double = 0
    static var imageName : String = ""
}

    private var keyboardStatus = false;

class msgContentViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {


    
    var sendMsg: UIButton!
    //var messageScroller: UIScrollView!

    var messgCell : messaging!
    var msgContents : [UIView] = [];
    var msgCounter : CGFloat = 0 ;
    

   
     var stopImg = CGPoint(x : 40, y: 70)
     var stopImgHidden = CGPoint(x : 40, y: 30)
    var myTimer: Timer? = nil
    var panRecognizer:UIPanGestureRecognizer!
    var sketchAreaPan:UIPanGestureRecognizer!
    var tapRecognizer:UITapGestureRecognizer!
    var messgCellView:UITapGestureRecognizer!
    var multipleHeight : CGFloat = 1;
    
  var mainImageView: UIImageView!
  var tempImageView: UIImageView!
    
    var prevState : CGFloat = 0
    var prevStateBool : Bool = false
    var prevScrollPos : [CGFloat] = [0.0,0.0,0.0]
    
    var choicesMenu :  UIView!
    var sketchCanvas :  UIView!
    var sketchArea :  UIView!
    
    var pictureBtn : UIButton!;
    var sketchBtn : UIButton!;
    var textBtn : UIButton!;
    let choiceWdth : CGFloat = 280;
    
    var textMsgHold: UITextView!
    //@IBOutlet weak var msgsView: UIView!
    var image : UIImage! = UIImage()
    var ImgView : UIImageView!  = UIImageView()
    let cornerMargin : CGFloat = 0;
    var  viwHeight : CGFloat = 0;
    
    var blackHoleImage : UIImage! = UIImage()
    var blackHoleImgView : UIImageView!  = UIImageView()
    
    let animation = CAKeyframeAnimation()
    
    
    
    
    let fullRotation = CGFloat(M_PI * 2)
    
   let msgsBehavior = ballsBehavior();
    

    // this is for it to be held, since it hasnt been initialialized
    lazy var animator : UIDynamicAnimator = {
        let  lazyAnimator = UIDynamicAnimator(referenceView: self.view)
        return lazyAnimator
    }()
    

    
    var imgOrigin : CGPoint{
        return CGPoint(x: touchCoordinates.xTouchPos, y:  touchCoordinates.yTouchPos)
    }
    
    
    var imgViewPos : CGPoint = CGPoint(x: 0, y:0);
    // tap
    func messgCellViewTap(_ recognizer: UITapGestureRecognizer) {
//        self.view?.viewWithTag(113) != nil ? self.view.viewWithTag(113)!.removeFromSuperview() : ()
        
        if (self.view?.viewWithTag(113) != nil ){
        let duration: TimeInterval = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.sketchCanvas.frame.origin.y += 270
            }, completion: { finished in
               self.sketchCanvas.removeFromSuperview()
                self.mainImageView.image = nil
                self.lines.removeAll()
                self.linesSnap.removeAll()
                self.pastArts.removeAll()
                self.colorCount = 0;
                self.countMem = 0;
        })
        }

        dismissKeyboard()

    }
    // tap
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view?.viewWithTag(111) != nil ? self.view.viewWithTag(111)!.removeFromSuperview() : ()
        self.view?.viewWithTag(112) != nil ? self.view.viewWithTag(112)!.removeFromSuperview() : ()
        if (self.view?.viewWithTag(113) != nil ){
            let duration: TimeInterval = 0.3
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.sketchCanvas.frame.origin.y += 270

                }, completion: { finished in
                   
                    self.sketchCanvas.removeFromSuperview()
                    self.mainImageView.image = nil
                    self.lines.removeAll()
                    self.linesSnap.removeAll();
                    self.pastArts.removeAll()
                    self.colorCount = 0;
                    self.countMem = 0;

            })
        }
        self.view.viewWithTag(110)!.alpha = 1
    }
    
    // paint
    var swiped = false
    var lastPoint : CGPoint!
    var red: Float = 0.0
    var green: Float = 0.0
    var blue: Float = 0.0
    var brushWidth: CGFloat = 5.0
    var lines : [drawLine] = [];
    var linesSnap : [Int] = [];

    
    

    func handlePaint(_ recognizer: UIPanGestureRecognizer) {
       // print("YA bitch")
        let translation = recognizer.location(in: tempImageView)
        
        //print("First \(translation) + \(sketchArea.frame.origin)")
        
        
        
        switch recognizer.state{
            
        case.began:
            
            swiped = false
            lastPoint = translation;
            
           //    print("First-0 : \(linesSnap.count) : \(countMem) : \(lines.count): \(pastArts.count) ")
            if(countMem != 0)
            {

                if (countMem == linesSnap.count)
                {
                    lines.removeAll()
                    linesSnap.removeAll()
                    pastArts.removeAll()
                }else{
                    lines.removeSubrange(linesSnap[((linesSnap.count-1) - countMem)] ... lines.count-1 )   //+1 start from next array container
                    linesSnap.removeSubrange((linesSnap.count  - countMem) ... linesSnap.count-1)
                    pastArts.removeSubrange((pastArts.count  - countMem) ... pastArts.count-1)

                }
              

                    countMem = 0;
            }
            
          //    print("First-1 : \(linesSnap.count) : \(lines.count) : \(pastArts.count)")
            lines.append(drawLine(startPt: lastPoint, endPt: lastPoint, lineColor: kelem.backgroundColor! ));

           // print("First-2 : \(linesSnap.count) : \(lines.count) : \(pastArts.count)")
            break;
        case .changed:
            
                swiped = true
                lines.append(drawLine(startPt: lastPoint, endPt: translation, lineColor: kelem.backgroundColor!));
                
                drawLineFrom();

                
                lastPoint = translation
                
               
            break;
        case .ended:
 
            // draw a single point
            if !swiped {
               drawLineFrom();
            }
            
      
            mainImageView.image = tempImageView.image
            
            if(pastArts.count < MAX_MEM_SIZE){
                pastArts.append(mainImageView.image)
                linesSnap.append(lines.count)
                astaws.backgroundColor = UIColor.black
                astaws.alpha = 0.1 * CGFloat( pastArts.count)
                print(lines.count)
                
            }else{
                pastArts.removeFirst()
                pastArts.append(mainImageView.image)
                linesSnap.append(lines.count)
            }
            
          //   print("Second : \(linesSnap.count) : \(countMem)")
            
            tempImageView.image = nil
            
            
            break;
        default:
            
            break;
        }
    
    
    }
    
    func drawLineFrom() {
 
        UIGraphicsBeginImageContext(sketchArea.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setLineCap(universalLineProp.lineCap)
        context!.setLineWidth(universalLineProp.brushWidth)
        
        for line in lines{
            context!.beginPath()
            context!.move(to: CGPoint(x: line.startPt.x, y: line.startPt.y));
            context!.addLine(to: CGPoint(x: line.endPt.x, y: line.endPt.y));
            context!.setStrokeColor(line.lineColor.cgColor)
            context!.strokePath()
        }

        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
    
    
    
    
    // pan
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
  
        
     animator.removeAllBehaviors()
        
        
        let translation = recognizer.location(in: view)
        ImgView.center = translation
        
        
        
        
        switch recognizer.state{
            
        case.began:
            blackHoleImgView.alpha = 1;
            blackHoleImgView.layer.add(animation, forKey: "rotate")
       // animator.addBehavior(msgsBehavior)
            break
        case .ended:

            if translation.y > self.view.frame.height - 70{
                 dismiss(animated: false, completion: nil)
            }
            else{
                let snapBh = UISnapBehavior(item: ImgView, snapTo: self.imgViewPos )
                snapBh.damping = 0.5
                animator.addBehavior(msgsBehavior)
                animator.addBehavior(snapBh)
                blackHoleImgView.alpha = 0;
                
            }
            
             break
        default:

            break;
        }
        
        
 
  
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        keyboardStatus = false
    }
    
    
    func keyboardWillShow(_ sender: Notification) {
        keyboardStatus = true
    }
    
    func keyboardWillHide(_ sender: Notification) {
        keyboardStatus = false
    }
    

    func pictureBtnAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    
    /////
    let MAX_MEM_SIZE = 10;
    var pastArts: [UIImage?] = []

    let CONTROL_SIZE : CGFloat = 15;
    let CONTROL_SPACING : CGFloat = 10;
    // controls
    let lapis = UIButton(type: .custom)
    let astaws = UIButton(type: .custom)
   let kelem = UIButton(type: .custom)
    
    var colorCount : Int = 0;
    let colorArray:[UIColor] = [
        .black,
        .red,
        .yellow,
        .green,
        .blue
    ]
    
    
    
    
    func sketchBtnAction(_ sender: UIButton!) {
   //     print("Button tapped")
        
        let padding : CGFloat = 15;
        let drawingAreaWidth  : CGFloat = self.view.frame.width - 2*padding
        
        
        sketchCanvas = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 270));
        sketchCanvas.backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 0.7)
        sketchCanvas.tag = 113;

        
        
       
        lapis.backgroundColor = UIColor.white
        lapis.frame = CGRect(x: drawingAreaWidth  , y: padding - CONTROL_SIZE/2, width: CONTROL_SIZE, height: CONTROL_SIZE)
        lapis.layer.cornerRadius = 0.5 * CONTROL_SIZE
        lapis.clipsToBounds = true
        lapis.addTarget(self, action: #selector(lapisMehtod), for: .touchUpInside);
        
        
        
        
        astaws.backgroundColor = UIColor.white
        astaws.alpha = 1;
        astaws.frame = CGRect(x: drawingAreaWidth - CONTROL_SPACING - CONTROL_SIZE , y: padding - CONTROL_SIZE/2, width: CONTROL_SIZE, height: CONTROL_SIZE)
        astaws.layer.cornerRadius = 0.5 * CONTROL_SIZE
        astaws.clipsToBounds = true
        astaws.addTarget(self, action: #selector(astawsMethod), for: .touchUpInside);
        
        
        
        
        
        kelem.backgroundColor = UIColor.black
        colorCount = 1; // avoid first click repeat
        kelem.frame = CGRect(x: drawingAreaWidth - 2*CONTROL_SPACING - 2*CONTROL_SIZE  , y: padding - CONTROL_SIZE/2, width: CONTROL_SIZE, height: CONTROL_SIZE)
        kelem.layer.cornerRadius = 0.5 * CONTROL_SIZE
        kelem.clipsToBounds = true
        kelem.addTarget(self, action: #selector(kelemMethod), for: .touchUpInside);
        
        
        
        
        sketchAreaPan = UIPanGestureRecognizer(target: self, action:#selector(msgContentViewController.handlePaint(_:)))
        sketchAreaPan.delegate = self
        
        
        sketchArea = UIView(frame: CGRect(x: padding, y: 2*padding, width: drawingAreaWidth, height: sketchCanvas.frame.height - 3*padding));
        sketchArea.backgroundColor = UIColor.white
        sketchArea.layer.cornerRadius = padding/2
        sketchArea.isUserInteractionEnabled = true
        sketchArea.addGestureRecognizer(sketchAreaPan)
        sketchArea.clipsToBounds = true
        
        mainImageView = UIImageView(frame: sketchArea.frame)
        mainImageView.frame.origin = CGPoint.zero
        tempImageView =  UIImageView(frame: sketchArea.frame)
        tempImageView.frame.origin = CGPoint.zero
            
        
        
        sketchArea.addSubview(mainImageView)
        sketchArea.addSubview(tempImageView)
        sketchCanvas.addSubview(lapis);
        sketchCanvas.addSubview(astaws);
        sketchCanvas.addSubview(kelem);
        sketchCanvas.addSubview(sketchArea)
        self.view.addSubview(sketchCanvas);
        
        
                let duration: TimeInterval = 0.3
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
               self.sketchCanvas.frame.origin.y -= 270
                }, completion: { finished in
                    
            })
        
        
        
        self.view.viewWithTag(110)!.alpha=0
    }
    
    func lapisMehtod() {
        print("thumbs up button pressed")
        kelem.backgroundColor = UIColor.white;
        
        
    }
    
    var countMem : Int = 0;
    func astawsMethod() {
        
        // if(astaws.alpha < 0.15)
      if(countMem > (pastArts.count - 1)) {
           // print("FF : \(countMem)")
            countMem = 0;
            astaws.backgroundColor = UIColor.black;
            astaws.alpha = CGFloat((pastArts.count)) * 0.1
        mainImageView.image = pastArts[(pastArts.count-1)-countMem]

        }
      else if(countMem == pastArts.count-1){
        astaws.backgroundColor = UIColor.white
        astaws.alpha = 1;
       
        if(pastArts.count < MAX_MEM_SIZE){
            mainImageView.image = nil
             countMem += 1;
        }
        else{
            countMem = 0;
            astaws.backgroundColor = UIColor.black;
            astaws.alpha = CGFloat((pastArts.count)) * 0.1
            mainImageView.image = pastArts[(pastArts.count-1)-countMem]
        }
        
      }
      else {
            // print("SS : \(countMem) : \(astaws.alpha) : \(pastArts.count)")
        
            astaws.alpha = CGFloat((pastArts.count) - countMem) * 0.1
            countMem += 1;
        mainImageView.image = pastArts[(pastArts.count-1)-countMem]

        }
        
 //      print("Final :  \((pastArts.count-1)-countMem)" )
        
    }
    
    func kelemMethod() {
        if(colorCount < colorArray.count)
        {
            kelem.backgroundColor = colorArray[colorCount];
            colorCount += 1;
        }
        else {
            colorCount = 0;
        }
    }
    
    
    
    func textBtnAction(_ sender: UIButton!) {

        textMsgHold = UITextView (frame: CGRect(x: self.view.frame.width - paddingX - 280, y: 30, width: 280, height: minTextViewHeight))
        textMsgHold.delegate = self
        textMsgHold.tag = 111
        self.view.addSubview(textMsgHold)

        
        sendMsg = UIButton(frame: CGRect(x: self.view.frame.width - paddingX - 30, y: 80, width: 30, height: 20))
        sendMsg.setTitle("Send", for: UIControlState())
        //sendMsg.s
        sendMsg.titleLabel?.font = UIFont(name:"HelveticaNeue", size: 12)
        sendMsg.setTitleColor(UIColor.blue, for: UIControlState())
        sendMsg.addTarget(self, action: #selector(msgContentViewController.sendMsg(_:)), for: .touchDown)
        sendMsg.tag = 112
        sendMsg.backgroundColor = UIColor.clear
        

        self.view.addSubview(sendMsg)
        
        self.view.viewWithTag(110)!.alpha=0
        textMsgHold.becomeFirstResponder()

    }
    
     let paddingX : CGFloat = 15;
    override func viewDidLoad() {

        
       super.viewDidLoad()
     
        // creating a collector
        let xValueRow1 : CGFloat = 0 //cornerMargin / 2
        
        let yValueRow1 : CGFloat = 100 //CGFloat(0.0)
        
        
        messgCell = messaging(frame: CGRect(x: xValueRow1, y: yValueRow1, width: self.view.frame.size.width, height: view.frame.height - yValueRow1))
        messgCell.backgroundColor = UIColor.clear
        messgCell.delegate = self
        
        messgCellView = UITapGestureRecognizer(target: self, action:#selector(msgContentViewController.messgCellViewTap(_:)))
        messgCellView.delegate = self
        messgCell.addGestureRecognizer(messgCellView)
        messgCell.isScrollEnabled = true
        
        self.view.addSubview(messgCell)
        
        // updateitem
        imgProperty()
        animator.addBehavior(msgsBehavior)
        
        
        choicesMenu = UIView(frame: CGRect(x: self.view.frame.width - paddingX - 280, y: 30, width: 280, height: minTextViewHeight))
        pictureBtn = UIButton(frame: CGRect(x: 0, y: 0, width: choiceWdth/3, height: minTextViewHeight))
        pictureBtn.addTarget(self, action: #selector(pictureBtnAction), for: .touchDown)

        sketchBtn = UIButton(frame: CGRect(x: choiceWdth*1/3 , y: 0, width: choiceWdth/3, height: minTextViewHeight))
        sketchBtn.addTarget(self, action: #selector(sketchBtnAction), for: .touchDown)

        textBtn = UIButton(frame: CGRect(x: choiceWdth*2/3, y: 0, width: choiceWdth/3, height: minTextViewHeight))
        textBtn.addTarget(self, action: #selector(textBtnAction), for: .touchDown)


        let imageView0 = UIImageView(image: UIImage(named: "picture")!)
        imageView0.frame = CGRect(x: (choiceWdth/3)/2 - 25/2, y: minTextViewHeight/2 - 25/2, width: 25, height: 25)
        pictureBtn.addSubview(imageView0)
        
        let imageView1 = UIImageView(image: UIImage(named: "sketch")!)
        imageView1.frame = CGRect(x: (choiceWdth/3)/2 - 25/2, y: minTextViewHeight/2 - 25/2, width: 25, height: 25)
        sketchBtn.addSubview(imageView1)
        
        let imageView2 = UIImageView(image: UIImage(named: "text")!)
        imageView2.frame = CGRect(x: (choiceWdth/3)/2 - 25/2, y: minTextViewHeight/2 - 25/2, width: 25, height: 25)
        textBtn.addSubview(imageView2)
        
        
        choicesMenu.addSubview(pictureBtn)
        choicesMenu.addSubview(sketchBtn)
        choicesMenu.addSubview(textBtn)
        choicesMenu.tag = 110
        self.view.addSubview(choicesMenu)
        
        msgsBehavior.addDrop(ImgView)
        ImgView.isUserInteractionEnabled = true
        
        
 
        
         let snapBh = UISnapBehavior(item: ImgView!, snapTo: stopImg)
        snapBh.damping = 0.5

        imgViewPos = stopImg
        animator.addBehavior(snapBh)
        

        panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(msgContentViewController.handlePan(_:)))
        panRecognizer.delegate = self
        ImgView.addGestureRecognizer(panRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(msgContentViewController.handleTap(_:)))
        tapRecognizer.delegate = self
        ImgView.addGestureRecognizer(tapRecognizer)
        
       // for the blackhole
        animation.keyPath = "transform.rotation.z"
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float.infinity
        animation.values = [fullRotation, fullRotation*3/4, fullRotation/2, fullRotation/4 ]
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(msgContentViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(msgContentViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
  
         multipleHeight = viwHeight
   
       

        
        // for now just building a shell
         for value in (1...10).reversed() {
            
            self.populateScrollView("\(value) ahsdflkhas ldfjhalkdsjfha lkjdshflakjsdf hl aks jdh",type: (value%2))
        }
 
    }
    
    // set this up somewhere
    let minTextViewHeight: CGFloat = 40
    let maxTextViewHeight: CGFloat = 120
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        //print("HEY DAWG")
        var height = ceil( textView.contentSize.height) // ceil to avoid decimal
        
        if (height < minTextViewHeight  ) { // min cap, + 5 to avoid tiny height difference at min height
            height = minTextViewHeight
        }
        if (height > maxTextViewHeight) { // max cap
            height = maxTextViewHeight
        }
        textMsgHold.frame.size.height  = height // change the value of NSLayoutConstraint
        sendMsg.frame.origin.y = height - minTextViewHeight + 80
        messgCell.frame.origin.y = height - minTextViewHeight + 100


    }
    
    // int bc would like to have -> Group msg: 3 or more colunms
    fileprivate func populateScrollView(_ message : String, type: Int) {
        

         (Bool(type as NSNumber) ? messgCell.rightMessage(multipleHeight, type: type, msg: message, addM:  true) : messgCell.leftMessage(multipleHeight, type: type, msg: message, addM:  false))

        msgContents.append(messgCell)
    }
    
    
    
    fileprivate func addMsg(_ message : String, type: Int){
        

     //   let temp = multipleHeight ;
        
         (Bool(type as NSNumber) ? 
            messgCell.rightMessage(multipleHeight, type: type, msg: message, addM:  true) :
            messgCell.leftMessage( multipleHeight , type: type, msg: message, addM:  true)
        )
    
        

    
        
    }
    
    
    
 
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        
//    if !scrollDirectionDetermined {
//            let translation = scrollView.panGestureRecognizer.translationInView(self.messgCell)
//            if translation.y > 0 {
//            //    print("UP")
//                increaseViewHeight(false, animated: true)
//                scrollDirectionDetermined = true
//            }
//            else if translation.y < 0 {
//              //  print("DOWN")`
//                increaseViewHeight(true, animated: true)
//                scrollDirectionDetermined = true
//            }
//       
//        }
//        
//
//    }
//    
//    var scrollDirectionDetermined : Bool = false
//    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        scrollDirectionDetermined = false
//    }
//    
//    func scrollViewWillEndDragging(scrollView: UIScrollView) {
//        scrollDirectionDetermined = false
//    }
    
    
    
    
//    
//    func increaseViewHeight(hidden:Bool, animated: Bool){
//        
//        // make sure keboard is removed
//        view.endEditing(true)
//        // cant simply toggel it bc there might be a glich that would reverse the cycle
//        
//        imgViewPos = (hidden ? stopImgHidden : stopImg)
//        
//        // to prevent similar action twice
//        if prevStateBool != hidden {
//             animator.removeAllBehaviors()
//            //animator.addBehavior(msgsBehavior)
//            let snapBh = UISnapBehavior(item: ImgView, snapToPoint:imgViewPos)
//            snapBh.damping = 0.2
//            animator.addBehavior(snapBh)
//            
////        let duration: NSTimeInterval = 0.1
////        UIView.animateWithDuration(duration, animations: { () -> Void in
//            self.textMsgHold.frame = CGRectMake(
//                self.textMsgHold.frame.origin.x,
//                (hidden ?  -30 :  30 ),
//                self.textMsgHold.frame.size.width,
//                self.textMsgHold.frame.size.height)
//            
//
//            self.sendMsg.frame = CGRectMake(
//                self.sendMsg.frame.origin.x,
//                (hidden ?  40 :  80 ),
//                self.sendMsg.frame.size.width,
//                self.sendMsg.frame.size.height)
//            
//            self.messgCell.frame = CGRectMake(
//                self.messgCell.frame.origin.x,
//                 (hidden ?  60 : 100),
//                self.messgCell.frame.size.width,
//                 (hidden ?  self.view.frame.height - 60 :  self.view.frame.height - 100))
//            
//            //  (hidden ?  self.view.frame.height - 60 :  self.view.frame.height - 100)
//          //  self.messageScroller.contentSize.height += (hidden ?  40 : -40)
//            
//     //   })
//            
//        }
//
//        prevStateBool = hidden
//        
//        
//    }

     func sendMsg(_ sender: UIButton) {
        
        // this is for effect
    
        self.addMsg(textMsgHold.text,type: 1)
        msgCounter += 1;
        
        textMsgHold.text = nil

        view.endEditing(true)
        keyboardStatus = false
        
        
        
        

        
    }

    
    func imgProperty(){
        image = UIImage(named: touchCoordinates.imageName)
        ImgView = UIImageView(frame: CGRect(origin: imgOrigin, size: constants.imgSize))
        ImgView.image = image
        ImgView.layer.cornerRadius = ImgView.frame.size.width/2
        ImgView.layer.masksToBounds = true
        //self.view.addSubview(ImgView)

        blackHoleImage = UIImage(named: "blackHole")
        blackHoleImgView = UIImageView(frame: CGRect(origin: CGPoint(x: (self.view.frame.width - constants.imgSize.width)/2 , y: self.view.frame.height - (constants.imgSize.height + 10))  , size: constants.imgSize))
        blackHoleImgView.image = blackHoleImage
        blackHoleImgView.layer.cornerRadius = ImgView.frame.size.width/2
        blackHoleImgView.layer.masksToBounds = true
        blackHoleImgView.alpha = 0;
        self.view.addSubview(blackHoleImgView)
        
    }
    


}

