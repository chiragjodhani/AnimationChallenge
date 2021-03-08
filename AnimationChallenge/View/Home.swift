//
//  Home.swift
//  AnimationChallenge
//
//  Created by Eryushion Techsol on 06/03/21.
//

import SwiftUI

struct Home: View {
    @StateObject var homeData = HomeViewModel()
    
    // Moving Image To top like Hero Animation.....
    @Namespace var animation
    var body: some View {
        ZStack(alignment:.bottom) {
            VStack(spacing: 15.0) {
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "rectangle.3.offgrid.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "bag.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.purple)
                            .clipShape(Circle())
                            .overlay(
                                Text("\(homeData.cartItem)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("orange"))
                                    .clipShape(Circle())
                                    .offset(x: 15, y: -10)
                                    .opacity(homeData.cartItem != 0 ? 1 : 0)
                            )
                    })
                }
                .overlay(
                Text("Nike")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                )
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("Air Max Exosense 'Atomic Power'")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Text("Nike")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Image("s1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal,30)
                        Text("Price")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("$277.0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("orange"))
                        
                    })
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(Color.black.opacity(0.06))
                    .cornerRadius(20)
                    .overlay(
                        Capsule()
                            .fill(Color.purple)
                            .frame(width: 4, height: 45)
                            .padding(.top, 25)
                        ,
                        alignment: .topLeading
                    )
                    .padding()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            homeData.showCart.toggle()
                        }
                    }
                }
            }
            .blur(radius: homeData.showCart ? 50 : 0)
            
            AddToCart(animation: animation)
                // hiding view when shoe is not selected.....
                // like bottom sheet......
                // also closing when animation started.....
                .offset(y: homeData.showCart ? homeData.startAnimation ? 500 :  0 : 500)
                .environmentObject(homeData)
            
            // Animation
            if homeData.startAnimation {
                VStack {
                    Spacer()
                    ZStack {
                        // Circle Animation Effect......
                        
                        Color.white
                            .frame(width: homeData.shoeAnimation ? 100 : getRect().width * 1.3, height: homeData.shoeAnimation ? 100 : getRect().width * 1.3)
                            .clipShape(Circle())
                            .opacity(homeData.shoeAnimation ? 1 : 0)
                        Image("s1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: "SHOE", in: animation)
                            .frame(width: 80, height: 80)
                        
                    }
                    .offset(y: homeData.saveCart ? 70 : -120)
                    .scaleEffect(homeData.saveCart ? 0.6 : 1)
                    .onAppear(perform: homeData.performingAnimation)
                    if !homeData.saveCart {
                        Spacer()
                    }
                    
                    Image(systemName: "bag\(homeData.addItemtoCart ? ".fill" : "")")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(homeData.addItemtoCart ?  Color.purple: Color("orange"))
                        .clipShape(Circle())
                        .offset(y: homeData.showBag ? -50 : 300)
                }
                //setting external view with to screen width....
                .frame(width: getRect().width)
                // moving view down.....
                .offset(y:homeData.endAnimation ? 500 : 0)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color.black.opacity(0.04).ignoresSafeArea())
        //listnening to end Animation and reverting back all.....
        .onChange(of: homeData.endAnimation, perform: { value in
            if homeData.endAnimation {
                //reset.....
                homeData.resetAll()
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct AddToCart: View {
    @EnvironmentObject var homeData: HomeViewModel
    var animation: Namespace.ID
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                if !homeData.startAnimation {
                    Image("s1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "SHOE", in: animation)
                }
                VStack(alignment:.trailing, spacing: 10){
                    Text("Air Max Exosense 'Atomic Powder'")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                    Text("$270.00")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
            .padding()
            Divider()
            Text("SELECT SIZE")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            
            // Sizes.......
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 15, content: {
                
                ForEach(sizes, id: \.self) { size in
                    Button(action: {
                        withAnimation {
                            homeData.selectedSize = size
                        }
                    }, label: {
                        Text(size)
                            .fontWeight(.semibold)
                            .foregroundColor(homeData.selectedSize == size ? .white : .black)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(homeData.selectedSize == size ? Color("orange") :Color.black.opacity(0.06))
                            .cornerRadius(10)
                    })
                }
            })
            .padding(.top)
            
            // Add to Cart Button.......
            Button(action: {
                withAnimation(.easeInOut(duration: 0.7)) {
                    homeData.startAnimation.toggle()
                }
            }, label: {
                Text("Add to cart")
                    .fontWeight(.bold)
                    .foregroundColor(homeData.selectedSize  == "" ? .black : .white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(homeData.selectedSize  == "" ? Color.black.opacity(0.06) : Color("orange"))
                    .cornerRadius(18)
            })
            .disabled(homeData.selectedSize  == "")
            .padding(.top)
        }
        .padding()
        .background(Color.white.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 35)))
    }
}


let sizes = ["EU40", "EU41", "EU42", "EU43", "EU44"]
// extending view to get screen size.....
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
