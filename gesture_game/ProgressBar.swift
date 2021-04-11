//
//  ProgressBar.swift
//  gesture_game
//
//  Created by User17 on 2021/4/10.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(getValue())*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemRed))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
    
    func getValue() -> Float {
        var v : Float = Float(value)
        
        return 1 - v
    }
    
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: .constant(0))
    }
}
