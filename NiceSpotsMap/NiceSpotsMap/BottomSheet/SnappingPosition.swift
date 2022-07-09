//
//  SnappingPosition.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 09.07.2022.
//

import Foundation

struct SnappingPosition{
    var top: CGFloat = 0
    var middle: CGFloat = 0
    var bottom: CGFloat = 0
    
    init(size: CGSize){
        self.top = size.height / 10
        self.middle = size.height / 2
        self.bottom = size.height
    }
}
