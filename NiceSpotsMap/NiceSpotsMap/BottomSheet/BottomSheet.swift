//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

enum OpenPosition{
    case top
    case middle
}

private enum BottomSheetOptions{
    static let snappingDelta: CGFloat = 250
}

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var dragCurrentTranslation: CGFloat = 0
    //важное знание: если проперть передана через биндинг, то когда ее значение меняется не view в которой она использется не пересоздается (не зовется инициалайзер), но перересовывается (redraw)
    
    //@Binding var parentSize: CGSize
    @State private var isOpen: Bool = false
    @State private var dragEndTranslation: CGFloat = 0
    private var offset: CGFloat { self.dragEndTranslation + self.dragCurrentTranslation }
    //let snappingPosition: SnappingPosition
    let openPosition: OpenPosition
    let content: Content
    
    init(openPosition: OpenPosition = .middle, @ViewBuilder content: () -> Content) {
        //self._parentSize =  parentSize
        //self.snappingPosition = SnappingPosition(size: parentSize.wrappedValue)
        self.openPosition = openPosition
        self.content = content()
    }
    
    var body: some View {
        GeometryReader{ geomerty in
            VStack(){
                DragCapsule()
                self.content
            }
            .onAppear{
                isOpen = true
                dragEndTranslation = getOpenOffset(parentSize: geomerty.size)
            }
            .frame(width: geomerty.size.width, height: geomerty.size.height * 2, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(40)
            .offset(y: isOpen ? offset : getOpenOffset(parentSize: geomerty.size))
            .animation(.interactiveSpring(), value: offset)
            .gesture(DragGesture()
                .updating($dragCurrentTranslation){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in
                    let result = dragEndTranslation + value.translation.height
                    let snappingPositions = SnappingPosition(size: geomerty.size)
                    if result < snappingPositions.top {
                        dragEndTranslation = snappingPositions.top
                        return
                    }
                    if result - snappingPositions.top < (snappingPositions.middle - snappingPositions.top) / 2 {
                        dragEndTranslation = snappingPositions.top
                        return
                    }
                    if abs(result - snappingPositions.middle) < (snappingPositions.middle - snappingPositions.top) / 2 {
                        dragEndTranslation = snappingPositions.middle
                        return
                    }
                    dragEndTranslation = snappingPositions.bottom
                }
            )
        }
    }
    
    private func getOpenOffset(parentSize: CGSize) -> CGFloat{
        let snappingPositions = SnappingPosition(size: parentSize)
        switch self.openPosition {
        case .top:
            return snappingPositions.top
        case .middle:
            return snappingPositions.middle
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(openPosition: .middle){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }.frame(width: 200, height: 400).background(.red)
        }
    }
}
