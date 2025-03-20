import Foundation

extension FeatureManagement.Business {
    public enum Action: Relux.Action {
        case obtainFeaturesSuccess(features: [Model.Feature.Key])
        case obtainFeaturesFail(err: Err)

        case setFeaturesSuccess(features: [Model.Feature.Key])
        case setFeaturesFail(err: Err)

        case enableFeaturesSuccess(features: [Model.Feature.Key])
        case enableFeaturesFail(err: Err)

        case disableFeaturesSuccess(features: [Model.Feature.Key])
        case disableFeaturesFail(err: Err)
    }
}
