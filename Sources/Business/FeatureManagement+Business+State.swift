import Foundation

extension FeatureManagement.Business {
    actor State: ReluxState {
        @Published var enabledFeatures: Set<Model.Feature.Key> = []

        func reduce(with action: ReluxAction) async {
            switch action as? Action {
            case let .some(action): _reduce(with: action)
            case .none: break
            }
        }

        func cleanup() async {
            self.enabledFeatures = []
        }
    }
}
