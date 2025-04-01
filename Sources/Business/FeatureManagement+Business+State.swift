import Foundation
import SwiftPlus

extension FeatureManagement.Business {
    public class State: Relux.HybridState, ObservableObject {
        public typealias Model = FeatureManagement.Business.Model
        public typealias Err = FeatureManagement.Business.Err

        @Published var enabledFeaturesSet: MaybeData<Set<Model.Feature.Key>, Err> = .initial()
        @Published public var enabledFeatures: MaybeData<[Model.Feature.Key], Err> = .initial()
        @Published public var allFeatures: [Model.Feature]

		public init(
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) {
            self.allFeatures = allFeatures
            initPipelines()
		}

		public func reduce(with action: Relux.Action) async {
            switch action as? Action {
                case let .some(action): await internalReduce(with: action)
                case .none: break
            }
        }

		public func cleanup() async {
            self.enabledFeaturesSet = .initial()
        }
        
        public func check(expression: FeatureManagement.Business.Model.FeatureComposite) -> Bool {
            guard let value = enabledFeatures.value else { return false }
            return expression.check(against: value)
        }
    }
}

extension FeatureManagement.Business.State {
    private func initPipelines() {
        $enabledFeaturesSet
            .map(Self.map)
           // .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$enabledFeatures)
    }
}

extension FeatureManagement.Business.State {
    nonisolated
    private static func map(
        result: MaybeData<Set<Model.Feature.Key>, Err>
    ) -> MaybeData<[Model.Feature.Key], Err> {
        switch result {
            case let .initial(stub): .initial(stub?.sorted())
            case let .success(set): .success(set.sorted())
            case let .failure(err): .failure(err)
        }
    }
}

extension MaybeData<Array<FeatureManagement.Business.Model.Feature.Key>, FeatureManagement.Business.Err> {
    public func contains(_ feature: FeatureManagement.Business.Model.Feature.Key) -> Bool {
        switch self {
            case .initial: false
            case .failure: false
            case let .success(features): features.contains(feature)
        }
    }
}
