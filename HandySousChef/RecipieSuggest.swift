//
//  RecipieSuggest.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 01/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import SwiftUI

struct RecipieSuggest: View {
    
    
    var body: some View {
        
        ScrollView {
           VStack {
            ForEach((1...2).reversed(), id: \.self) {_ in
                    RecipeRow()
                }
           }
           .padding(.top, 78)
        }
    }
}

struct RecipieSuggest_Previews: PreviewProvider {
    static var previews: some View {
        RecipieSuggest()
    }
}

struct RecipeRow: View {
    var videos = videoData
    
    var body: some View {
        return VStack {
            HStack {
                 VStack(alignment: .leading) {
                    Text("Videos")
                 }
                 Spacer()
              }
              .padding(.leading)

              ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 30.0) {
                    ForEach(videos) { item in
                       Button(action: { }) {
                          GeometryReader { geometry in
                             RecipeView(title: item.title,
                                        image: item.image,
                                        color: item.color,
                                        shadowColor: item.shadowColor)
    //                                .sheet(isPresented: self.$showContent) { ContentView() }
                          }
                          .frame(width: 246, height: 360)
                       }
                    }
                 }
                 .padding(.leading)
                 .padding(.bottom, 70)
                 Spacer()
              }
        }
    }
}

struct RecipeView: View {

   var title = "Build an app with SwiftUI"
   var image = "Illustration1"
   var color = Color("background3")
   var shadowColor = Color("backgroundShadow3")

   var body: some View {
      return ZStack(alignment: .leading) {
         Image(image)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 246, height: 360)
            .overlay(Color.black.opacity(0.4))
//            .background(Image("thumb-1").resizable().renderingMode(.original))
            
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(30)
            .lineLimit(4)
      }
      .cornerRadius(30)
      .frame(width: 246, height: 360)
      .shadow(color: shadowColor, radius: 20, x: 0, y: 20)
   }
}

struct Video: Identifiable {
    var id = UUID()
    var title: String
    var subTitle: String
    var image: String
    var color: Color
    var shadowColor: Color
}


let videoData = [
    Video(
        title: "Breakfast",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "thumb-1",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
    Video(
        title: "Lunch",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "thumb-2",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
    Video(
        title: "Dinner",
        subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        image: "thumb-2",
        color: Color("card-color"),
        shadowColor: Color("card-shadow-color")
    ),
]
