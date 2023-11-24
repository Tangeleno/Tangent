export type TreeNode = {
    type: NodeType;
    id: string;
    name: string;
    x: number;
    y: number;
    parentId?: string | null; // ID of the parent node
    childrenIds?: string[]; // Array of IDs representing the children in order
};

type NodeInput = {
    type: string;
    required: boolean;
    description: string;
};


type NodeDetails = {
    description: string;
    inputs: NodeInput[];
    canHaveChildren: boolean;
    isDecorator: boolean
};

export enum NodeType {
    Select = 'SelectNode',
    Sequence = 'SequenceNode',
    Parallel = 'ParallelNode',
    Invert = 'InvertNode',
    Repeat = 'RepeatNode',
    Retry = 'RetryNode',
    Action = 'ActionNode',
    Wait = 'WaitNode',
    RandomSelector = 'RandomSelector',
    Failer = 'FailerNode',
    Succeeder = 'SucceederNode',
    Loop = 'LoopNode',
}

export const NodeDetails: Record<NodeType, NodeDetails> = {
    [NodeType.Select]: {
        description: 'Returns the first successful child or failure if all children fail',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Sequence]: {
        description: 'Returns success only if all children succeed in order',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Parallel]: {
        description: 'Runs all children simultaneously, returning success based on a success percentage',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'The name of the node'},
            {
                name: 'percentage',
                type: 'number',
                min: '0',
                max: '100',
                required: true,
                description: 'Percentage of nodes that need to have succeeded for this node to succeed'
            },
        ],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Invert]: {
        description: 'Inverts the result of its child',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Repeat]: {
        description: 'Repeats its child the specified number of times or until failure',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'Name of the node.'},
            {
                name: 'repeatCount',
                type: 'number',
                min: '1',
                required: true,
                description: 'Number of times to repeat the node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Retry]: {
        description: 'Retries its child the specified number of times or until success',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'Name of the node.'},
            {
                name: 'repeatCount',
                type: 'number',
                min: '1',
                required: true,
                description: 'Number of times to repeat the node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Action]: {
        description: 'The `ActionNode` is a specific node type in a Behavior Tree system. It represents an action that can be performed and encapsulates the logic required to execute it.',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'Name of the Action node.'},
            {
                name: 'actionName',
                required: true,
                type: 'string',
                description: 'Name of the action to perform.'
            },
            {
                name: 'paramKeys',
                required: false,
                type: 'string[]',
                description: 'Keys used to extract the parameters from the blackboard.'
            },
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Wait]: {
        description: 'The `WaitNode` waits for a specified amount of time or until a condition is met.',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'Name of the Wait node.'},
            {name: 'time', required: true, description: 'Time to wait in seconds.'},
            {
                name: 'condition',
                required: false,
                type: 'condition',
                description: 'Name of a condition. If true, the node will succeed before the time has elapsed.'
            },
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.RandomSelector]: {
        description: 'The `RandomSelector` randomly shuffles its children and then behaves like a regular selector, choosing the first child that succeeds.',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Failer]: {
        description: 'The `FailerNode` always returns a failure status.',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Succeeder]: {
        description: 'The `SucceederNode` always returns a success status.',
        inputs: [{name: 'name', type: 'string', required: true, description: 'The name of the node'},],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Loop]: {
        description: 'The `LoopNode` executes its child node a specified number of times.',
        inputs: [
            {name: 'name', type: 'string', required: true, description: 'Name of the Loop node.'},
            {
                name: 'loopCount', required: true,
                type: 'number',
                min: '1',
                description: 'Number of times to execute the child node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    }
} as Record<NodeType, NodeDetails>;