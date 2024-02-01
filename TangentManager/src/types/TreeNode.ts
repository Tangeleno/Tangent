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

    
}
type NodeDetails = {
    category: NodeCategory
    description: string;
    inputs: NodeInput[];
    canHaveChildren: boolean;
    isDecorator: boolean
};
type NodeInput = {
    name: string;
    display?: string;
    type: string;
    min?:number,
    max?:number,
    description: string;
    optional?: boolean
};

export enum NodeType {
    CastSpell = "CastSpellNode",
    Sequence = "SequenceNode",
    Parallel = "ParallelNode",
    Select = "SelectNode",
    RandomSelector = "RandomSelectorNode",
    Invert = "InvertNode",
    Loop = "LoopNode",
    Repeat = "RepeatNode",
    Retry = "RetryNode",
    Ability = "AbilityNode",
    Face = "FaceNode",
    Attack = "AttackNode",
    MemorizeSpell = "MemorizeSpellNode",
    MoveTo = "MoveToNode",
    Sit = "SitNode",
    Target = "TargetNode",
    Condition = "ConditionNode",
    Failer = "FailerNode",
    Succeeder = "SucceederNode",
    Wait = "WaitNode",
}

export enum NodeCategory {
    Composite = 'Composite',
    Action = 'Action',
    Decorator = 'Decorator',
    Other = 'Other'
}

export enum Conditions {
    AlwaysFalse = "AlwaysFalse",
    standing = "standing",
    isValidTarget = "isValidTarget",
    haveCorrectTarget = "haveCorrectTarget",
    spellMemorized = "spellMemorized",
    spellMemorizing = "spellMemorizing"
}

const castSpellNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The CastSpellNode is a specialized type of Node designed for casting spells, disciplines, items, and alternate abilities within a behavior tree.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
        },
        {
            name: 'targetIdKey',
            display: "Target Id Key",
            type: 'string',
            description: 'Key to extract the target ID (number|string) from the blackboard.',
        },
        {
            name: 'targetTypeKey',
            display: "Target Type Key",
            type: 'string',
            description: 'Key to extract the target type (string) from the blackboard.',
        },
        {
            name: 'spellIdKey',
            display: "Spell Id Key",
            type: 'string',
            description: 'Key to extract the spell ID (number|string) from the blackboard.',
        },
        {
            name: 'spellKey',
            display: "Spell Key",
            type: 'string',
            description: 'Key to extra the actual Spell(userdata) from Keys are expected to exist in the blackboard.Spells table.',
        },
        {
            name: 'spellTypeKey',
            display: "Spell Type Key",
            type: 'string',
            description: 'Key to extract the spell type (string, e.g., "Item", "AA", "Gem", "Disc") from the blackboard.',
        },
        {
            name: 'spellType',
            display: "Spell Type",
            type: 'string',
            description: 'The spell type ("Item", "AA", "Gem", "Disc")',
        },
        {
            name: 'spellResultKey',
            display: "Spell Result Key",
            type: 'string',
            description: 'Key to place the result of the spell (string, e.g., "Success", "Interrupt", "Fizzle", "Immune", etc) in the blackboard.',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const sequenceNodeDetails: NodeDetails = {
    category: NodeCategory.Composite,  
    description: 'The SequenceNode is a type of CompositeNode that processes its child nodes in order and succeeds only if all its children succeed. The node will return the first failure encountered, or success if all children succeed.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
        },
    ],
    canHaveChildren: true,  
    isDecorator: false,  
};
const parallelNodeDetails: NodeDetails = {
    category: NodeCategory.Composite,  
    description: 'The ParallelNode is a type of CompositeNode that executes its child nodes in \'parallel\', evaluating their collective results based on a specified success percentage.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
        },
        {
            name: 'percentage',
            display: "Percentage",
            type: 'number',
            min:0,
            max:100,
            description: 'The percentage of child nodes that need to succeed for this node to report success.',
        },
        {
            name: 'breakOnThreshold',
            display: "Break on threshold",
            type: 'string',
            description: '(Optional) Determines the condition under which to terminate early. Can be "No", "SuccessOnly", "FailureOnly", or "Any".',
        },
    ],
    canHaveChildren: true,  
    isDecorator: false,  
};
const selectNodeDetails: NodeDetails = {
    category: NodeCategory.Composite,  
    description: 'The SelectNode is a type of CompositeNode that iterates through its children, returning the state of the first child that does not fail. It effectively selects the first successful path or action to take.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
        },
    ],
    canHaveChildren: true,  
    isDecorator: false,  
};
const randomSelectorNodeDetails: NodeDetails = {
    category: NodeCategory.Composite,  
    description: 'The RandomSelector is a specialized type of SelectNode that shuffles its children and then proceeds like a regular SelectNode. It randomly picks one of the child nodes to execute first, providing a way to add variety or unpredictability to the behavior tree.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
        },
    ],
    canHaveChildren: true,  
    isDecorator: false,  
};
const invertNodeDetails: NodeDetails = {
    category: NodeCategory.Decorator,  
    description: 'The InvertNode is a type of DecoratorNode that inverts the result of its child node. It\'s used to reverse the success or failure of the child node\'s outcome.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the Invert node.',
        },
    ],
    canHaveChildren: true,  
    isDecorator: true,  
};
const loopNodeDetails: NodeDetails = {
    category: NodeCategory.Decorator,  
    description: 'The LoopNode is a type of DecoratorNode designed to repeatedly execute its child node a specified number of times or until a condition is met.',
    inputs: [
        {
            name: 'name',
            display: "Name",
            type: 'string',
            description: 'The name of the Invert node.',
        },
        {
            name: 'loopCount',
            type: 'number',
            description: 'The number of times to execute the child node.',
            display: 'Loop Count',
        },
        {
            name: 'conditionKey',
            type: 'string',
            description: '(Optional) A key to a condition function in the conditions table. This function should return a boolean value. If the function returns false, the loop will terminate early.',
            display: 'Condition Key',
        },
    ],
    canHaveChildren: true,  
    isDecorator: true,  
};
const repeatNodeDetails: NodeDetails = {
    category: NodeCategory.Decorator,  
    description: 'The RepeatNode is a type of DecoratorNode that repeats its child node a specified number of times or until the child node fails. It\'s useful for tasks that need to be attempted multiple times.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
            display: 'Name',
        },
        {
            name: 'repeatCount',
            type: 'number',
            description: 'The number of times to repeat the child node. If not specified, it defaults to 1.',
            display: 'Repeat Count',
        },
    ],
    canHaveChildren: true,  
    isDecorator: true,  
};
const retryNodeDetails: NodeDetails = {
    category: NodeCategory.Decorator,  
    description: 'The RetryNode is a type of DecoratorNode that retries its child node a specified number of times or until the child node succeeds. This node is used when an action might fail initially but could succeed upon subsequent attempts.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the node, used for identification and debugging.',
            display: 'Name',
        },
        {
            name: 'repeatCount',
            type: 'number',
            description: 'The number of times to retry the child node. If not specified, it defaults to 1.',
            display: 'Repeat Count',
        },
    ],
    canHaveChildren: true,  
    isDecorator: true,  
};
const abilityNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The AbilityNode is a specialized type of Node designed for executing character abilities within a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the Ability node.',
            display: 'Name',
        },
        {
            name: 'abilityNameKey',
            type: 'string',
            description: 'Key to extract the ability name (string) for the `/doability` command from the blackboard.',
            display: 'Ability Name Key',
        },
        {
            name: 'abilityName',
            type: 'string',
            description: 'The ability name (string) for the `/doability` command if provided will be used instead of `abilityNameKey`.',
            display: 'Ability Name',
        },
  
  
        
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const attackNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The AttackNode is a type of Node designed to manage and control attack commands within the game. It allows behavior trees to dynamically initiate or cease character attacks based on the current state and context.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the attack node. Used for identification and debugging purposes.',
            display: 'Name',
        },
        {
            name: 'desiredStateKey',
            type: 'string',
            description: 'Key to the string value for the `/attack` command (\'on\' or \'off\').',
            display: 'Desired State Key',
        },
        {
            name: 'attackTypeKey',
            type: 'string',
            description: 'Key to the string value to determine if the command should be `attack` or `autofire`.',
            display: 'Attack Type Key',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const memorizeSpellNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The MemorizeSpellNode is a type of Node designed to handle the memorization of spells into a character\'s spell gem slots in a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the MemorizeSpell node.',
            display: 'Name',
        },
        {
            name: 'spellGemKey',
            type: 'string',
            description: 'Key to extract the gem slot number (integer) for the spell memorization from the blackboard.',
            display: 'Spell Gem Key',
        },
        {
            name: 'spellIdKey',
            type: 'string',
            description: 'Key to extract the spell ID (integer) to be memorized from the blackboard.',
            display: 'Spell ID Key',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const moveToNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The MoveToNode is a type of Node responsible for moving a character to a specified location or target in a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the MoveTo node.',
            display: 'Name',
        },
        {
            name: 'spawnIdKey',
            type: 'string',
            description: 'Key to extract the spawn ID (number) from the blackboard, if moving towards a specific target.',
            display: 'Spawn ID Key',
        },
        {
            name: 'coordinatesKey',
            type: 'string',
            description: 'Key to extract the target coordinates (object with X, Y, Z values) from the blackboard, if moving towards a specific location.',
            display: 'Coordinates Key',
        },
        {
            name: 'positionKey',
            type: 'string',
            description: 'Key to extract the position range (object with Min and Max values) from the blackboard, defining the arc range for positioning relative to the target.',
            display: 'Position Key',
        },
        {
            name: 'distanceKey',
            type: 'string',
            description: 'Key to extract the distance range (object with Min and Max values) from the blackboard, defining how close the character needs to be to the target location.',
            display: 'Distance Key',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const sitNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The SitNode is a type of Node designed to manage the character\'s sitting state in a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the Sit node.',
            display: 'Name',
        },
        {
            name: 'maxSitAttempts',
            type: 'number',
            description: 'The maximum number of attempts the node should make to sit before returning failure.',
            display: 'Max Sit Attempts',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const targetNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The TargetNode is a type of Node used to target specific entities within a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the Target node.',
            display: 'Name',
        },
        {
            name: 'targetIdKey',
            type: 'string',
            description: 'Key to extract the spawn search (number or string) from the blackboard.',
            display: 'Target ID Key',
        },
        {
            name: 'targetTypeKey',
            type: 'string',
            description: 'Key to extract the target type (e.g., "NPC", "PC") from the blackboard.',
            display: 'Target Type Key',
            optional: true,  
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const faceNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The FaceNode is a type of Node used to face a specified ID or loc.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the Face node.',
            display: 'Name',
        },
        {
            name: 'faceIdKey',
            type: 'string',
            description: 'Key to extract the id from the blackboard.',
            display: 'Spawn ID Key',
            optional: true,
        },
        {
            name: 'locationKey',
            type: 'string',
            description: 'Key to extract the location from the blackboard.',
            display: 'Location  Key',
            optional: true, 
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const conditionNodeDetails: NodeDetails = {
    category: NodeCategory.Other,  
    description: 'The ConditionNode is a type of Node used to evaluate conditions within a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'Name of the Condition node.',
            display: 'Name',
        },
        {
            name: 'conditionKey',
            type: 'string',
            description: 'Key referencing the specific condition function to evaluate.',
            display: 'Condition Key',
        },
        {
            name: 'paramKeys',
            type: 'string[]',
            description: 'Optional array of keys to extract parameters from the blackboard for use with the condition function. Defaults to an empty array.',
            display: 'Parameter Keys',
            optional: true,  
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const failerNodeDetails: NodeDetails = {
    category: NodeCategory.Other,  
    description: 'The FailerNode is a specialized Node that always returns a Failure state when executed. It\'s used within a behavior tree to represent an action or condition that always fails, typically to deliberately trigger the failure of a particular branch.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the Failer node.',
            display: 'Name',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const succeederNodeDetails: NodeDetails = {
    category: NodeCategory.Other,  
    description: 'The SucceederNode is a type of Node that always returns Success, regardless of its child node\'s result. It\'s typically used to ensure that a branch of the behavior tree continues executing even if a non-critical action fails.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the SucceederNode, used for identification and debugging purposes.',
            display: 'Name',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};
const waitNodeDetails: NodeDetails = {
    category: NodeCategory.Action,  
    description: 'The WaitNode is a type of Node that pauses execution for a specified duration. This node is commonly used to introduce delays or timed waits within a behavior tree.',
    inputs: [
        {
            name: 'name',
            type: 'string',
            description: 'The name of the WaitNode, used for identification and debugging purposes.',
            display: 'Name',
        },
        {
            name: 'time',
            type: 'number',
            description: 'The duration to wait in seconds.',
            display: 'Time (Seconds)',
        },
    ],
    canHaveChildren: false,  
    isDecorator: false,  
};

export const NodeDetails: Record<NodeType, NodeDetails> =
{
    [NodeType.CastSpell]: castSpellNodeDetails,
    [NodeType.Sequence]: sequenceNodeDetails,
    [NodeType.Parallel]: parallelNodeDetails,
    [NodeType.Select]: selectNodeDetails,
    [NodeType.RandomSelector]: randomSelectorNodeDetails,
    [NodeType.Invert]: invertNodeDetails,
    [NodeType.Loop]: loopNodeDetails,
    [NodeType.Repeat]: repeatNodeDetails,
    [NodeType.Retry]: retryNodeDetails,
    [NodeType.Ability]: abilityNodeDetails,
    [NodeType.Face]: faceNodeDetails,
    [NodeType.Attack]: attackNodeDetails,
    [NodeType.MemorizeSpell]: memorizeSpellNodeDetails,
    [NodeType.MoveTo]: moveToNodeDetails,
    [NodeType.Sit]: sitNodeDetails,
    [NodeType.Target]: targetNodeDetails,
    [NodeType.Condition]: conditionNodeDetails,
    [NodeType.Failer]: failerNodeDetails,
    [NodeType.Succeeder]: succeederNodeDetails,
    [NodeType.Wait]: waitNodeDetails
} as Record<NodeType, NodeDetails>;