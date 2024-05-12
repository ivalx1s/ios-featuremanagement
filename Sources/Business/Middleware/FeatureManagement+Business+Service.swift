import Foundation

public protocol IFeatureManagementService {
    func checkIsEnabled(feature: FeatureManagement.Business.Model.Feature.Key) async -> Result<Bool, FeatureManagement.Business.Err>
    func getEnabledFeatures() async -> Result<[FeatureManagement.Business.Model.Feature.Key], FeatureManagement.Business.Err>
    func addToEnabled(feature: FeatureManagement.Business.Model.Feature.Key) async -> Result<Void, FeatureManagement.Business.Err>
    func removeFromEnabled(feature: FeatureManagement.Business.Model.Feature.Key) async -> Result<Void, FeatureManagement.Business.Err>
}

extension FeatureManagement.Business {
    public actor Service {
        public typealias Err = FeatureManagement.Business.Err
        public typealias Feature = FeatureManagement.Business.Model.Feature
        private let store: IFeatureManagementStore

        public init(
            store: IFeatureManagementStore
        ) {
            self.store = store
        }
    }
}

extension FeatureManagement.Business.Service: IFeatureManagementService {
    public func checkIsEnabled(feature: Feature.Key) async -> Result<Bool, Err> {
        do {
            return await .success(
                try store
                    .readAllEnabledFeatures()
                    .contains(feature)
            )
        } catch {
            return .failure(.failedToCheckFeature(cause: error))
        }
    }

    public func getEnabledFeatures() async -> Result<[Feature.Key], Err> {
        do {
            return await .success(try store.readAllEnabledFeatures())
        } catch {
            return .failure(.failedToObtainEnabledFeatures(cause: error))
        }
    }

    public func addToEnabled(feature: Feature.Key) async -> Result<Void, Err> {
        do {
            return await .success(try store.upsert(feature: feature))
        } catch {
            return .failure(.failedToAddToEnabledFeatures(cause: error))
        }
    }

    public func removeFromEnabled(feature: Feature.Key) async -> Result<Void, Err> {
        do {
            return await .success(try store.delete(feature: feature))
        } catch {
            return .failure(.failedToRemoveFromEnabledFeatures(cause: error))
        }
    }
}
