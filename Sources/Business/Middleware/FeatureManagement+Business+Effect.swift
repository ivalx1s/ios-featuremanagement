import Foundation

extension FeatureManagement.Business {
    public enum Effect: Relux.Effect {
        case obtainEnabledFeatures
        case enableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
        case disableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
    }
}
