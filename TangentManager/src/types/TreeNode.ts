export class TreeNode {
    type: NodeType;
    id: string;
    x: number;
    y: number;
    parentId: string | null;
    inputs: Record<string, any>;
    childrenIds: string[];

    constructor(type: NodeType, id: string) {
        this.type = type;
        this.id = id;
        this.x = 0;
        this.y = 0;
        this.parentId = null;
        this.childrenIds = [];
        this.inputs = {}
    }

    // Additional methods or properties can be added here
}

type NodeInput = {
    type: string;
    required: boolean;
    description: string;
    name: string,
    default: any,
    display: string,
    min?: number,
    max?: number,
};


type NodeDetails = {
    category:NodeCategory
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
    Wait = 'WaitNode',
    RandomSelector = 'RandomSelector',
    Failer = 'FailerNode',
    Succeeder = 'SucceederNode',
    Loop = 'LoopNode',
    Condition = 'ConditionNode',
    Memorize= 'MemorizeSpellNode',
    Sit = 'SitNode',
    Target = 'TargetNode',
    MoveTo = "MoveToNode"
}

export enum Actions {
    NoOp = "NoOp",
}

export enum NodeCategory {
    Composite = 'Composite',
    Decorator = 'Decorator',
    Action = 'Action',
    Leaf = "Leaf"
}

export enum Conditions {
    AlwaysFalse   = "AlwaysFalse",
    standing   = "standing",
    isValidTarget   = "isValidTarget",
    haveCorrectTarget   = "haveCorrectTarget",
    spellMemorized   = "spellMemorized",
    spellMemorizing   = "spellMemorizing"
}

export const NodeDetails: Record<NodeType, NodeDetails> = {
    [NodeType.Select]: {
        category: NodeCategory.Composite,
        description: 'Returns the first successful child or failure if all children fail',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Sequence]: {
        category: NodeCategory.Composite,
        description: 'Returns success only if all children succeed in order',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Parallel]: {
        category: NodeCategory.Composite,
        description: 'Runs all children simultaneously, returning success based on a success percentage',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },
            {
                name: 'percentage',
                type: 'number',
                default: 50,
                display: 'Percentage',
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
        category: NodeCategory.Decorator,
        description: 'Inverts the result of its child',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Repeat]: {
        category: NodeCategory.Decorator,
        description: 'Repeats its child the specified number of times or until failure',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            {
                name: 'repeatCount',
                type: 'number',
                default: 1,
                display: 'Times',
                min: '1',
                required: true,
                description: 'Number of times to repeat the node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Retry]: {
        category: NodeCategory.Decorator,
        description: 'Retries its child the specified number of times or until success',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            {
                name: 'repeatCount',
                type: 'number',
                default: 1,
                display: 'Times',
                min: '1',
                required: true,
                description: 'Number of times to repeat the node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Wait]: {
        category: NodeCategory.Leaf,
        description: 'The `WaitNode` waits for a specified amount of time or until a condition is met.',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            { name: 'time', display: 'Wait Seconds', type: 'number', required: true, description: 'Time to wait in seconds.' },
            {
                name: 'breakConditionKey',
                display: 'Condition',
                required: false,
                type: 'condition',
                default: 'false',
                description: 'Name of a condition.'
            },
            {
                name: 'invertCondition',
                display: 'Invert Condition Result',
                required: true,
                type: 'bool',
                default: false,
                description: 'Should the result of the condition be flipped (true->false false->true).'
            },
            {
                name: 'paramKeys',
                required: false,
                display: 'Parameters',
                type: 'string[]',
                description: 'Keys used to extract the parameters from the blackboard.'
            }
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Condition]: {
        category: NodeCategory.Leaf,
        description: 'The `ConditionNode` checks the specified condition, returning successfully if the condition is true, else failure',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            {
                name: 'conditionKey',
                display: 'Condition',
                required: false,
                type: 'condition',
                default: 'false',
                description: 'Name of a condition.'
            },
            {
                name: 'paramKeys',
                required: false,
                display: 'Parameters',
                type: 'string[]',
                description: 'Keys used to extract the parameters from the blackboard.'
            }
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.RandomSelector]: {
        category: NodeCategory.Composite,
        description: 'The `RandomSelector` randomly shuffles its children and then behaves like a regular selector, choosing the first child that succeeds.',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: true,
        isDecorator: false
    },
    [NodeType.Failer]: {
        category: NodeCategory.Leaf,
        description: 'The `FailerNode` always returns a failure status.',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Succeeder]: {
        category: NodeCategory.Leaf,
        description: 'The `SucceederNode` always returns a success status.',
        inputs: [{ name: 'name', display: 'Name', type: 'string', required: true, description: 'The name of the node' },],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Loop]: {
        category: NodeCategory.Decorator,
        description: 'The `LoopNode` executes its child node a specified number of times.',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            {
                name: 'loopCount', required: true,
                type: 'number',
                default: 1,
                display: 'Count',
                min: '1',
                description: 'Number of times to execute the child node.'
            },
        ],
        canHaveChildren: true,
        isDecorator: true
    },
    [NodeType.Memorize]: {
        category: NodeCategory.Action,
        description: 'The `MemorizeSpellNode` memorizes a spell from the character\'s spellbook into a specific gem slot.',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the node.' },
            { name: 'spellGemKey', display: 'Spell Gem Key', type: 'string', required: true, description: 'Key to extract the spell gem slot from the blackboard.' },
            { name: 'spellIdKey', display: 'Spell ID Key', type: 'string', required: true, description: 'Key to extract the spell ID from the blackboard.' },
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Sit]: {
        category: NodeCategory.Action,
        description: 'The `SitNode` represents an action where the character attempts to sit and returns success when sitting or failure after a specified number of attempts.',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the SitAction node.' },
            { name: 'maxSitAttempts', display: 'Max Sit Attempts', type: 'number', required: true, description: 'The number of attempts that should be made before returning failure.' },
        ],
        canHaveChildren: false,
        isDecorator: false
    },
    [NodeType.Target]: {
        category: NodeCategory.Action,
        description: 'The `TargetNode` represents an action where the character attempts to target a specific entity and returns success when successfully targeted or failure if the target is invalid or not reached within a specified time.',
        inputs: [
            { name: 'name', display: 'Name', type: 'string', required: true, description: 'Name of the TargetAction node.' },
            { name: 'targetIdKey', display: 'Target ID Key', type: 'string', required: true, description: 'Key to extract the target ID from the blackboard.' },
            { name: 'targetTypeKey', display: 'Target Type Key', type: 'string', required: false, description: 'Key to extract the target type from the blackboard (optional).' },
        ],
        canHaveChildren: false,
        isDecorator: false
    }
    
} as Record<NodeType, NodeDetails>;