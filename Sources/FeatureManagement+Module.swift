import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
    @MainActor
    public final class Module: Relux.Module {
        public let store: IFeatureManagementStore
        public let service: IFeatureManagementService
        
        public init(
            sharedKeychain: Keychain,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) {
            self.store = FeatureManagement.Data.Store(sharedKeychain: sharedKeychain)
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
