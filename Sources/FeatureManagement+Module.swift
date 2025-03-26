import Foundation
import Relux
import KeychainAccess

extension FeatureManagement {
    @MainActor
	public final class Module: Relux.Module {
        public let store: FeatureManagement.Data.IStore
        public let service: Business.IService
        public let state: Business.State
        public let states: [Relux.AnyState]
		public let sagas: [Relux.Saga]
        
        public init(
            store: FeatureManagement.Data.IStore,
            allFeatures: [FeatureManagement.Business.Model.Feature]
        ) async {
            self.store = store

            let service = FeatureManagement.Business.Service(store: store)
            self.service = service

			let saga = FeatureManagement.Business.Saga(svc: service)
            self.sagas = [saga]

            let state = FeatureManagement.Business.State(allFeatures: allFeatures)
            self.state = state
            self.states = [state]
        }
    }
}
