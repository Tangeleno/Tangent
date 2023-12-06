import { defineStore } from 'pinia';
import { NodeDetails, NodeType, TreeNode } from "@/types/TreeNode.ts";
import { hierarchy, tree } from 'd3-hierarchy';
import { watch } from 'vue';

const subTrees = {
    "Target": '{"id":"node-000","type":"SelectNode","inputs":{"name":"Target"},"children":[{"id":"node-001","type":"ConditionNode","inputs":{"name":"Have Target","conditionKey":"haveCorrectTarget","paramKeys":["targetId"]},"children":[]},{"id":"node-002","type":"SequenceNode","inputs":{"name":"Get Target"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Target Is Valid","conditionKey":"isValidTarget","paramKeys":["targetId","spawnType"]},"children":[]},{"id":"node-004","type":"TargetNode","inputs":{"name":"Target","targetIdKey":"targetId","targetTypeKey":"spawnType"},"children":[]}]}]}',
    "MemSpell": '{"id":"node-000","type":"SelectNode","inputs":{"name":"Root"},"children":[{"id":"node-001","type":"SequenceNode","inputs":{"name":"Start Mem"},"children":[{"id":"node-002","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-003","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]}]},{"id":"node-004","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-005","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-006","type":"MemorizeSpellNode","inputs":{"name":"Memorize Spell","spellGemKey":"spellGem","spellIdKey":"spellId"},"children":[]},{"id":"node-007","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]},{"id":"node-008","type":"SequenceNode","inputs":{"name":"WaitingForMem"},"children":[{"id":"node-009","type":"ConditionNode","inputs":{"name":"Memorizing","conditionKey":"spellMemorizing","paramKeys":[]},"children":[]},{"id":"node-010","type":"InvertNode","inputs":{"name":"Not"},"children":[{"id":"node-011","type":"ConditionNode","inputs":{"name":"Memorized","conditionKey":"spellMemorized","paramKeys":["spellId"]},"children":[]}]},{"id":"node-012","type":"WaitNode","inputs":{"name":"Wait","time":0.1,"paramKeys":[]},"children":[]}]}]}'
} as Record<string, string>


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
        },
        subTrees() {
            return Object.keys(subTrees);
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
            let nodeToDelete = this.nodes[this.selectedNodeId];

            //Delete children
            this.deleteChildren(nodeToDelete);

            //Update the parent to remove this node
            if (nodeToDelete.parentId) {
                const index = this.nodes[nodeToDelete.parentId].childrenIds.indexOf(nodeToDelete.id);
                if (index > -1) {
                    this.nodes[nodeToDelete.parentId].childrenIds.splice(index, 1);
                }
            }

            //delete this node
            delete this.nodes[this.selectedNodeId]
            this.selectedNodeId = null
        },
        generateTreeJson() {
            function createBTNode(node: TreeNode) {
                let btNode = {
                    id: node.id,
                    type: node.type,
                    inputs:{}
                } as any

                for (const inputsKey of NodeDetails[node.type].inputs) {
                    if (inputsKey.type === "string[]") {
                        if (node.inputs[inputsKey.name]) {
                            if(typeof node.inputs[inputsKey.name] === "string") {
                                btNode.inputs[inputsKey.name] = node.inputs[inputsKey.name].split(',');
                            } else if (Array.isArray(node.inputs[inputsKey.name])) {
                                btNode.inputs[inputsKey.name] = node.inputs[inputsKey.name]
                            }
                        } else {
                            btNode.inputs[inputsKey.name] = [];
                        }

                    } else {
                        btNode.inputs[inputsKey.name] = node.inputs[inputsKey.name]
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
        loadSubtree(treeName: string) {
            if (subTrees.hasOwnProperty(treeName))
                this.loadTree(subTrees[treeName]);
        },
        addNode(nodeType: NodeType) {
            let newNode = new TreeNode(nodeType, this.generateNodeId())
            newNode.inputs.name = `${nodeType}-${newNode.id}`;
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
                let currentNode = new TreeNode(node.type, store.generateNodeId());
                // currentNode.inputs.name = node.name;
                //add the current node
                nodes[currentNode.id] = currentNode

                for (const inputsKey of NodeDetails[currentNode.type].inputs) {
                    if (inputsKey.type === "string[]") {
                        if (node.inputs[inputsKey.name])
                            currentNode.inputs[inputsKey.name] = node.inputs[inputsKey.name].join(',')
                        else
                            currentNode.inputs[inputsKey.name] = ""
                    } else {
                        currentNode.inputs[inputsKey.name] = node.inputs[inputsKey.name]
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
            for (const node in nodes) {
                this.nodes[nodes[node].id] = nodes[node];
            }
            this.applyTreeLayout();
            return true;
        },
        applyTreeLayout(rootId?: string) {
            // If rootId is provided, use it. Else, gather all nodes that don't have a parent.
            const rootNodes = rootId ? [this.nodes[rootId]] : Object.values(this.nodes).filter(node => !node.parentId);
            const proxyRoot = rootNodes.length > 1 ? this.generateNodeId() : null;
            let rootNode = null as TreeNode | null;
            if (proxyRoot) {
                this.nodes[proxyRoot] = new TreeNode(NodeType.Select, proxyRoot);
                this.nodes[proxyRoot].childrenIds = rootNodes.map(node => node.id);
                rootNode = this.nodes[proxyRoot];
            } else {
                rootNode = rootNodes[0];
            }
            // Determine the starting coordinates
            const baseX = rootId ? this.nodes[rootId].x : 0;
            const baseY = rootId ? this.nodes[rootId].y : 0;
            // For each root node, generate its hierarchy and layout.

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
            if (proxyRoot) {
                delete this.nodes[proxyRoot];
            }
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
                result.message = `Placing this node will replace the current node ${currentChild.inputs.name}`
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
