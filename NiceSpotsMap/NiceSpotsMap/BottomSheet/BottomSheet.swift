//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var isOpen: Bool
    //todo without @State
    @State private var dragEndOffset: CGFloat = 0
    private var offset: CGFloat { self.dragEndOffset + self.translation}
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
            .animation(.interactiveSpring(response: 1), value: self.isOpen)
            .animation(.interactiveSpring(response: 1), value: self.offset)
            .gesture(DragGesture()
                .updating($translation){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in
                    if value.location.y >= geomerty.size.height / 2 && value.location.y <= geomerty.size.height {
                        self.dragEndOffset = geomerty.size.height / 2
                        return
                    }
                    
                    if value.location.y < geomerty.size.height / 2 {
                        self.dragEndOffset = 10
                        return
                    }
                }
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
