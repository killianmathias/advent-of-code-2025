//
//  Part2View.swift
//  day-11
//
//  Created by Killian Mathias on 30/12/2025.
//


import SwiftUI

// Part 2 View that contain a button that show the result after calculation

struct Part2View : View{
    @StateObject private var viewModel = Part2ViewModel()
    var body : some View{
        VStack{
            Text("Day 11 of Advent of Code 2025")
                .font(.largeTitle.bold())
            Text("Part 2")
                .font(.title2)
            Spacer()
            if viewModel.result == 0 {
                Button("Calculer Résultat"){
                    viewModel.openFile()
                }
            }else{
                Text("Résultat : \(viewModel.result)")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.green)
            }
        }
    }
}

struct Part2Preview: PreviewProvider {
    static var previews: some View {
        Part2View()
    }
}
