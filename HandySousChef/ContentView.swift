//
//  ContentView.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 30/03/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            MealSelect()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Home: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }.padding(.top, 100)
            VStack{
                Text("Select Your Meal").font(.largeTitle).fontWeight(.bold).foregroundColor(Color("primary-color"))
                HStack{
                    
                    Spacer()
                }
            }
            
            
        Spacer()
        }.edgesIgnoringSafeArea(.top)
            .background(Color("bg-color").edgesIgnoringSafeArea(.all))
    }
}

