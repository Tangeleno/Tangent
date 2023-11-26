import { defineStore } from 'pinia';
import { NodeDetails, NodeType, TreeNode } from "@/types/TreeNode.ts";
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
        generateNodeId() {
            let nodeId = `node-${this.nextNodeId.toString().padStart(3, '0')}`;
            this.nextNodeId++;
            while (this.nodes[nodeId]) {
                nodeId = `node-${this.nextNodeId.toString().padStart(3, '0')}`;
                this.nextNodeId++;
            }
            return nodeId;
        },
        selectNode(nodeId: string) {
            if (this.selectedNodeId == nodeId) {
                this.selectedNodeId = null;
            } else {
                this.selectedNodeId = nodeId;
            }

        },
        deleteSelectedNode() {
            if (this.selectedNodeId == null)
                return;

            this.deleteChildren(this.nodes[this.selectedNodeId])
            delete this.nodes[this.selectedNodeId]
            this.selectedNodeId = null
        },
        generateTreeJson() {

            function createBTNode(node: TreeNode) {
                let btNode = {
                    name: node.name,
                    id: node.id,
                    type: node.type
                } as any

                for (const inputsKey of NodeDetails[node.type].inputs) {
                    if (inputsKey.type === "string[]") {
                        btNode[inputsKey.name] = node.inputs[inputsKey.name].split(',');
                    } else {
                        btNode[inputsKey.name] = node.inputs[inputsKey.name]
                    }
                }
                return btNode
            }

            function createChildrenNodes(node: TreeNode, nodes: Record<string, TreeNode>) {
                let children = [];
                if (node.childrenIds) {
                    for (const childNodeId of node.childrenIds) {
                        let child = createBTNode(nodes[childNodeId])
                        child.children = createChildrenNodes(nodes[childNodeId], nodes);
                        children.push(child);
                    }
                }
                return children;
            }

            //identify the root node, and generate all the nodes
            //we set values to get rid of stupid typescript errors
            let rootNode = {} as any;
            for (const nodeId in this.nodes) {
                if (this.isRootNode(nodeId)) {
                    rootNode = createBTNode(this.nodes[nodeId]);
                    break;
                }
            }
            rootNode.children = createChildrenNodes(this.nodes[rootNode.id], this.nodes);
            return JSON.stringify(rootNode);
        },
        // updateNode(nodeIdToUpdate: string, node: TreeNode) {
        //     let nodeToUpdate = this.nodes[nodeIdToUpdate]
        //     for (const childId of nodeToUpdate.childrenIds) {
        //         this.nodes[childId].parentId = null
        //     }
        // },
        addNode(nodeType: NodeType) {
            let newNode = new TreeNode(nodeType, this.generateNodeId())
            newNode.name = `${nodeType}-${newNode.id}`;
            newNode.x = 0;
            newNode.y = 0;
            this.nodes[newNode.id] = newNode;
            this.applyTreeLayout(newNode.id)
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
                let currentNode = new TreeNode(node.type, node.id || store.generateNodeId());
                currentNode.name = node.name;
                //add the current node
                nodes[currentNode.id] = currentNode

                for (const inputsKey of NodeDetails[currentNode.type].inputs) {
                    if (inputsKey.type === "string[]") {
                        currentNode.inputs[inputsKey.name] = node[inputsKey.name].join(',')
                    } else {
                        currentNode.inputs[inputsKey.name] = node[inputsKey.name]
                    }
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
                // @ts-ignore: Typescript is just being silly here... I'm not 100% why I'm using it over jsdocs anymore
                layout(rootHierarchy);

                // Update our data with the layout's results
                rootHierarchy.each(d => {
                    // @ts-ignore: D3 adds 'x' and 'y' properties dynamically
                    this.nodes[d.data.id].x = d.y + baseX; // Switching x and y because we want a horizontal layout
                    // @ts-ignore: D3 adds 'x' and 'y' properties dynamically
                    this.nodes[d.data.id].y = d.x + baseY;
                });
            });

            return this.nodes;
        },
        validateTree(_newNode: Record<string, TreeNode>) {
            //TODO: This
            return true
        },
        isRootNode(nodeId: string) {
            return !(this.nodes[nodeId].parentId)
        },
        canPlaceNode(possibleParentNodeId: string, possibleChildNodeId: string) {
            let possibleParent = this.nodes[possibleParentNodeId];

            // Helper function to traverse the hierarchy upwards.
            const hasAncestor = (node: TreeNode, ancestorId: string) => {
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
        deleteChildren(node: TreeNode) {
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
