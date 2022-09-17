//
//  SnappingPosition.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 09.07.2022.
//

import SwiftUI

final class SnappingPositionOffset{
    static var top: CGFloat { SnappingPositionOffset.padding }
    static var middle: CGFloat { UIScreen.main.bounds.height / 2 }
    static var bottom: CGFloat { UIScreen.main.bounds.height - padding}
    static var topMiddleDelta: CGFloat { (top + middle) / 2 }
    static var middleBottomDelta: CGFloat { (middle + bottom) / 2 }
    static private var padding: CGFloat { UIScreen.main.bounds.height / 10}
    
    static func getOpenOffset(_ openPosition: OpenPosition) -> CGFloat{
        switch openPosition {
            case .top:
                return SnappingPositionOffset.top
            case .middle:
                return SnappingPositionOffset.middle
            case .bottom:
                return SnappingPositionOffset.bottom
        }
    }
}
