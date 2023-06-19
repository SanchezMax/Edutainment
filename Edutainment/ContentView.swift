//
//  ContentView.swift
//  Edutainment
//
//  Created by Aleksey Novikov on 19.06.2023.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}

struct ContentView: View {
    @State private var alertPresented: Bool = false
    @State private var answer: String = ""
    @State private var correctCount: Int = 0
    @State private var current: Int = -1
    @State private var isCorrect: Bool? = nil
    @State private var message: String = ""
    @State private var tables: Int = 2
    @State private var questions: [Question] = []
    @State private var questionsCount: Int = 5
    
    private let questionCounts = [5, 10, 20]
    
    var body: some View {
        NavigationView {
            List {
                Section("Settings") {
                    Stepper("Up to \(tables) multiplication tables", value: $tables, in: 2...12)
                    
                    Picker("How many questions", selection: $questionsCount) {
                        ForEach(questionCounts, id: \.self) { el in
                            Text(el.description)
                        }
                    }
                    
                    Button("Let's go!") {
                        generateQuestions()
                    }
                }
                
                if current >= 0 {
                    Section(questions[current].text) {
                        HStack {
                            TextField("Enter the answer", text: $answer)
                                .keyboardType(.numberPad)
                            if let isCorrect {
                                Image(systemName: "\(isCorrect ? "check" : "x")mark.circle.fill")
                                    .foregroundColor(isCorrect ? .green : .red)
                            }
                        }
                        Button("Check") {
                            checkAnswer()
                        }
                    }
                    
                    Section("Score (\(questionsCount - current) questions left)") {
                        Text("\(correctCount.description)/\(questionsCount.description)")
                    }
                }
            }
            .navigationTitle("Edutainment")
            .alert("Congratulations!", isPresented: $alertPresented) {
                Button("Start again", role: .destructive) {
                    newGame()
                }
                Button("Change settings", role: .cancel) {
                    resetGame()
                }
            } message: {
                Text(message)
            }
        }
    }
    
    func generateQuestions() {
        for _ in 0..<questionsCount {
            let a = Int.random(in: 1...tables)
            let b = Int.random(in: 1...tables)
            
            questions.append(
                Question(
                    text: "What is \(a) x \(b)?",
                    answer: a * b)
            )
        }
        
        withAnimation {
            current += 1
        }
    }
    
    func checkAnswer() {
        withAnimation {
            if answer == questions[current].answer.description {
                correctCount += 1
                isCorrect = true
            } else {
                isCorrect = false
            }
            
            answer = ""
            
            if questions.count == current + 1 {
                message = "Your score is \(correctCount.description) out of \(questionsCount.description). Do you want to start again or change settings?"
                alertPresented.toggle()
            } else {
                current += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isCorrect = nil
            }
        }
    }
    
    func resetGame() {
        withAnimation {
            reset()
            tables = 2
            questionsCount = 5
        }
    }
    
    func newGame() {
        withAnimation {
            reset()
            generateQuestions()
        }
    }
    
    func reset() {
        correctCount = 0
        current = -1
        questions = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
