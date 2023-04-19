//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Filip Hertzman on 2023-04-17.
//

import Foundation

// MainActor used to indicate that this class should be executed on the main thread
@MainActor
class CalculatorViewModel: ObservableObject {
    // store the result of a calculation.
    @Published var result: String = ""
    // to store the current operation.
    @Published var operation: String = "addition"
    //Use the error in our view
    @Published var error: Error?
    // instance of `APIService` which will be used to make API calls to a remote server.
    private var apiService = APIService()

    // What we display in our view 
    let displayOperations: [String] = ["Addition", "Subtraction", "Division", "Multiplication", "Root", "Percent", "Pythagoras", "Area of Circle", "Volume of Cylinder"]

    // asynchronous function which takes two parameters: `operation` and `values`.
    func calculate(operation: String, values: [Double]) async {
        // converts the `operation` string to lowercase and replaces any spaces with underscores.
        let serverOperation = operation.lowercased().replacingOccurrences(of: " ", with: "_")
        do {
            // This makes an API call to the server using the `apiService` instance to perform the calculation.
            let value = try await apiService.performCalculation(operation: serverOperation, values: values)
            // This updates the `result` property with the result of the calculation.
            result = "\(value)"
        } catch let error {
            // set the error
            self.error = error
        }
       
    }
}
