import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
    @MainActor
    public final class Module: Relux.Module {
        public let service: IFeatureManagementService
        public let viewState: FeatureManagement.UI.ViewState

        public init(
            store: IFeatureManagementStore,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) {
            let state = FeatureManagement.Business.State()

            let viewState = FeatureManagement.UI.ViewState(
                featureState: state,
                allFeatures:  allFeatures
            )
            self.viewState = viewState

            let service = FeatureManagement.Business.Service(store: store)
            self.service = service

            let saga = FeatureManagement.Business.Saga(svc: service)

            super.init(
                states: [state],
                viewStates: [viewState],
                sagas: [saga]
            )
        }
    }
}
