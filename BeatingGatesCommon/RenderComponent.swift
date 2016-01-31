/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `GKComponent` that provides an `SKNode` for an entity. This enables it to be represented in the SpriteKit world. The node is provided as an `EntityNode` instance, so that the entity can be discovered from the node.
*/

import SpriteKit
import GameplayKit

public class RenderComponent: GKComponent {
    // MARK: Properties
    
    // The `RenderComponent` vends a node allowing an entity to be rendered in a scene.
    public let node = EntityNode()
    
    public init(entity: GKEntity) {
        node.entity = entity
    }
}
