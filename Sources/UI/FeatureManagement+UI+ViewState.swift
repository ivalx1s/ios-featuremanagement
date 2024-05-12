import Foundation

extension FeatureManagement.UI {
    @MainActor
    public class ViewState: ReluxViewState {
        @Published public var enabledFeatures: [FeatureManagement.Business.Model.Feature.Key] = []
        @Published public var allFeatures: [FeatureManagement.Business.Model.Feature]

        init(featureState: FeatureManagement.Business.State, allFeatures: [FeatureManagement.Business.Model.Feature]) {
            self.allFeatures = allFeatures

            Task {
                await initPipelines(featureState: featureState)
            }
        }

        private func initPipelines(featureState: FeatureManagement.Business.State) async {
            await featureState.$enabledFeatures
                .map { $0.asArray }
                .receive(on: DispatchQueue.main)
                .assign (to: &$enabledFeatures)
        }
    }
}
