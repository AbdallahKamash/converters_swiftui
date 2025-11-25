//
//  ContentView.swift
//  converters
//
//  Created by Abdallah Kamash on 25/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Conversion Types
    enum ConversionType: String, CaseIterable {
        case length = "Length"
        case temperature = "Temperature"
        case volume = "Volume"
        case time = "Time"
    }
    
    // MARK: - Units
    let lengthUnits = ["Meters", "Kilometers", "Feet", "Yards", "Miles"]
    let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    let volumeUnits = ["Milliliters", "Liters", "Cups", "Pints", "Gallons"]
    let timeUnits = ["Seconds", "Minutes", "Hours", "Days"]
    
    // MARK: - User Input
    @State private var conversionType: ConversionType = .length
    @State private var inputValue = ""
    @State private var inputUnit = ""
    @State private var outputUnit = ""
    
    // MARK: - Computed Units Array
    var units: [String] {
        switch conversionType {
        case .length: return lengthUnits
        case .temperature: return temperatureUnits
        case .volume: return volumeUnits
        case .time: return timeUnits
        }
    }
    
    // MARK: - Conversion Logic
    func convert(value: Double) -> Double {
        switch conversionType {
        case .length:
            return convertLength(value: value)
        case .temperature:
            return convertTemperature(value: value)
        case .volume:
            return convertVolume(value: value)
        case .time:
            return convertTime(value: value)
        }
    }
    
    // MARK: - Length Conversion
    func convertLength(value: Double) -> Double {
        // Convert input to meters
        let valueInMeters: Double
        switch inputUnit {
        case "Meters": valueInMeters = value
        case "Kilometers": valueInMeters = value * 1000
        case "Feet": valueInMeters = value * 0.3048
        case "Yards": valueInMeters = value * 0.9144
        case "Miles": valueInMeters = value * 1609.34
        default: valueInMeters = value
        }
        // Convert meters to output unit
        switch outputUnit {
        case "Meters": return valueInMeters
        case "Kilometers": return valueInMeters / 1000
        case "Feet": return valueInMeters / 0.3048
        case "Yards": return valueInMeters / 0.9144
        case "Miles": return valueInMeters / 1609.34
        default: return valueInMeters
        }
    }
    
    // MARK: - Temperature Conversion
    func convertTemperature(value: Double) -> Double {
        var valueInCelsius: Double
        switch inputUnit {
        case "Celsius": valueInCelsius = value
        case "Fahrenheit": valueInCelsius = (value - 32) * 5/9
        case "Kelvin": valueInCelsius = value - 273.15
        default: valueInCelsius = value
        }
        switch outputUnit {
        case "Celsius": return valueInCelsius
        case "Fahrenheit": return valueInCelsius * 9/5 + 32
        case "Kelvin": return valueInCelsius + 273.15
        default: return valueInCelsius
        }
    }
    
    // MARK: - Volume Conversion
    func convertVolume(value: Double) -> Double {
        // Convert input to milliliters
        let valueInML: Double
        switch inputUnit {
        case "Milliliters": valueInML = value
        case "Liters": valueInML = value * 1000
        case "Cups": valueInML = value * 240
        case "Pints": valueInML = value * 473.176
        case "Gallons": valueInML = value * 3785.41
        default: valueInML = value
        }
        // Convert milliliters to output
        switch outputUnit {
        case "Milliliters": return valueInML
        case "Liters": return valueInML / 1000
        case "Cups": return valueInML / 240
        case "Pints": return valueInML / 473.176
        case "Gallons": return valueInML / 3785.41
        default: return valueInML
        }
    }
    
    // MARK: - Time Conversion
    func convertTime(value: Double) -> Double {
        // Convert input to seconds
        let valueInSeconds: Double
        switch inputUnit {
        case "Seconds": valueInSeconds = value
        case "Minutes": valueInSeconds = value * 60
        case "Hours": valueInSeconds = value * 3600
        case "Days": valueInSeconds = value * 86400
        default: valueInSeconds = value
        }
        // Convert seconds to output
        switch outputUnit {
        case "Seconds": return valueInSeconds
        case "Minutes": return valueInSeconds / 60
        case "Hours": return valueInSeconds / 3600
        case "Days": return valueInSeconds / 86400
        default: return valueInSeconds
        }
    }
    
    // MARK: - Computed Result
    var result: Double {
        let value = Double(inputValue) ?? 0
        return convert(value: value)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Conversion Type")) {
                    Picker("Select Type", selection: $conversionType) {
                        ForEach(ConversionType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: conversionType) { _, _ in
                        // Reset units when type changes
                        inputUnit = units.first ?? ""
                        outputUnit = units.last ?? ""
                        inputValue = ""
                    }
                }
                
                Section(header: Text("Input")) {
                    TextField("Enter value", text: $inputValue)
                        .keyboardType(.decimalPad)
                    
                    Picker("From Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                }
                
                Section(header: Text("Output")) {
                    Picker("To Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    Text(result.formatted())
                        .font(.largeTitle)
                        .bold()
                }
            }
            .navigationTitle("Unit Converter")
            .onAppear {
                // Initialize units
                inputUnit = units.first ?? ""
                outputUnit = units.last ?? ""
            }
        }.safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                Text("Project 2 - Abdallah Kamash")
            }
            .foregroundColor(.secondary)
            .ignoresSafeArea(.all, edges: .bottom) // Extends background to the edge
        }
    }
}

#Preview {
    ContentView()
}
