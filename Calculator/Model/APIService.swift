//
//  APIService.swift
//  Calculator
//
//  Created by Filip Hertzman on 2023-04-17.
//

import Foundation


class APIService {
    // This function takes an operation and values as input and returns the result of the operation as a Double.
    func performCalculation(operation: String, values: [Double]) async throws -> Double {
        
        // Checks if the provided URL is valid, otherwise throws an error.
        guard let url = URL(string: "http://localhost:3000/calculate") else {
            print("DEBUG APIService F: Invalid URL")
            throw APIError.urlError
        }

        // Constructs the request body containing the operation and values.
        let requestBody: [String: Any] = [
            "operation": operation,
            "values": values
        ]
        print("DEBUG APIService S: Request body \(requestBody)")

        // Converts the request body to JSON data.
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)

        // Creates a URLRequest with the specified URL, method, and header.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("DEBUG APIService S: Request: \(request)")

        // Creates a URLSession with the default configuration.
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        // Performs the request and retrieves the data and URLResponse (discarded) using URLSession.
        let (data, _) = try await session.data(for: request)
       
        
        // Tries to deserialize the received data into a JSON object and extract the result.
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let result = jsonResult["result"] as? Double {
            return result
        } else {
            // If the JSON object cannot be deserialized or the result is not a Double, throws an error.
            print("DEBUG APIService F: JSON result is nil or result is not a double")
            throw APIError.jsonError
        }
    }
}
