//
//  ContentView.swift
//  Calculator
//
//  Created by Filip Hertzman on 2023-04-17.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES

    @StateObject private var viewModel = CalculatorViewModel()

    @State private var firstValue: String = ""
    @State private var secondValue: String = ""
    @State private var showingAlert = false

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Calculator")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }

            Spacer()

            TextField("First value", text: $firstValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Second value", text: $secondValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            Picker("Operation", selection: $viewModel.operation) {
                ForEach(viewModel.displayOperations, id: \.self) {
                    Text($0)
                }
            }//: PICKER
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)

            Button {
                // Calculation and showing an alert if there is any error,
                let first = Double(firstValue)
                let second = Double(secondValue)

                if let first = first, let second = second {
                    viewModel.error = nil
                    Task {
                        await viewModel.calculate(operation: viewModel.operation, values: [first, second])
                        showingAlert = viewModel.error != nil
                    }
                } else if first == nil || second == nil {
                    viewModel.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please enter valid numbers."])
                    showingAlert = true
                }

                firstValue = ""
                secondValue = ""
            } label: { //BUTTON
                
                Text("Calculate")
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 55)
                    .background(Color.white.gradient)
                    .cornerRadius(8)
                    .padding()
            } //: BUTTON / LABEL

            Text(viewModel.result)
                .font(.title2)
                .bold()
                .padding()

            Spacer()
        } //: VSTACK
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? ""), dismissButton: .default(Text("OK")))
        }//: ALERT 
    }
}

 // MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
