# TrisMotionKit

Reusable Core Motion Swift Package for iOS 17+.

`PedometerService` queries interval-based step counts and distance from Core Motion without depending on WakTrainer or HealthKit.

Consuming apps declare `NSMotionUsageDescription`. Raw Core Motion and HealthKit observations should be persisted independently; never add their step counts together.

## Usage

Add `https://github.com/iosdevbyul/TrisMotionKit` as a Swift package dependency and import `TrisMotionKit`.
