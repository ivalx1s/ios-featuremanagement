import Foundation

extension FeatureManagement.Business {
    public protocol IService: Sendable {
        typealias Feature = FeatureManagement.Business.Model.Feature
        typealias Err = FeatureManagement.Business.Err

        func checkIsEnabled(feature: Feature.Key) async -> Result<Bool, Err>
        func setFeatures(features: [Feature.Key]) async -> Result<Void, Err>
        func getEnabledFeatures() async -> Result<[Feature.Key], Err>
        func addToEnabled(features: [Feature.Key]) async -> Result<Void, Err>
        func removeFromEnabled(features: [Feature.Key]) async -> Result<Void, Err>
    }
}


extension FeatureManagement.Business {
    public actor Service {

        private let store: FeatureManagement.Data.IStore

        public init(
            store: FeatureManagement.Data.IStore
        ) {
            self.store = store
        }
    }
}

extension FeatureManagement.Business.Service: FeatureManagement.Business.IService {
    public func setFeatures(features: [Feature.Key]) async -> Result<Void, Err> {
        do {
            return await .success(try store.replace(with: features))
        } catch {
            return .failure(.failedToReplaceFeatures(cause: error))
        }
    }

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

    public func addToEnabled(features: [Feature.Key]) async -> Result<Void, Err> {
        do {
            return await .success(try store.upsert(features: features))
        } catch {
            return .failure(.failedToAddToEnabledFeatures(cause: error))
        }
    }

    public func removeFromEnabled(features: [Feature.Key]) async -> Result<Void, Err> {
        do {
            return await .success(try store.delete(features: features))
        } catch {
            return .failure(.failedToRemoveFromEnabledFeatures(cause: error))
        }
    }
}
