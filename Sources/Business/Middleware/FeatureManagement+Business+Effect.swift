import Foundation

extension FeatureManagement.Business {
    public enum Effect: ReluxEffect {
        case obtainEnabledFeatures
        case enableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
        case disableFeature(feature: FeatureManagement.Business.Model.Feature.Key)
    }
}
