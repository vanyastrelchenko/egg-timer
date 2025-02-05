//
//  ContentView.swift
//  Correct Egg tiemr
//
//  Created by Ivan Strelchenko on 2025-01-28.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var timer: Timer?
    @State private var title = "How you want to cook your eggs?"
    @State private var downloadAmount = 0.0
    @State private var secondsRemaining = 0.0
    @State private var timeToReady = 0.0
    @State private var audioPlayer: AVAudioPlayer?
    
    
    var body: some View {
        
        VStack(spacing: 75){

            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(#colorLiteral(red: 0.5769984126, green: 0.5176859498, blue: 0.3547230959, alpha: 0.2102131623)))
                    .frame(width: 350, height: 100)
                Text("\(title)")
                    .font(.title3).bold()
                    .foregroundColor(Color.white)
            }
            .padding()
            .padding(.top, 100)
            
            HStack {
                
                Spacer()
                
                Button(){
                    startedEggTimer(for: "Soft", duration: 420.0)
                } label: {
                    EggButtonView(imageName: "soft_egg", label: "Soft", time: 7)
                }
                
                Spacer()
                
                Button(){
                    startedEggTimer(for: "Medium", duration: 540.0)
                } label: {
                    EggButtonView(imageName: "medium_egg", label: "Medium", time: 9)
                }
                
                Spacer()
                
                Button(){
                    startedEggTimer(for: "Hard", duration: 720.0)
                } label: {
                    EggButtonView(imageName: "hard_egg", label: "Hard", time: 12)
                }
                
                Spacer()

            }
            .padding()
            
            HStack {
                ProgressView(value: downloadAmount, total: timeToReady)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }
            Spacer()
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.black, .brown, .gray]).opacity(0.7))
    }
    
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print( "Error playing sound: (error.localizedDescription)")
            }
        }
    }
    
    func startedEggTimer(for hardness: String, duration: Double) {
        
        downloadAmount = 0.0
        secondsRemaining = duration
        timeToReady = duration
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
                downloadAmount += 1
                title = ("\(hardness) egg:  \(Int(secondsRemaining)/60):\(Int(secondsRemaining)%60)  remaining")
            } else {
                timer?.invalidate()
                title = "DONE"
                playSound()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    title = "How you want to cook your eggs?"
                }
            }
        }
    }
}

struct EggButtonView: View {
    let imageName: String
    let label: String
    let time: Int
    
    var body: some View {
        VStack{
            Image("\(imageName)")
                .resizable()
                .frame(width: 100, height: 130, alignment: .center)
                .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), radius: 10, x: 0.0, y: 10)
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.5077709556, green: 0.2494014502, blue: 0, alpha: 0.9)))
                        .frame(width: 35, height: 35)
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 0.0, y: 10)
                        .overlay {
                            Text("\(time)")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .opacity(0.9)
                        }
                }
            
            Text(label)
                .font(.title2)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    ContentView()
}
