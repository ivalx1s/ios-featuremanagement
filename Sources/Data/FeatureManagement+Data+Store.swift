import Foundation
import KeychainAccess

public protocol IFeatureManagementStore {
    func readAllEnabledFeatures() async throws -> [FeatureManagement.Business.Model.Feature.Key]
    func upsert(feature: FeatureManagement.Business.Model.Feature.Key) async throws
    func delete(feature: FeatureManagement.Business.Model.Feature.Key) async throws
}

extension Keychain {
    struct Key {
        static let enabledFeatures = "ENABLED_FEATURES"
    }
}

extension FeatureManagement.Data {
    public actor Store: IFeatureManagementStore {
        public typealias Feature = FeatureManagement.Business.Model.Feature
        private let sharedKeychain: Keychain

        public init(
            sharedKeychain: Keychain
        ) {
            self.sharedKeychain = sharedKeychain
        }
    }
}

extension FeatureManagement.Data.Store {
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
        let data = try sharedKeychain.getData(Keychain.Key.enabledFeatures)
        let features = [Feature.Key](fromJsonData: data) ?? []
        return features
    }

    private func setFeatures(new features: [Feature.Key]) throws  {
        let data = features.asJsonData ?? Data()
        try sharedKeychain.set(data, key: Keychain.Key.enabledFeatures)
    }
}
