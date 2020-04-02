//
//  ArticleView.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 01/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import SwiftUI

struct ArticleView: View {
    var certificates = certificateData
    
    var body: some View {
        VStack(alignment: .leading) {
           Text("Certificates")
              .font(.system(size: 20))
              .fontWeight(.heavy)
              .padding(.leading, 30)

           ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 20) {
                 ForEach(certificates) { item in
                    CertificateView(item: item)
                 }
              }
              .padding(20)
              .padding(.leading, 10)
           }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView()
    }
}

struct Certificate: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var width: Int
   var height: Int
}

let certificateData = [
   Certificate(title: "UI Design", image: "Certificate1", width: 230, height: 150),
   Certificate(title: "SwiftUI", image: "Certificate2", width: 230, height: 150),
   Certificate(title: "Sketch", image: "Certificate3", width: 230, height: 150),
   Certificate(title: "Framer", image: "Certificate4", width: 230, height: 150)
]

struct CertificateView: View {

   var item = Certificate(title: "UI Design", image: "Certificate1", width: 340, height: 220)

   var body: some View {
      return VStack {
         HStack {
            VStack(alignment: .leading) {
               Text(item.title)
                  .font(.headline)
                  .fontWeight(.bold)
                  .foregroundColor(Color("accent"))
                  .padding(.top)

               Text("Certificate")
                  .foregroundColor(.white)
            }
            Spacer()

            Image("Logo")
               .resizable()
               .frame(width: 30, height: 30)
         }
         .padding(.horizontal)
         Spacer()

         Image(item.image)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .offset(y: 50)
      }
      .frame(width: CGFloat(item.width), height: CGFloat(item.height))
      .background(Color.black)
      .cornerRadius(10)
      .shadow(radius: 10)
   }
}
