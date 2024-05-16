import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
    @MainActor
    public final class Module: Relux.Module {
        public let service: IFeatureManagementService
        
        public init(
            store: IFeatureManagementStore,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) {
            self.service = FeatureManagement.Business.Service(store: store)
            
            let state = FeatureManagement.Business.State()
            let viewState = FeatureManagement.UI.ViewState(
                featureState: state,
                allFeatures:  allFeatures
            )

            let saga = FeatureManagement.Business.Saga(svc:service)
            
            super.init(
                states: [state],
                viewStates: [viewState],
                sagas: [saga]
            )
        }
    }
}
