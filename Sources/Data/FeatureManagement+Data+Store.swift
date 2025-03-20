import Foundation
import KeychainAccess

extension FeatureManagement.Data {
    public protocol IStore: Sendable {
        func readAllEnabledFeatures() async throws -> [FeatureManagement.Business.Model.Feature.Key]
        func replace(with features: [FeatureManagement.Business.Model.Feature.Key]) async throws
        func upsert(features: [FeatureManagement.Business.Model.Feature.Key]) async throws
        func delete(features: [FeatureManagement.Business.Model.Feature.Key]) async throws
    }
}


extension Keychain {
    struct Key {
        static let enabledFeatures = "ENABLED_FEATURES"
    }
}

extension FeatureManagement.Data {
    public actor Store {
        public typealias Feature = FeatureManagement.Business.Model.Feature
        private let keychain: Keychain

        public init(
            keychain: Keychain
        ) {
			self.keychain = keychain
        }
    }
}

extension FeatureManagement.Data.Store: FeatureManagement.Data.IStore {
    public func readAllEnabledFeatures() async throws -> [FeatureManagement.Business.Model.Feature.Key] {
        try getFeatures()
    }

    public func replace(with features: [FeatureManagement.Business.Model.Feature.Key]) async throws {
        try setFeatures(new: features.asSet.sorted())
    }

    public func upsert(features: [FeatureManagement.Business.Model.Feature.Key]) async throws {
        let storedFeatures = try getFeatures().asSet
        try setFeatures(new: storedFeatures.union(features).sorted())
    }

    public func delete(features: [FeatureManagement.Business.Model.Feature.Key]) async throws {
        let storedFeatures = try getFeatures().asSet
        try setFeatures(new: storedFeatures.subtracting(features).sorted())
    }

    private func getFeatures() throws -> [Feature.Key] {
        let data = try keychain.getData(Keychain.Key.enabledFeatures)
        let features = [Feature.Key](fromJsonData: data) ?? []
        return features
    }

    private func setFeatures(new features: [Feature.Key]) throws  {
        let data = features.asJsonData ?? Data()
        try keychain.set(data, key: Keychain.Key.enabledFeatures)
    }
}
