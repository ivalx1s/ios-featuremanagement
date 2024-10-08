import Foundation
import KeychainAccess

extension FeatureManagement.Data {
    public protocol IStore: Sendable {
        func readAllEnabledFeatures() async throws -> [FeatureManagement.Business.Model.Feature.Key]
        func upsert(feature: FeatureManagement.Business.Model.Feature.Key) async throws
        func delete(feature: FeatureManagement.Business.Model.Feature.Key) async throws
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

    public func upsert(feature: FeatureManagement.Business.Model.Feature.Key) async throws {
        var features = try getFeatures().asSet
        features.update(with: feature)
        try setFeatures(new: features.asArray.sorted())
    }

    public func delete(feature: FeatureManagement.Business.Model.Feature.Key) async throws {
        var features = try getFeatures().asSet
        features.remove(feature)
        try setFeatures(new: features.asArray.sorted())
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
