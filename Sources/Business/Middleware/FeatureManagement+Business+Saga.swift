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
            case let .setFeatures(features): await setFeatures(features)
            case let .enableFeature(feature): await enableFeatures([feature])
            case let .disableFeature(feature): await disableFeatures([feature])
            case let .enableFeatures(features): await enableFeatures(features)
            case let .disableFeatures(features): await disableFeatures(features)
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
            case let .failure(err):
                await actions {
                    FeatureManagement.Business.Action.obtainFeaturesFail(err: err)
                }
        }
    }

    private func setFeatures(_ features: [FeatureManagement.Business.Model.Feature.Key]) async {
        switch await svc.setFeatures(features: features) {
            case .success:
                await action {
                    FeatureManagement.Business.Action.setFeaturesSuccess(features: features)
                }
            case let .failure(err):
                await actions {
                    FeatureManagement.Business.Action.setFeaturesFail(err: err)
                }
        }
    }

    private func enableFeatures(_ features: [FeatureManagement.Business.Model.Feature.Key]) async {
        switch await svc.addToEnabled(features: features) {
            case .success:
                await action {
                    FeatureManagement.Business.Action.enableFeaturesSuccess(features: features)
                }
            case let .failure(err):
                await actions {
                    FeatureManagement.Business.Action.enableFeaturesFail(err: err)
                }
        }
    }

    private func disableFeatures(_ features: [FeatureManagement.Business.Model.Feature.Key]) async {
        switch await svc.removeFromEnabled(features: features) {
            case .success:
                await action {
                    FeatureManagement.Business.Action.disableFeaturesSuccess(features: features)
                }
            case let .failure(err):
                await actions {
                    FeatureManagement.Business.Action.disableFeaturesFail(err: err)
                }
        }
    }
}
