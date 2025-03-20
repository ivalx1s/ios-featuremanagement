import Foundation
import Combine
import SwiftPlus

extension FeatureManagement.UI {

    @MainActor
    public class ViewState: Relux.Presentation.StatePresenting, ObservableObject, Sendable {
        public typealias Model = FeatureManagement.Business.Model
        public typealias Err = FeatureManagement.Business.Err

        @Published public var enabledFeatures: MaybeData<[Model.Feature.Key], Err> = .initial()
        @Published public var allFeatures: [Model.Feature]

        public init(
            featureState: FeatureManagement.Business.State,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) async {
            self.allFeatures = allFeatures
            await initPipelines(featureState: featureState)
        }

        private func initPipelines(featureState: FeatureManagement.Business.State) async {
            await featureState.$enabledFeatures
                .map(Self.map)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &$enabledFeatures)
        }

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
}

extension MaybeData<Array<FeatureManagement.Business.Model.Feature.Key>, FeatureManagement.Business.Err> {
    public func contains(_ feature: FeatureManagement.Business.Model.Feature.Key) -> Bool {
        switch self {
            case .initial: false
            case .failure: false
            case let .success(feautes): feautes.contains(feature)
        }
    }
}
