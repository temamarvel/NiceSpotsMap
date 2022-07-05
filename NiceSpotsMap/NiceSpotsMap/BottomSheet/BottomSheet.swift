//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var gestureState: CGFloat = 0
    @Binding var isOpen: Bool
    //todo without @State
    @State private var offset: CGFloat = 0
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
            .offset(y: isOpen ? 10 : geomerty.size.height)
            .animation(.interactiveSpring(response: 1), value: self.isOpen)
            .animation(.interactiveSpring(), value: self.offset)
//            .gesture(DragGesture()
//                .updating($gestureState){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
//                .onEnded{ value in self.offset = value.location.y }
//            )
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }.frame(width: 200, height: 400).background(.red)
        }
    }
}
