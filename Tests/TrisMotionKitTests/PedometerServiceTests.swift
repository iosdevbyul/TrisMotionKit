import XCTest
@testable import TrisMotionKit

final class PedometerServiceTests: XCTestCase {
    func testMeasurementPreservesSourceInterval() {
        let start = Date(timeIntervalSince1970: 100)
        let end = Date(timeIntervalSince1970: 200)
        let sample = PedometerMeasurement(startDate: start, endDate: end, steps: 123, distanceMeters: 90)
        XCTAssertEqual(sample.steps, 123)
        XCTAssertEqual(sample.startDate, start)
        XCTAssertEqual(sample.endDate, end)
        XCTAssertEqual(sample.distanceMeters, 90)
    }

    func testInvalidRangeIsRejectedBeforeSensorAccess() async {
        let now = Date()
        do {
            _ = try await PedometerService().steps(from: now, to: now)
            XCTFail("Expected invalid range")
        } catch PedometerServiceError.invalidDateRange {
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
