import Foundation

extension FeatureManagement.Business {
    public enum Effect: Relux.Effect {
        case obtainEnabledFeatures
        case setFeatures(features: [FeatureManagement.Business.Model.Feature.Key])
        case enableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
        case enableFeatures(features: [FeatureManagement.Business.Model.Feature.Key])
        case disableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
        case disableFeatures(features: [FeatureManagement.Business.Model.Feature.Key])
    }
}
