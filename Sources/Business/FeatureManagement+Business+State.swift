import Foundation
import SwiftPlus

extension FeatureManagement.Business {
	public actor State: Relux.State {
        @Published var enabledFeatures: MaybeData<Set<Model.Feature.Key>, Err> = .initial()

		public init() {
		}

		public func reduce(with action: Relux.Action) async {
            switch action as? Action {
                case let .some(action): await internalReduce(with: action)
                case .none: break
            }
        }

		public func cleanup() async {
            self.enabledFeatures = .initial()
        }
    }
}
