import Foundation

extension FeatureManagement.Business.Model {
    public indirect enum FeatureComposite {
        case allSatisfy(_ composites: [FeatureComposite])
        case anySatisfy(_ composites: [FeatureComposite])
        case not(_ composite: FeatureComposite)
        case feature(_ feature: Feature.Key)
        case condition(@Sendable () -> Bool)
        case value(Bool)
    }
}

extension FeatureManagement.Business.Model.FeatureComposite {
    public func check(against features: [FeatureManagement.Business.Model.Feature.Key]) -> Bool {
        Self.check(self, against: features)
    }

    public static func check(_ composite: Self, against features: [FeatureManagement.Business.Model.Feature.Key]) -> Bool {
        switch composite {
            case let .feature(item):
                features.contains(item)
            case let .condition(c):
                c()
            case let .value(flag):
                flag
            case let .not(composite):
                check(composite, against: features).not
            case let .allSatisfy(composites):
                composites.allSatisfy { Self.check($0, against: features) }
            case let.anySatisfy(composites):
                composites.contains { Self.check($0, against: features) }
        }
    }
}

extension FeatureManagement.Business.Model.Feature.Key: Sendable {}

extension FeatureManagement.Business.Model {
    public struct Feature: Sendable {
        public typealias Key = String
        public let key: Key
        public let label: String
        
        public init(
            key: String,
            label: String
        ) {
            self.key = key
            self.label = label
        }
    }
}

extension FeatureManagement.Business.Model.Feature: Codable {}

extension FeatureManagement.Business.Model.Feature: Identifiable {
    public var id: String { self.key }
}

extension FeatureManagement.Business.Model.Feature: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}

extension FeatureManagement.Business.Model.Feature: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
}

extension FeatureManagement.Business.Model.Feature: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.label < rhs.label
    }
}

extension FeatureManagement.Business.Model.FeatureComposite: Sendable {}
