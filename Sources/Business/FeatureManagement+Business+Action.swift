import Foundation

extension FeatureManagement.Business {
    enum Action: Relux.Action {
        case obtainFeaturesSuccess(features: [Model.Feature.Key])
        case obtainFeaturesFail

        case enableFeatureSuccess(feature: Model.Feature.Key)
        case enableFeatureFail(feature: Model.Feature.Key)

        case disableFeatureSuccess(feature: Model.Feature.Key)
        case disableFeatureFail(feature: Model.Feature.Key)
    }
}
