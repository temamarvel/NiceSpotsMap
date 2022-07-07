//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

enum SnappingPosition{
    case top(CGFloat)
    case middle(CGFloat)
    case bottom(CGFloat)
    
    mutating func calculateSnappingPosition(y: CGFloat, size: CGSize){
        //y inside bounds of view
        guard y > 0 && y <= size.height else { return }
        
        //y in the bottom part of view
        if y >= size.height / 2 && y <= size.height {
            self = .middle(size.height / 2)
            return
        }
        
        //y inside the top part of view
        if y < size.height / 2 {
            self = .top(50)
            return
        }
        
        self = .top(0)
    }
}

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var translation: CGFloat = 0
    //важное знание: если проперть передана через биндинг, то когда ее значение меняется не view в которой она использется не пересоздается (не зовется инициалайзер), но перересовывается (redraw)
    @Binding var isOpen: Bool
    @State private var snappingPosition: SnappingPosition = .top(0)
    private var offset: CGFloat {
        switch self.snappingPosition {
        case .top(let value):
            return value + self.translation
        case .middle(let value):
            return value + self.translation
        case .bottom(let value):
            return value + self.translation
        }
    }
    let content: Content
    
    init(isOpen: Binding<Bool> = .constant(false), @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }
    
    var body: some View {
        GeometryReader{ geomerty in
            VStack(){
                DragCapsule()
                self.content
            }
            .frame(width: geomerty.size.width, height: geomerty.size.height + geomerty.safeAreaInsets.bottom, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(40)
            .offset(y: isOpen ? offset : geomerty.size.height)
            .animation(.interactiveSpring(response: 0.8), value: self.isOpen)
            .animation(.interactiveSpring(), value: self.offset)
            .gesture(DragGesture()
                .updating($translation){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in self.snappingPosition.calculateSnappingPosition(y: value.location.y, size: geomerty.size) }
            )
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isOpen: .constant(true)){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }.frame(width: 200, height: 400).background(.red)
        }
    }
}
