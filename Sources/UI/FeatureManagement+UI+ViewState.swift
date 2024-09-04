import Foundation
import Combine

extension FeatureManagement.UI {

	@MainActor
	public class ViewState: Relux.Presentation.StatePresenting, ObservableObject, Sendable {
		
        @Published public var enabledFeatures: [FeatureManagement.Business.Model.Feature.Key] = []
        @Published public var allFeatures: [FeatureManagement.Business.Model.Feature]

        public init(featureState: FeatureManagement.Business.State, allFeatures: [FeatureManagement.Business.Model.Feature]) {
            self.allFeatures = allFeatures

            Task {
                await initPipelines(featureState: featureState)
            }
        }

        private func initPipelines(featureState: FeatureManagement.Business.State) async {
            await featureState.$enabledFeatures
				.asyncMap { $0.asArray }
				.receive(on: DispatchQueue.main)
                .assign (to: &$enabledFeatures)
        }
    }
}
