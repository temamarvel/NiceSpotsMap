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
    private var gap: CGFloat
    
    init(size: CGSize){
        self.gap = size.height / 10
        self.top = self.gap
        self.middle = size.height / 2
        self.bottom = size.height - self.gap
    }
}
