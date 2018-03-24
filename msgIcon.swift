//
//  msgIcon.swift
//  Bragging Right
//
//  Created by Yebeltal Asseged on 7/29/16.
//  Copyright © 2016 Play Evil. All rights reserved.
//

import SpriteKit

enum IconType :Int {
    case normal,
    mad,
    scared,
    lough
}

class msgIcon: SKSpriteNode {

    
    let iconType : IconType
    let frontTexture :SKTexture
    var textureName : String = "";
    var setRadius = SKSpriteNode()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(iconType: IconType , frontIcon : String) {
        self.iconType = iconType
        textureName = frontIcon
       


        switch iconType {
        case .normal:
            frontTexture = SKTexture(imageNamed: frontIcon)
        case .mad:
            frontTexture = SKTexture(imageNamed: frontIcon)
        case .scared:
            frontTexture = SKTexture(imageNamed: frontIcon)
        case .lough:
            frontTexture = SKTexture(imageNamed: frontIcon)
        }

        
        
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
    }


    
    

    
    
    
}
