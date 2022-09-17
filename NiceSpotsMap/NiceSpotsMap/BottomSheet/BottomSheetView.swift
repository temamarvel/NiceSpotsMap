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
    case bottom
}

struct BottomSheetView<Content>: View where Content: View {
    @GestureState private var dragTranslation: CGFloat = 0
    //важное знание: если проперть передана через биндинг, то когда ее значение меняется то view в которой она использется не пересоздается (не зовется инициалайзер), но перересовывается (redraw)
    @Binding private var isOpen: Bool
    @State private var offset = CGFloat.zero
    
    let openPosition: OpenPosition
    let content: Content
    
    init(isOpen: Binding<Bool>, openPosition: OpenPosition = .middle, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.openPosition = openPosition
        self.content = content()
    }
    
    var body: some View {
        GeometryReader{ _ in
            VStack(){
                DragCapsule()
                self.content
            }
            .onChange(of: isOpen){ newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    if !newValue {
                        offset = .zero
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height * 2,
                   alignment: .top)
            
            .background(Color(.secondarySystemBackground))
            .cornerRadius(40)
            .offset(y: isOpen ? SnappingPositionOffset.getOpenOffset(openPosition) : UIScreen.main.bounds.height)
            .offset(y: dragTranslation)
            .offset(y: offset)
            .gesture(DragGesture()
                .updating($dragTranslation){ value, gestureState, transaction in gestureState = value.translation.height }
                .onEnded{ value in offset = calculateOffset(value) }
            )
            .animation(.spring(), value: isOpen)
            .animation(.spring(), value: dragTranslation)
            //бекграунд полностью перехватывает тапы
            //так можно делать только если не нужна интерактивность с пользоавтелем
            //.background(.ultraThinMaterial).opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private func calculateOffset(_ value: DragGesture.Value) -> CGFloat{
        let currentOffset = SnappingPositionOffset.getOpenOffset(openPosition) + offset + value.translation.height
        
        if currentOffset < SnappingPositionOffset.topMiddleDelta {
            return SnappingPositionOffset.top - SnappingPositionOffset.getOpenOffset(openPosition)
        }
        if currentOffset > SnappingPositionOffset.middleBottomDelta {
            return SnappingPositionOffset.bottom - SnappingPositionOffset.getOpenOffset(openPosition)
        }
        return SnappingPositionOffset.middle - SnappingPositionOffset.getOpenOffset(openPosition)
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(true), openPosition: .middle){
            VStack{
                Text("Test text 123")
                Text("Hello world")
                Spacer()
            }
            .frame(width: 200, height: 400)
            .background(.red)
        }
    }
}
