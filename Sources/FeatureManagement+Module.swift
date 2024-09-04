import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
	
	public final class Module: Relux.Module {
        public let service: IFeatureManagementService
		public let states: [Relux.State]
		public let uistates: [any Relux.Presentation.StatePresenting]
		public let routers: [any Relux.Navigation.RouterProtocol]
		public let sagas: [Relux.Saga]
        
        public init(
			sagas: [any IFeatureManagementSaga],
			serviceFacade: any IFeatureManagementService,
			states: [any Relux.State],
			uistates: [any Relux.Presentation.StatePresenting],
			store: IFeatureManagementStore
        ) {
			let saga = FeatureManagement.Business.Saga(svc: serviceFacade)
            self.service = FeatureManagement.Business.Service(store: store)
			self.states = states
			self.uistates = uistates
			self.routers = []
			self.sagas = [saga]
        }
    }
}
