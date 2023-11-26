import { defineStore } from 'pinia';
import { NodeDetails, TreeNode } from "@/types/TreeNode.ts";
import { nodeStore } from "@/stores";
import { hierarchy, tree } from 'd3-hierarchy';
import { watch } from 'vue';

export const useNodeStore = defineStore({
    id: 'nodeStore',
    state: () => ({
        nodes: {} as Record<string, TreeNode>,
        selectedNodeId: null as string | null,
        nodeHeight: 100,
        nodeWidth: 150,
        horizontalNodeSpacing: 150,
        verticalNodeSpacing: -40,
        nextNodeId: 0
    }),
    getters: {
        selectedNode(state) {
            if (state.selectedNodeId == null) {
                return null;
            }
            return state.nodes[state.selectedNodeId]
        }
    },
    actions: {
        selectNode(nodeId: string) {
            if (this.selectedNodeId == nodeId) {
                this.selectedNodeId = null;
            } else {
                this.selectedNodeId = nodeId;
            }

        },
        updateNode(nodeIdToUpdate: string, node: TreeNode) {
            let nodeToUpdate = this.nodes[nodeIdToUpdate]
            for (const childId of nodeToUpdate.childrenIds) {
                this.nodes[childId].parentId = null
            }
        },
        setupLayoutWatchers() {
            // Watch for changes in nodeHeight and regenerate layout
            watch(() => this.nodeHeight, () => {
                this.applyTreeLayout();
            });

            // Watch for changes in nodeWidth and regenerate layout
            watch(() => this.nodeWidth, () => {
                this.applyTreeLayout();
            });

            // Watch for changes in horizontalNodeSpacing and regenerate layout
            watch(() => this.horizontalNodeSpacing, () => {
                this.applyTreeLayout();
            });

            // Watch for changes in verticalNodeSpacing and regenerate layout
            watch(() => this.verticalNodeSpacing, () => {
                this.applyTreeLayout();
            });
        },
        loadTree(jsonString: string) {
            //loadtree reads in the json that the lua code needs. we need to flatten it out and provide ids if they don't exist
            let nodes = {} as Record<string, TreeNode>

            function flatten(node: any, parentId: string | null, store: any) {
                //convert the current node
                let currentNode = {} as TreeNode
                currentNode.id = node.id || `Node-${store.nextNodeId++}`;

                //add the current node
                nodes[currentNode.id] = currentNode
                currentNode.name = node.name;
                currentNode.type = node.type;
                currentNode.childrenIds = [];
                currentNode.parentId = null;
                for (const inputsKey of NodeDetails[currentNode.type].inputs) {
                    currentNode[inputsKey.name] = node[inputsKey.name]
                }
                if (parentId) {
                    currentNode.parentId = parentId
                    if (nodes[parentId]) {
                        nodes[parentId].childrenIds.push(currentNode.id)
                    }
                }
                if (node.children) {
                    for (const child of node.children) {
                        flatten(child, currentNode.id, store)
                    }
                }
            }

            //convert the string to an object
            const nestedTree = JSON.parse(jsonString);

            flatten(nestedTree, null, this)
            if (!this.validateTree(nodes))
                return false;
            this.nodes = nodes
            this.applyTreeLayout();
            return true;
        },
        applyTreeLayout(rootId?: string) {
            // If rootId is provided, use it. Else, gather all nodes that don't have a parent.
            const rootNodes = rootId ? [this.nodes[rootId]] : Object.values(this.nodes).filter(node => !node.parentId);

            // Determine the starting coordinates
            const baseX = rootId ? this.nodes[rootId].x : 0;
            const baseY = rootId ? this.nodes[rootId].y : 0;

            // For each root node, generate its hierarchy and layout.
            rootNodes.forEach(rootNode => {
                const rootHierarchy = hierarchy(rootNode, d => {
                    return d.childrenIds ? d.childrenIds.map(id => this.nodes[id]) : null;
                });

                // Create a tree layout
                const layout = tree()
                    .nodeSize([this.nodeWidth + this.verticalNodeSpacing, this.nodeHeight + this.horizontalNodeSpacing])
                    .separation((a, b) => {
                        return a.parent === b.parent ? 1 : 2;
                    });

                // Apply the layout to our hierarchical data
                layout(rootHierarchy);

                // Update our data with the layout's results
                rootHierarchy.each(d => {
                    this.nodes[d.data.id].x = d.y + baseX; // Switching x and y because we want a horizontal layout
                    this.nodes[d.data.id].y = d.x + baseY;
                });
            });

            return this.nodes;
        },
        validateTree(newNode: Record<string, TreeNode>) {
            return true
        },
        isRootNode(nodeId:string) {
            return !(this.nodes[nodeId].parentId)
        },
        canPlaceNode(possibleParentNodeId:string, possibleChildNodeId:string) {
            let possibleParent = this.nodes[possibleParentNodeId];

            // Helper function to traverse the hierarchy upwards.
            const hasAncestor = (node:TreeNode, ancestorId:string) => {
                while (node && node.parentId) {
                    if (node.parentId === ancestorId) {
                        return true;
                    }
                    node = this.nodes[node.parentId];
                }
                return false;
            };

            let result = { canPlace: false, shouldConfirm: false, message: "an unknown error has occured" };

            // Check if the possibleParent has the possibleChild as an ancestor.
            const loopWouldForm = hasAncestor(possibleParent, possibleChildNodeId);

            if (loopWouldForm) {
                result.message = "Unable to place node, a loop would be formed";
                return result;
            }
            let parentNodeDetails = NodeDetails[possibleParent.type]
            if (!parentNodeDetails.canHaveChildren) {
                result.message = `Unable to place node. '${possibleParent.type}' can't have children`;
                return result;
            }
            if (parentNodeDetails.isDecorator && (possibleParent.childrenIds && possibleParent.childrenIds.length > 0)) {
                let currentChild = this.nodes[possibleParent.childrenIds[0]]
                result.canPlace = true;
                result.shouldConfirm = true;
                result.message = `Placing this node will replace the current node ${currentChild.name}`
            }
            result.canPlace = true;
            //all our checks passed, return success I guess?
            return result;
        },
        deleteChildren(node:TreeNode) {
            if (node == undefined || !node.childrenIds)
                return;
            for (const childId of node.childrenIds) {
                this.deleteChildren(this.nodes[childId])
                delete this.nodes[childId]
            }
            node.childrenIds = [];
        },
        placeNode(parentNodeId: string, childNodeId: string) {
            const nodes = this.nodes
            let parentNode = nodes[parentNodeId];
            let childNode = nodes[childNodeId];
            //Remove the child node from the old parent
            if (childNode.parentId) {
                let oldParent = nodes[childNode.parentId];
                let index = oldParent.childrenIds?.indexOf(childNode.id);
                if (index !== undefined && index !== -1) {
                    oldParent.childrenIds?.splice(index, 1);
                }
            }
            //add the child to the new parent.
            if (NodeDetails[parentNode.type].isDecorator) {
                //delete the child node and all descendants
                this.deleteChildren(parentNode)
                //Decorators can only have one child
                parentNode.childrenIds = [childNodeId];
            } else {
                if (!parentNode.childrenIds)
                    parentNode.childrenIds = [];
                parentNode.childrenIds.push(childNodeId);
            }
            childNode.parentId = parentNode.id;
            //finally reapply the tree layout for the parent node
            this.applyTreeLayout(parentNodeId)
        }
    }
});
