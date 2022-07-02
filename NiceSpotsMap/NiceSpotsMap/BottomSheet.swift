//
//  BottomSheet.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 01.07.2022.
//

import SwiftUI

struct BottomSheet: View {
    var body: some View {
        GeometryReader{ geomerty in
            VStack{
                //Text("Test text")
            }
            .frame(width: geomerty.size.width, height: geomerty.size.height)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(50)
            .offset(y: 30)
        }
    }
}
    
    struct BottomSheet_Previews: PreviewProvider {
        static var previews: some View {
            BottomSheet()
        }
    }
