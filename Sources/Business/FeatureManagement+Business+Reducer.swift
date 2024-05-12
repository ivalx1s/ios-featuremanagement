import Foundation

extension FeatureManagement.Business.State {
    func _reduce(with action: FeatureManagement.Business.Action) {
        switch action {
        case let .obtainFeaturesSuccess(features):
            self.enabledFeatures = features.asSet
        case .obtainFeaturesFail:
            self.enabledFeatures = []

        case let .enableFeatureSuccess(feature),
             let .enableFeatureFail(feature):
            self.enabledFeatures.update(with: feature)

        case let .disableFeatureSuccess(feature),
             let .disableFeatureFail(feature):
            self.enabledFeatures.remove(feature)
        }
    }
}