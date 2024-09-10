//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import XCTest
@testable import WeatherApp

final class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel!
    private var mockService =  MockService()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel(manager: mockService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchWeatherCityData() async throws {
        viewModel.fetchWeather(for: "Kitchener")
        // Wait for a reasonable amount of time for asynchronous updates to complete
        let expectation = XCTestExpectation(description: "Waiting for weather data")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled or timeout after 10 seconds
        await fulfillment(of: [expectation], timeout: 2.0)

        // Check the results after waiting
        XCTAssertFalse(viewModel.weathers.isEmpty, "Weather data should not be empty")
        XCTAssertTrue(viewModel.weathers.count == 1)
        guard let iconName = viewModel.weathers.first?.weather.first?.icon else {
            XCTFail("Icon name is not found")
            return
        }
        XCTAssertNotNil(viewModel.imageCache[iconName])
    }

}

class MockService: APIManagerService, Mockable {
    func request<T>(type: EndPointType) async throws -> T where T : Decodable {
        if T.self == Data.self {
            // Return Image Data
            return UIImage(named: "02d")?.pngData() as! T
        }else {
            // Return city response
            return self.loadJson(fileName: "weather", decodeType: T.self)
        }
    }
}
