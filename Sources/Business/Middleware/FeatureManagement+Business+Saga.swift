import Foundation


extension FeatureManagement.Business {
	public protocol ISaga: Relux.Saga {}
}
	
extension FeatureManagement.Business {
    public actor Saga {
        private let svc: IService

        public init(
            svc: IService
        ) {
            self.svc = svc
        }
    }
}

extension FeatureManagement.Business.Saga: FeatureManagement.Business.ISaga {
    public func apply(_ effect: Relux.Effect) async {
        switch effect as? FeatureManagement.Business.Effect {
        case .none: break
        case .obtainEnabledFeatures: await obtainEnabledFeatures()
        case let .enableFeature(feature): await enableFeature(feature)
        case let .disableFeature(feature): await disableFeature(feature)
        }
    }
}

extension FeatureManagement.Business.Saga {
    private func obtainEnabledFeatures() async {
        switch await svc.getEnabledFeatures() {
        case let .success(features):
            await action {
                FeatureManagement.Business.Action.obtainFeaturesSuccess(features: features)
            }
        case .failure:
            await actions {
                FeatureManagement.Business.Action.obtainFeaturesFail
            }
        }
    }

    private func enableFeature(_ feature: FeatureManagement.Business.Model.Feature.Key) async {
        switch await svc.addToEnabled(feature: feature) {
        case .success:
            await action {
                FeatureManagement.Business.Action.enableFeatureSuccess(feature: feature)
            }
        case .failure:
            await actions {
                FeatureManagement.Business.Action.enableFeatureFail(feature: feature)
            }
        }
    }

    private func disableFeature(_ feature: FeatureManagement.Business.Model.Feature.Key) async {
        switch await svc.removeFromEnabled(feature: feature) {
        case .success:
            await action {
                FeatureManagement.Business.Action.disableFeatureSuccess(feature: feature)
            }
        case .failure:
            await actions {
                FeatureManagement.Business.Action.disableFeatureFail(feature: feature)
            }
        }
    }
}
