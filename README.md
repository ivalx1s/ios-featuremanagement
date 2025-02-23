# ios-featuremanagement

* add dependency to project
* connect to relux via Relux.register(FeatureManagement.module())
* configure in project
* * add your specific feature such as
extension FeatureManagement.Business.Model {
    enum MyAppFeature: FeatureManagement.Business.Model.Feature.Key {
        case debugMenu = "debugMenu"
        case feature1 = "feature1"
    }
}

extension FeatureManagement.Business.Model.MyAppFeature: CaseIterable {}

extension FeatureManagement.Business.Model.MyAppFeature: RawRepresentable {}

extension FeatureManagement.Business.Model.MyAppFeature: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}

extension FeatureManagement.Business.Model.MyAppFeature: Codable {}

extension FeatureManagement.Business.Model.MyAppFeature: Identifiable {
    var id: FeatureManagement.Business.Model.Feature.Key { rawValue }
}

** add extensions for FeatureManagement.ViewState for your app features specifics
extension FeatureManagement.UI.ViewState {
    var allMembraneFeatures: [FeatureManagement.Business.Model.MyAppFeature] {
        self.allFeatures
            .compactMap { FeatureManagement.Business.Model.MyAppFeature(rawValue: $0.key) }
    }

    func check(expression: FeatureManagement.Business.Model.FeatureComposite) -> Bool {
        expression.check(against: enabledFeatures)
    }
}


extension Sequence where Element == FeatureManagement.Business.Model.Feature.Key {
    var asMyAppFeatures: [FeatureManagement.Business.Model.MembraneFeature] {
        self.compactMap { .init(rawValue: $0) }
    }
}

** specify exact feature composite for feature expressions

extension FeatureManagement.Business.Model.FeatureComposite {
    static func exactFeature(_ feature: FeatureManagement.Business.Model.MyAppFeature) -> Self {
        .feature(feature: feature.rawValue)
    }
}

* propogate features to root view
** connect envObject to view
      @EnvironmentObject private var featuresState: FeatureManagement.UI.ViewState
** add feature propogating modifier to view
  .bindEnabledFeatures(featureState: featuresState)

* how to use on view
Group {
      divider
      Relux.NavigationLink(page: .membraneApp(page: .account(page: .debugMenu))) {
          CustomMenuItem(model: SettingPage.debug.model)
      }
  }
      .presentIf(
        .anySatisfy(composites: [
          .exactFeature(.debugMenu),
          .condition({ DeviceEnv.isSimulator })
        ])
      )
           
