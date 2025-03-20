import Foundation

extension FeatureManagement.Business {
    public enum Err: Error {
        case notImplemented
        case failedToReplaceFeatures(cause: Error)
        case failedToCheckFeature(cause: Error)
        case failedToObtainEnabledFeatures(cause: Error)
        case failedToAddToEnabledFeatures(cause: Error)
        case failedToRemoveFromEnabledFeatures(cause: Error)
    }
}

extension FeatureManagement.Business.Err: Identifiable {
    public var id: String {
        switch self {
            case .notImplemented: "notImplemented"
            case let .failedToReplaceFeatures(cause): "failedToReplaceFeatures-\(cause.localizedDescription)"
            case let .failedToCheckFeature(cause): "failedToCheckFeature-\(cause.localizedDescription)"
            case let .failedToObtainEnabledFeatures(cause): "failedToObtainEnabledFeatures-\(cause.localizedDescription)"
            case let .failedToAddToEnabledFeatures(cause): "failedToAddToEnabledFeatures-\(cause.localizedDescription)"
            case let .failedToRemoveFromEnabledFeatures(cause): "failedToRemoveFromEnabledFeatures-\(cause.localizedDescription)"
        }
    }
}
extension FeatureManagement.Business.Err: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
