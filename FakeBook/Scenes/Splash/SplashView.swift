//
//  SplashView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI
struct SplashScreen: View {
    @Binding var showSplash: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Image("fakeBookLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300*iPhoneXFactor, height: 200*iPhoneXFactor)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        scale = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            opacity = 0.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showSplash = false
                        }
                    }
                }
        }
        .foregroundStyle(.black)
    }
}

