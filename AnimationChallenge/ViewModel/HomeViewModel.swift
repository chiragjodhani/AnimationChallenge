//
//  HomeViewModel.swift
//  AnimationChallenge
//
//  Created by Eryushion Techsol on 08/03/21.
//

import Foundation
import SwiftUI
class HomeViewModel: ObservableObject {
    
    @Published var showCart = false
    @Published var selectedSize = ""
    
    
    // Animation Properties......
    @Published var startAnimation = false
    @Published var shoeAnimation = false
    
    @Published var showBag = false
    @Published var saveCart = false
    
    @Published var addItemtoCart = false
    
    @Published var endAnimation = false
    
    //cart items.....
    @Published var cartItem = 0
    
    // Pergorming Animation .......
    func performingAnimation() {
        withAnimation(.easeOut(duration: 0.8)){
            shoeAnimation.toggle()
        }
        
        // chain animations......
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeInOut) {
                self.showBag.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.saveCart.toggle()
            }
        }
        
        //0.75 + 0.5 = 1.25
        // because to start animation before the shoe comes to cart
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.addItemtoCart.toggle()
        }
        
        
        // end animation will start at 1.25....
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.endAnimation.toggle()
            }
        }
    }
    
    func resetAll(){
        // giving some time to finish animations.......
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.showCart.toggle()
            }
            self.startAnimation = false
            self.endAnimation = false
            self.selectedSize = ""
            self.addItemtoCart = false
            self.showBag = false
            self.shoeAnimation = false
            self.saveCart = false
            self.cartItem += 1
        }
    }
}
