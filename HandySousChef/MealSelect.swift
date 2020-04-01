//
//  MealSelect.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 30/03/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import SwiftUI

struct MealSelect: View {
    
    var meals = mealData
    @State var showContent = false
//    @State var offset: CGFloat = 70.0
    @State var currentPageIndex = 0
    
    var body: some View {
        ZStack{
            VStack {
               HStack {
                  VStack(alignment: .leading) {
                     Text("Select Your Meal")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                  }
                  Spacer()
               }
               .padding(.leading, 60.0)
                Spacer()
    //           CertificateRow()
            }
            .padding(.top, 78)
            .background(Color("theme-color"))
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 10.0) {
//                GeometryReader { geometry -> Text in
//                    let newOffset = geometry.frame(in: .global).minX
//                    if self.offset != newOffset {
//                        self.offset = newOffset
//                    }
//                    print("Offset: \(self.offset)")
//                    return Text("")
//                }.frame(width: 0.0)
                ForEach(self.meals) { item in
                     Button(action: { self.showContent.toggle() }) {
                        GeometryReader { geometry in
                           MealView(title: item.title,
                                      subTitle: item.subTitle,
                                      image: item.image,
                                      color: item.color,
                                      shadowColor: item.shadowColor)
                              .rotation3DEffect(Angle(degrees:
                                 Double(geometry.frame(in: .global).minX - 100) / -10), axis: (x: 0, y: 10.0, z: 0))
//                              .sheet(isPresented: self.$showContent) { ContentView() }
                        }
                        .frame(width: 246, height: 360)
                         //360
                     }
                  }
               }
               .padding(.leading, 70)
               .padding(.top, 30)
               .padding(.bottom, 70)
            }
            
            VStack(alignment: .trailing){
                Spacer()
                HStack{
                    PageControl(numberOfPages: 3, currentPageIndex: $currentPageIndex).padding(.leading, 30)
                    
                    Spacer()
//                    Button(action: { }){
                    NavigationLink (destination: RecipieSuggest()){
                        HStack(spacing: 20){
                            Text("Next")
                                .font(.title)
                                .fontWeight(.regular)
                                .frame(width: 60, alignment: .trailing)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30.0))
                            
                        }
                        
                    }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("primary-color"))
                }
                
            }
            
            
        }
    }
}

struct MealSelect_Previews: PreviewProvider {
    static var previews: some View {
        MealSelect()
    }
}

struct MealView: View {

    var title = "Build an app with SwiftUI"
    var subTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    var image = "Illustration1"
    var color = Color("background3")
    var shadowColor = Color("backgroundShadow3")

   var body: some View {
      return VStack() {
         Image(image)
             .resizable()
             .renderingMode(.original)
             .aspectRatio(contentMode: .fit)
             .frame(width: 246, height: 150)
             .padding(.top, 30)
             .shadow(color: Color("buttonShadow"), radius: 10, x: -5, y: 5)
        
        Spacer()
        
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color("primary-color"))
            .padding(.bottom, 30)
        
        Text(subTitle)
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(Color("primary-color"))
            .padding(.bottom, 30)

         
      }
      .background(color)
      .cornerRadius(30)
      .frame(width: 246, height: 360)
      .shadow(color: shadowColor, radius: 20, x: 0, y: 20)
   }
}

struct Meal: Identifiable {
    var id = UUID()
    var title: String
    var subTitle: String
    var image: String
    var color: Color
    var shadowColor: Color
}


let mealData = [
    Meal(
        title: "Breakfast",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "meal-3",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
    Meal(
        title: "Lunch",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "meal-2",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
    Meal(
        title: "Dinner",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "meal-1",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
]
