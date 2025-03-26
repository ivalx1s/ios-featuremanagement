import Foundation

extension FeatureManagement.Business.State {
    func internalReduce(with action: FeatureManagement.Business.Action) async {
        switch action {
            case let .obtainFeaturesSuccess(features):
                self.enabledFeaturesSet = .success(features.asSet)
            case let .obtainFeaturesFail(err):
                self.enabledFeaturesSet = .failure(err)

            case let .setFeaturesSuccess(features):
                self.enabledFeaturesSet = .success(features.asSet)
            case .setFeaturesFail:
                break

            case let .enableFeaturesSuccess(features):
                self.enabledFeaturesSet = .success(
                    (self.enabledFeaturesSet.value ?? [])
                        .union(features)
                )
            case .enableFeaturesFail:
                break

            case let .disableFeaturesSuccess(features):
                self.enabledFeaturesSet = .success(
                    (self.enabledFeaturesSet.value ?? [])
                        .subtracting(features)
                )
            case .disableFeaturesFail:
                break
        }
    }
}
