//
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import SwiftUI

/// A SwiftUI wrapper for `ParticleEmitterLayerView` that displays a Core Animation particle effect.
private struct ParticleEmitterView: UIViewRepresentable {
    let type: ParticleEmitterType
    /// The point the particles are emitted from, in global coordinates.
    var origin: CGPoint?
    
    func makeUIView(context: Context) -> ParticleEmitterLayerView {
        ParticleEmitterLayerView(type: type, origin: origin)
    }
    
    /// `particleEffect` recreates the view for every change of effect instead, through its identity.
    func updateUIView(_ uiView: ParticleEmitterLayerView, context: Context) { }
}

extension View {
    /// Renders a particle effect on top of the view, pass `nil` to remove it. Snow falls from the top of the
    /// view, confetti is fired up from the origin (in global coordinates), the middle of the view by default.
    /// Changing the trigger restarts the effect, even when it is otherwise identical.
    ///
    /// Anything presented above the view covers the effect, which is what keeps out of process
    /// UI such as photo pickers interactive - the system ignores touches on content the app draws over.
    func particleEffect(_ type: ParticleEmitterType?, origin: CGPoint? = nil, trigger: some Hashable = 0) -> some View {
        overlay {
            if let type {
                ParticleEmitterView(type: type, origin: origin)
                    .id([trigger, type, origin?.x, origin?.y] as [AnyHashable])
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }
}
