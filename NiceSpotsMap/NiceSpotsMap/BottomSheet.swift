//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

struct BottomSheet<Content>: View where Content: View {
    @GestureState private var gestureState: CGFloat = 0
    @State private var offset: CGFloat = 0
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader{ geomerty in
            VStack{
                self.content
            }
            .frame(width: geomerty.size.width, height: geomerty.size.height)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(50)
            .offset(y: self.offset + self.gestureState)
            .animation(.interactiveSpring(), value: self.offset)
            .gesture(DragGesture()
                .updating($gestureState){ currentState, gestureState, transaction in gestureState = currentState.translation.height }
                .onEnded{ value in self.offset = value.location.y }
            )
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(){
            Text("Test text")
        }
    }
}
