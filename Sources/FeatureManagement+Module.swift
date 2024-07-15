import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
	public final class Module: Relux.Module {
		
        public let service: IFeatureManagementService
		public let states: [ReluxState]
		public let viewStates: [any ReluxViewState]
		public var viewStatesObservables: [any ReluxViewStateObserving]
		public let sagas: [ReluxSaga]
        
        public init(
            store: IFeatureManagementStore,
            allFeatures: [FeatureManagement.Business.Model.Feature],
			viewStatesObservables: [any ReluxViewStateObserving] = []
        ) {
            self.service = FeatureManagement.Business.Service(store: store)
            
            let state = FeatureManagement.Business.State()
            let viewState = FeatureManagement.UI.ViewState(
                featureState: state,
                allFeatures:  allFeatures
            )
            let saga = FeatureManagement.Business.Saga(svc:service)
            
			self.states = [state]
			self.viewStates = [viewState]
			self.viewStatesObservables = viewStatesObservables
			self.sagas = [saga]
        }
    }
}
