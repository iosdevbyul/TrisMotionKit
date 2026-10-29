import CoreMotion
import Foundation

public struct PedometerMeasurement: Sendable, Equatable {
    public let startDate: Date
    public let endDate: Date
    public let steps: Int
    public let distanceMeters: Double?

    public init(startDate: Date, endDate: Date, steps: Int, distanceMeters: Double?) {
        self.startDate = startDate
        self.endDate = endDate
        self.steps = steps
        self.distanceMeters = distanceMeters
    }
}

public protocol PedometerServing: Sendable {
    func steps(from startDate: Date, to endDate: Date) async throws -> PedometerMeasurement?
    func prepareAuthorization() async throws
}

public enum PedometerServiceError: Error, Sendable {
    case unavailable
    case invalidDateRange
}

public final class PedometerService: PedometerServing, @unchecked Sendable {
    private let pedometer: CMPedometer

    public init() {
        self.pedometer = CMPedometer()
    }

    /// Trigger the iOS Motion & Fitness permission flow before an exercise starts.
    /// Permission is managed by iOS, so this query is intentionally separate
    /// from measurements recorded for a workout.
    public func prepareAuthorization() async throws {
        guard CMPedometer.isStepCountingAvailable() else {
            throw PedometerServiceError.unavailable
        }
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-60)
        _ = try await steps(from: startDate, to: endDate)
    }

    public func steps(from startDate: Date, to endDate: Date) async throws -> PedometerMeasurement? {
        guard endDate > startDate else { throw PedometerServiceError.invalidDateRange }
        guard CMPedometer.isStepCountingAvailable() else { throw PedometerServiceError.unavailable }
        return try await withCheckedThrowingContinuation { continuation in
            pedometer.queryPedometerData(from: startDate, to: endDate) { data, error in
                if let error { continuation.resume(throwing: error); return }
                guard let data else { continuation.resume(returning: nil); return }
                continuation.resume(returning: PedometerMeasurement(
                    startDate: data.startDate,
                    endDate: data.endDate,
                    steps: data.numberOfSteps.intValue,
                    distanceMeters: data.distance?.doubleValue
                ))
            }
        }
    }
}
