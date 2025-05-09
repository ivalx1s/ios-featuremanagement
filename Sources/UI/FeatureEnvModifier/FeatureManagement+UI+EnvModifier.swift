import SwiftUI

extension FeatureManagement.UI {
    struct EnvModifier: ViewModifier {
        @ObservedObject private var featureState: FeatureManagement.Business.State

        init(featureState: FeatureManagement.Business.State) {
			self.featureState = featureState
		}

        func body(content : Content) -> some View {
            content
                .environment(\.enabledFeatures, featureState.enabledFeatures.value ?? [])
        }
    }
}

extension View {
    public func bindEnabledFeatures(featureState: FeatureManagement.Business.State) -> some View {
        self
			.modifier(FeatureManagement.UI.EnvModifier(featureState: featureState))
    }
}

extension FeatureManagement.UI {
    struct FeaturePresentationModifier: ViewModifier {
        @Environment(\.enabledFeatures) private var features
        let expression: FeatureManagement.Business.Model.FeatureComposite

        func body(content : Content) -> some View {
            if expression.check(against: features) {
                content
            }
        }
    }

    struct FeaturePresentationConditionalModifier<ElseView: View>: ViewModifier {
        @Environment(\.enabledFeatures) private var features

        let expression: FeatureManagement.Business.Model.FeatureComposite
        @ViewBuilder let elseView: ElseView

        func body(content : Content) -> some View {
            switch expression.check(against: features) {
                case true: content
                case false: elseView
            }
        }
    }
}

public extension View {
    func presentIf(
        _ expression: FeatureManagement.Business.Model.FeatureComposite,
        @ViewBuilder elseView: ()-> some View
    ) -> some View {
        self
            .modifier(FeatureManagement.UI.FeaturePresentationConditionalModifier(
                expression: expression,
                elseView: elseView
            ))
    }

    func presentIf(
        _ expression: FeatureManagement.Business.Model.FeatureComposite
    ) -> some View {
        self
            .modifier(FeatureManagement.UI.FeaturePresentationModifier(
                expression: expression
            ))
    }
}
