import Foundation

extension FeatureManagement.Business.State {
    func internalReduce(with action: FeatureManagement.Business.Action) async {
        switch action {
            case let .obtainFeaturesSuccess(features):
                self.enabledFeatures = .success(features.asSet)
            case let .obtainFeaturesFail(err):
                self.enabledFeatures = .failure(err)

            case let .setFeaturesSuccess(features):
                self.enabledFeatures = .success(features.asSet)
            case .setFeaturesFail:
                break

            case let .enableFeaturesSuccess(features):
                self.enabledFeatures = .success(
                    (self.enabledFeatures.value ?? [])
                        .union(features)
                )
            case .enableFeaturesFail:
                break

            case let .disableFeaturesSuccess(features):
                self.enabledFeatures = .success(
                    (self.enabledFeatures.value ?? [])
                        .subtracting(features)
                )
            case .disableFeaturesFail:
                break
        }
    }
}
