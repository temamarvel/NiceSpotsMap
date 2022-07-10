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

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var dragTranslation: CGFloat = 0
    //важное знание: если проперть передана через биндинг, то когда ее значение меняется не view в которой она использется не пересоздается (не зовется инициалайзер), но перересовывается (redraw)
    @Binding var snappingPosition: SnappingPosition
    @State private var isOpen: Bool = false
    @State private var position: CGFloat = 0 {
        didSet{
            if position < 0 {
                position = 0
                return
            }
            if position != snappingPosition.middle && abs(position - snappingPosition.middle) <= BottomSheetOptions.snappingDelta {
                position = snappingPosition.middle
                return
            }
            if position != snappingPosition.top && position - snappingPosition.top > 0 && position - snappingPosition.top < BottomSheetOptions.snappingDelta {
                position = snappingPosition.top
                return
            }
        }
    }
    private var offset: CGFloat {
        let result = self.position + self.dragTranslation
        guard result >= 0 else { return snappingPosition.top }
        return result
    }
    let content: Content
    let openPosition: OpenPosition
    
    init(snappingPosition: Binding<SnappingPosition>, openPosition: OpenPosition, @ViewBuilder content: () -> Content) {
        self._snappingPosition = snappingPosition
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
                position = getOpenOffset()
            }
            .frame(width: geomerty.size.width, height: geomerty.size.height, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(40)
            .offset(y: isOpen ? offset : getOpenOffset())
            .animation(.interactiveSpring(), value: offset)
            .gesture(DragGesture()
                .updating($dragTranslation){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in position += value.translation.height }
            )
        }
    }
    
    private func getOpenOffset() -> CGFloat{
        switch self.openPosition {
        case .top:
            return self.snappingPosition.top
        case .middle:
            return self.snappingPosition.middle
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        let snappingPosition = SnappingPosition(size: CGSize())
        BottomSheet(snappingPosition: .constant(snappingPosition), openPosition: .middle){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }.frame(width: 200, height: 400).background(.red)
        }
    }
}
