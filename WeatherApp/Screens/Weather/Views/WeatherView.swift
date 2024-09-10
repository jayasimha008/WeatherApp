//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import SwiftUI

struct WeatherView: View {
    
    // ViewModel responsible for fetching and managing weather data
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchText: String = ""
    @AppStorage("lastSearchCity") private var lastSearchCity: String = ""
    @StateObject private var locationViewModel = LocationViewModel()
    
    var body: some View {
        NavigationStack {  
            // List displaying weather data
            List {
                ForEach(viewModel.weathers) { weather in
                    HStack {
                        VStack {
                            // Display weather icon or a progress indicator
                            if let iconCode = weather.weather.first?.icon,
                               let iconImage = viewModel.imageCache[iconCode] {
                                Image(uiImage: iconImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }else {
                                ProgressView()
                            }
                        }
                        .frame(width: 50, height: 50)

                        VStack(alignment: .leading) {
                            // Display city name and temperature
                            if locationViewModel.cityName.lowercased() == weather.name.lowercased() {
                                Text("My Location").font(.title.bold())
                            }
                            Text(weather.name)
                            Text(weather.main.temp.formattedTemperature())
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search for a city or state")
            .onSubmit(of: .search) {
                // Trigger search on submitting the search field
                performSearch()
            }
            .navigationTitle("Weather")
            .onAppear {
                // Fetch weather data for the last searched city when the view appears
                viewModel.fetchWeather(for: lastSearchCity)
            }
            // Present an alert when there is an API response error
                        .alert(isPresented: $viewModel.isError) {
                            Alert(
                                title: Text("Error"),
                                message: Text("There is some network issue."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
        }
        
    }
        
    // Function to perform a search for weather data
    private func performSearch() {
        viewModel.fetchWeather(for: searchText)
        lastSearchCity = searchText
        searchText = ""
    }
}

#Preview {
    WeatherView()
}
