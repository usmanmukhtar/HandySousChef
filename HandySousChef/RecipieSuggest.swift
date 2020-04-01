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
        Header()
    }
}

struct RecipieSuggest_Previews: PreviewProvider {
    static var previews: some View {
        RecipieSuggest()
    }
}

struct Header: View {
    var body: some View {
        return ZStack{
                VStack {
                   HStack {
                      VStack {
                         Text("CHECK OUT THESE DELICIOUS RECIPIES!")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                      }
                   }
                    Spacer()
        //           CertificateRow()
                }
                .padding(.top, 78)
                .background(Color("theme-color"))
                .edgesIgnoringSafeArea(.all)
        }
    }
}
