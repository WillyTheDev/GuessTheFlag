//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by William on 21.04.21.
//

import SwiftUI

struct ContentView: View {
    
   
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    
    @State private var playerScore: Int = 0
    
    @State private var rotationDegrees: Angle = Angle(degrees: 0)
    @State private var showRotation: Bool = true
    @State private var wrongFlagOpacity: Double = 1
    
    func askQuestions(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        rotationDegrees = Angle(degrees: 0)
        wrongFlagOpacity = 1
        showRotation = false
    }
    
    func flagTapped(_ number: Int){
        showRotation = true
        withAnimation(.default){
            wrongFlagOpacity = 0.25
            rotationDegrees = Angle(degrees: 180)
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            scoreTitle = "Wrong"
            playerScore -= 1
        }
        showingScore = true
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        VStack(spacing: 30){
            VStack{
                Text("Tap the flag of")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Text(countries[correctAnswer])
                    .foregroundColor(.white)
                    .fontWeight(.black)
            }
            ForEach(0 ..< 3) { number in
                Button(action: {
                    flagTapped(number)
                }) {
                    Image(countries[number])
                        .renderingMode(.original)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 3))
                        .shadow(color: .black, radius: 3)
                        .opacity(number != correctAnswer ? wrongFlagOpacity: 1)
                        .rotation3DEffect( number == correctAnswer ?
                            rotationDegrees : Angle(degrees: 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0))
                        
                        
                        
                }
                
                
            }
            Spacer()
            Text("Your score : \(playerScore)").foregroundColor(.white).fontWeight(.bold)
            Spacer()
        }
        
        }.alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(playerScore)"), dismissButton: .default(Text("Continue")){
                askQuestions()
            })
        })
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
