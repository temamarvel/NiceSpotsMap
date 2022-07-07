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
    static let snappingDelta: CGFloat = 150
}

private struct SnappingPosition{
    static var top: CGFloat = 0
    static var middle: CGFloat = 0
    static var bottom: CGFloat = 0
}

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var dragTranslation: CGFloat = 0
    //важное знание: если проперть передана через биндинг, то когда ее значение меняется не view в которой она использется не пересоздается (не зовется инициалайзер), но перересовывается (redraw)
    @Binding var isOpen: Bool
    @State private var position: CGFloat = SnappingPosition.bottom {
        didSet{
            if position < 0 {
                position = 0
                return
            }
            if position != SnappingPosition.middle && abs(position - SnappingPosition.middle) <= BottomSheetOptions.snappingDelta {
                position = SnappingPosition.middle
                return
            }
            if position != SnappingPosition.top && position - SnappingPosition.top > 0 && position - SnappingPosition.top < BottomSheetOptions.snappingDelta {
                position = SnappingPosition.top
                return
            }
        }
    }
    private var offset: CGFloat {
        let result = isOpen ? self.position + self.dragTranslation : SnappingPosition.bottom
        guard result >= 0 else { return SnappingPosition.top }
        return result
    }
    let content: Content
    let openPosition: OpenPosition
    
    init(isOpen: Binding<Bool> = .constant(false), openPosition: OpenPosition, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.openPosition = openPosition
        self.content = content()
    }
    
    var body: some View {
        GeometryReader{ geomerty in
            VStack(){
                DragCapsule()
                self.content
            }
            .onAppear{ self.setSnappingPositions(size: geomerty.size) }
            .frame(width: geomerty.size.width, height: geomerty.size.height, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(40)
            .offset(y: offset)
            .animation(.interactiveSpring(response: 0.8), value: self.isOpen)
            .animation(.interactiveSpring(), value: self.position)
            .gesture(DragGesture()
                .updating($dragTranslation){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in position += value.translation.height }
            )
        }
//        .onChange(of: self.isOpen) { isOpen in
//            position = isOpen ? SnappingPosition.middle : SnappingPosition.bottom
//        }
    }
    
    func setSnappingPositions(size: CGSize){
        SnappingPosition.top = size.height / 10
        SnappingPosition.middle = size.height / 2
        SnappingPosition.bottom = size.height
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isOpen: .constant(true), openPosition: .middle){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }.frame(width: 200, height: 400).background(.red)
        }
    }
}
