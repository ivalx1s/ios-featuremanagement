import SwiftUI

extension EnvironmentValues {
    var enabledFeatures: [FeatureManagement.Business.Model.Feature.Key] {
        get { self[FeatureEnvironmentKey.self] }
        set { self[FeatureEnvironmentKey.self] = newValue }
    }
}

struct FeatureEnvironmentKey: EnvironmentKey {
    public static let defaultValue: [FeatureManagement.Business.Model.Feature.Key] = []
}
