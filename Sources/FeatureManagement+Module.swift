import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
    @MainActor
	public final class Module: Relux.Module {
        public let service: Business.IService
        public let viewState: UI.ViewState
		public let states: [Relux.State]
		public let uistates: [any Relux.Presentation.StatePresenting]
		public let routers: [any Relux.Navigation.RouterProtocol]
		public let sagas: [Relux.Saga]
        
        public init(
            store: FeatureManagement.Data.IStore,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) {
            let service = FeatureManagement.Business.Service(store: store)
            self.service = service

			let saga = FeatureManagement.Business.Saga(svc: service)
            self.sagas = [saga]

            let state = FeatureManagement.Business.State()
            self.states = [state]

            let viewState = FeatureManagement.UI.ViewState(
                featureState: state,
                allFeatures: allFeatures
            )
            self.viewState = viewState
            self.uistates = [viewState]

			self.routers = []
        }
    }
}
