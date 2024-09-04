import Foundation

extension FeatureManagement.Business {
	public actor State: Relux.State {
        @Published var enabledFeatures: Set<Model.Feature.Key> = []
		
		public init() {

		}

		public func reduce(with action: Relux.Action) async {
            switch action as? Action {
            case let .some(action): _reduce(with: action)
            case .none: break
            }
        }

		public func cleanup() async {
            self.enabledFeatures = []
        }
    }
}
