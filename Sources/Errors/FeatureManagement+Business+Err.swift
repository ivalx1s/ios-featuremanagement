import Foundation

extension FeatureManagement.Business {
    public enum Err: Error {
        case notImplemented
        case failedToCheckFeature(cause: Error)
        case failedToObtainEnabledFeatures(cause: Error)
        case failedToAddToEnabledFeatures(cause: Error)
        case failedToRemoveFromEnabledFeatures(cause: Error)
    }
}