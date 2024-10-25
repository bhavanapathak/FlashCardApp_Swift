//
//  WelcomeFlashcardView.swift
//  FlashCard
//
//  Created by RPS on 20/10/24.
//



import SwiftUI

struct WelcomeFlashcardView: View {
    @State private var isFlipped = false // State to track if the card is flipped
    @State private var flipRotation: Double = 0 // Track the flip rotation
    
    var body: some View {
        NavigationView { // Ensure the entire view is wrapped in NavigationView
            VStack {
                Text("Welcome to FlashCard App!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 0.447, blue: 0.745)) // Brighter calming blue
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // Flippable flashcard
                ZStack {
                    if isFlipped {
                        BackCardView()
                    } else {
                        FrontCardView()
                    }
                }
                .frame(width: 300, height: 300) // Increased height for a fuller look
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .rotation3DEffect(
                    Angle(degrees: flipRotation),
                    axis: (x: 0, y: 1, z: 0)
                )
                .onTapGesture {
                    flipCard()
                }
                Spacer()
                Text("Explore, learn, and conquer new horizons!")
                    .font(.title2) // Increased font size
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.0, green: 0.5, blue: 1.0)) // Bright and calming blue
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true) // Ensure text fits within the view
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.850, green: 0.976, blue: 1.0), Color(red: 0.6, green: 0.847, blue: 0.956)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    // Function to flip the card
    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.6)) {
            flipRotation += 180
            isFlipped.toggle()
        }
    }
}

// Front side of the card (Journey text with Logo)
struct FrontCardView: View {
    var body: some View {
        VStack {
            Text("Your journey to knowledge starts here!")
                .font(.title) // Increased font size
                .foregroundColor(Color(red: 0.0, green: 0.447, blue: 0.745)) // Brighter calming blue
                .multilineTextAlignment(.center)
                .padding()
                .lineLimit(2)
                .minimumScaleFactor(0.5) // Adjust font size to fit
            
            Spacer()
            
            // Logo Image
            Image("LogoImage") // Replace "logoImageName" with your actual logo asset name
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100) // Adjust size as needed
                .padding(.bottom, 10)
            
        }
        .padding()
    }
}

// Back side of the card (Ready to Start button)
struct BackCardView: View {
    var body: some View {
        VStack {
            Text("Ready to Start?")
                .font(.title) // Increased font size
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.0, green: 0.447, blue: 0.745)) // Brighter calming blue
                .padding(.bottom, 20)
            
            NavigationLink(destination: ContentView()) { // Ensure the NavigationLink is present here
                Text("Let's Learn")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.5, blue: 1.0)) // Bright button color
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            Text("Embark on your learning adventure!")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.white) // Card background color
        .cornerRadius(20)
        .shadow(radius: 10)
        .rotation3DEffect(
            Angle(degrees: 180), // Ensure the rotation is set to 0 for the back side
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

struct WelcomeFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeFlashcardView()
        }
    }
}


