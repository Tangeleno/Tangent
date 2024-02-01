# Base Nodes

These nodes represent abstract concepts and are used as the base for the other nodes.

## Node

The `Node` class serves as the fundamental building block for constructing a behavior tree. Each `Node` represents a discrete task, condition, or control flow mechanism in the tree. The base `Node` is typically extended to create specific types of nodes tailored to the needs of the behavior tree.

### Arguments

- **args** (`NodeArgs`): The configuration and parameters for the node.
  - **name** (`string`): A string representing the name of the node. This name is used for identification and debugging purposes.

### Overview

Each `Node` in a behavior tree has a state that represents the outcome of its processing, such as Success, Failure, Running, or Invalid. When a `Node` is executed, it performs its designated task and updates its state accordingly.

The base `Node` provides the essential interface and common functionality needed by all nodes. This includes the ability to initialize, update, and terminate the node. Specific types of nodes extend this class and implement the `_Update` method to provide the desired behavior.

### Usage

While the base `Node` class is not typically instantiated directly, it provides the foundation for all other node types in a behavior tree. Subclasses of `Node` override the `_Update` method to define the node's behavior and may also override the `_OnInitialize` and `_OnTerminate` methods to handle initialization and cleanup.

In a behavior tree, nodes are connected to form a hierarchical structure that defines the order and conditions under which tasks are executed. The root of the tree is a special node that starts the execution of the tree.

This documentation provides a high-level overview of the `Node` class. For detailed information on extending the `Node` and creating specific types of nodes, refer to the documentation for the respective subclass.

## CompositeNode

The `CompositeNode` is a type of [Node](#Node) designed to manage one or more child nodes. It's a foundational class used to create specific composite behaviors in a behavior tree, such as sequences or selectors. Composite nodes typically evaluate their children in a specific order and decide their state based on the children's states.

### Arguments

- **args** (`NodeArgs`): The configuration and parameters for the node.
  - **name** (`string`): A string representing the name of the node. This name is used for identification and debugging purposes.

### Overview

`CompositeNode` is an abstract base class and is not meant to be instantiated directly. Instead, it serves as a parent for more specific types of composite nodes, like [Selector](#Selector) and [Sequence](#Sequence), each of which has its own logic for processing its children and determining its state based on their outcomes.

Each `CompositeNode` maintains a list of child nodes. During its update cycle, it will typically iterate through these children, tick each one, and then decide its state based on a specific policy (e.g., succeed if one child succeeds for a Selector or succeed only if all children succeed for a Sequence).

### Usage

In a behavior tree, `CompositeNode` derivatives are used to control the flow of execution based on their children's states. For example, a `Selector` node will select one of its children to execute based on certain conditions, while a `Sequence` node will run its children in a specific order until one fails or all succeed.

Developers create specific behavior tree structures by subclassing `CompositeNode` and implementing the logic to manage child nodes and determine the composite node's state.

This documentation provides a conceptual overview of the `CompositeNode` class. For detailed information on creating and using specific types of composite nodes, refer to the documentation for each subclass.

## DecoratorNode

The `DecoratorNode` is a type of [Node](#Node) that manages a single child node, altering or augmenting its behavior. Decorator nodes are typically used to modify the execution or outcome of their child node based on specific conditions or rules.

### Arguments

- **args** (`NodeArgs`): The configuration and parameters for the node
  - **name** (`string`): A string representing the name of the node. This name is used for identification and debugging purposes.

### Overview

A `DecoratorNode` is used in behavior trees to control or influence the behavior of its child node. This might involve repeating the child node until a condition is met, inverting the success/failure result of the child, or adding some additional checks or behaviors before or after the child node runs.

The primary role of a `DecoratorNode` is to have a single child node and implement some form of control over it. This allows for more complex and dynamic behavior trees, as the decorator can dynamically alter how and when its child operates.

### Usage

In practice, you would use a `DecoratorNode` as a wrapper around another node. You might have a `RepeatDecorator` that continues to execute its child node until a certain condition is met, or an `InvertDecorator` that inverts the success/failure result of its child.

When building a behavior tree, a `DecoratorNode` would be instantiated and given a child node. The specific type of decorator determines exactly how it interacts with its child. During the tree's execution, when the decorator node is ticked, it will perform its specific function and then tick its child node.

This documentation provides a general overview of the `DecoratorNode` class. For detailed information on creating and using specific types of decorator nodes, refer to the documentation for each subclass.

# Composite Nodes

Composite nodes evaluate their children in a specific order and decide their state based on the children's states.

## SequenceNode

The `SequenceNode` is a type of [CompositeNode](#CompositeNode) that processes its child nodes in order and succeeds only if all its children succeed. The node will return the first failure encountered, or success if all children succeed.

### Arguments

- **NodeArgs** (`NodeArgs`): Standard arguments for a node.
  - **name** (`string`): The name of the node, used for identification and debugging.

### Overview

The `SequenceNode` executes its child nodes one at a time, in the order they were added. It proceeds to the next child only if the current one succeeds. If any child node fails, the entire `SequenceNode` fails, and it will not process any further children.

This node is often used when multiple conditions or actions must be performed in a specific order, where each step depends on the successful completion of the previous one. For example, a character might need to move to a location, pick up an item, and then use that item; if any of these steps fail, the overall task fails.

When a `SequenceNode` starts, it begins with its first child node. If the child returns:

- **Success**: `SequenceNode` proceeds to the next child.
- **Failure**: `SequenceNode` immediately returns **Failure**.
- **Running**: `SequenceNode` returns **Running** and will reevaluate the same child on the next tick.

If all children return **Success**, the `SequenceNode` itself returns **Success**. If a child node returns **Invalid**, the `SequenceNode` also returns \*\*Invalid`, indicating an issue with the behavior tree's configuration or state.

## ParallelNode

The `ParallelNode` is a type of [CompositeNode](#CompositeNode) that executes its child nodes in 'parallel', evaluating their collective results based on a specified success percentage.

### Arguments

- **ParallelNodeArgs** (`ParallelNodeArgs`): Configuration specific to the ParallelNode.
  - **name** (`string`): The name of the node, used for identification and debugging.
  - **percentage** (`number`): The percentage of child nodes that need to succeed for this node to report success.
  - **breakOnThreshold** (`string`): (Optional) Determines the condition under which to terminate early. Can be "No", "SuccessOnly", "FailureOnly", or "Any".

### Overview

`ParallelNode` allows multiple child nodes to execute 'simultaneously', unlike other composite nodes that execute children sequentially. This node is useful for situations where multiple actions or checks need to occur at the same time, and the overall success depends on a certain percentage of those actions succeeding.

Here's how `ParallelNode` works:

- On each tick, it executes all its child nodes.
- It counts the number of children that succeed and those that fail.
- If the percentage of successful children reaches the specified threshold, it returns a **Success** state.
- If the percentage of failed children reaches a point where it's impossible to achieve the success threshold, it returns a **Failure** state.
- The behavior for early termination based on `breakOnThreshold` is as follows:
  - If set to "Any", it terminates early if either success or failure threshold is reached.
  - If set to "SuccessOnly", it terminates early only if the success threshold is reached.
  - If set to "FailureOnly", it terminates early only if the failure threshold is reached.
  - If set to "No" or not specified, it will not terminate early based on thresholds.
- If neither threshold is reached, it returns a **Running** state, indicating that not all children have finished executing.

`ParallelNode` is particularly useful in scenarios where you want to manage multiple tasks that don't depend on each other's results and make decisions based on the collective outcome.

**NOTE**: Nodes are executed synchronously, one after the other, not truly parallel.


## SelectNode

The `SelectNode` is a type of [CompositeNode](#CompositeNode) that iterates through its children, returning the state of the first child that does not fail. It effectively selects the first successful path or action to take.

### Arguments

- **NodeArgs** (`NodeArgs`): Standard arguments for a node.
  - **name** (`string`): The name of the node, used for identification and debugging.

### Overview

The `SelectNode` is often used in decision-making processes within a behavior tree. It evaluates its child nodes in the order they were added and selects the first one that succeeds. Here's how it operates:

- On each tick, it executes its children one by one in the order they were added.
- If a child node returns **Success**, the `SelectNode` immediately returns **Success** and doesn't process any further nodes.
- If a child node returns **Running**, the `SelectNode` returns **Running** and will continue from this node in the next tick.
- If a child node returns **Failure**, the `SelectNode` ignores this result and moves on to the next child.
- If all children return **Failure**, then the `SelectNode` itself returns **Failure**.

The `SelectNode` is ideal for trying a series of different strategies or actions where the first successful one is desired. It's akin to an "OR" logic gate in behavior tree design, often used in scenarios where multiple conditions or actions are checked or performed in a preferred order until one succeeds.

## RandomSelector

The `RandomSelector` is a specialized type of [SelectNode](#SelectNode) that shuffles its children and then proceeds like a regular `SelectNode`. It randomly picks one of the child nodes to execute first, providing a way to add variety or unpredictability to the behavior tree.

### Arguments

- **NodeArgs** (`NodeArgs`): Standard arguments for a node.
  - **name** (`string`): The name of the node, used for identification and debugging.

### Overview

The `RandomSelector` node works similarly to a `SelectNode` with the added feature of randomizing the order of its children before execution. Here's how it operates:

- When initialized, it shuffles the order of its child nodes.
- On each tick, it executes its children in this new random order.
- If a child node returns **Success**, the `RandomSelector` immediately returns **Success** and doesn't process any further nodes.
- If a child node returns **Running**, the `RandomSelector` returns **Running** and will continue from this node in the next tick.
- If a child node returns **Failure**, the `RandomSelector` ignores this result and moves on to the next child.
- If all children return **Failure**, then the `RandomSelector` itself returns **Failure**.

The `RandomSelector` is ideal in situations where you want the entity to try different strategies in a random order each time it runs, adding unpredictability and variability to its behavior.

# Decorator Nodes

Decorator nodes are used to modify the execution or outcome of their child node based on specific conditions or rules.

## InvertNode

The `InvertNode` is a type of [DecoratorNode](#DecoratorNode) that inverts the result of its child node. It's used to reverse the success or failure of the child node's outcome.

### Arguments

- **NodeArgs** (`NodeArgs`): Basic configuration for the node.
  - **name** (`string`): The name of the Invert node.

### Overview

`InvertNode` takes a single child node and inverts its result:

- If the child node succeeds, `InvertNode` will return a **Failure** state.
- If the child node fails, `InvertNode` will return a **Success** state.
- If the child node is still running or is in an invalid state, `InvertNode` will return the same state.

This node is useful in scenarios where you want to reverse the logic of a condition or action. For instance, if you have a condition that checks if an enemy is within a certain range and you want to take action when it's not, you can invert the result to trigger the desired behavior when the enemy is out of range.

## LoopNode

The `LoopNode` is a type of [DecoratorNode](#DecoratorNode) designed to repeatedly execute its child node a specified number of times or until a condition is met.

### Arguments

- **LoopNodeArgs** (`LoopNodeArgs`): Configuration specific to the LoopNode.
  - **name** (`string`): The name of the Invert node.
  - **loopCount** (`number`): The number of times to execute the child node.
  - **conditionKey** (`string`): (Optional) A key to a condition function in the conditions table. This function should return a boolean value. If the function returns false, the loop will terminate early.

### Overview

`LoopNode` is used to perform repetitive tasks by executing its child node multiple times based on the specified loop count or until an optional condition is met. It's useful in scenarios where a particular action or set of actions needs to be repeated several times, such as patrolling an area or trying an action until it succeeds.

Here's how `LoopNode` works:

- On each tick, it executes its child node.
- If the child node succeeds, it increments the current loop counter and checks if it has reached the loop count.
  - If the loop count hasn't been reached, it continues running.
  - If the loop count has been reached, it returns a **Success** state.
- If an optional condition is provided and it returns false, the loop terminates early with a **Failure** state.
- If the child node returns a state other than **Success**, `LoopNode` returns that state.

This node allows for flexible and repeated behavior execution, making it a versatile component in a behavior tree for tasks that require multiple attempts or iterations.

## RepeatNode

The `RepeatNode` is a type of [DecoratorNode](#DecoratorNode) that repeats its child node a specified number of times or until the child node fails. It's useful for tasks that need to be attempted multiple times.

### Arguments

- **RepeatNodeArgs** (`RepeatNodeArgs`): Specific arguments for a `RepeatNode`.
  - **name** (`string`): The name of the node, used for identification and debugging.
  - **repeatCount** (`number`): The number of times to repeat the child node. If not specified, it defaults to 1.

### Overview

The `RepeatNode` continuously executes its single child node until one of the following conditions is met:

- The child node fails (returns **Failure**).
- The specified number of repetitions (`repeatCount`) is reached.

Each time the child node returns **Success**, the `RepeatNode` increments its counter and checks whether it has reached the `repeatCount`. If it has, the `RepeatNode` itself returns **Success**. If the child node ever returns **Failure**, the `RepeatNode` immediately returns **Failure** without completing any further repetitions.

This node is particularly useful in scenarios where an action needs to be attempted multiple times until it succeeds a certain number of times or when you want to execute an action repeatedly for a set number of iterations.

## RetryNode

The `RetryNode` is a type of [DecoratorNode](#DecoratorNode) that retries its child node a specified number of times or until the child node succeeds. This node is used when an action might fail initially but could succeed upon subsequent attempts.

### Arguments

- **RetryNodeArgs** (`RetryNodeArgs`): Specific arguments for a `RetryNode`.
  - **name** (`string`): The name of the node, used for identification and debugging.
  - **repeatCount** (`number`): The number of times to retry the child node. If not specified, it defaults to 1.

### Overview

The `RetryNode` executes its single child node repeatedly until one of the following conditions is met:

- The child node succeeds (returns **Success**).
- The specified number of retries (`repeatCount`) is reached.

Each time the child node returns **Failure**, the `RetryNode` increments its retry counter and checks whether it has reached the `repeatCount`. If it has, the `RetryNode` itself returns **Failure**. If the child node ever returns **Success**, the `RetryNode` immediately returns **Success** without completing any further retries.

This node is useful in scenarios where an action has a chance of failure but might succeed if attempted again, such as attempting to establish a connection or requesting data that might not be available initially.

# Leaf Nodes

Leaf nodes tend to interact with the system or delay execution of the tree until certain condidions are met.

## AbilityNode

The `AbilityNode` is a specialized type of [Node](#Node) designed for executing character abilities within a behavior tree.

### Arguments

- **AbilityNodeArgs** (`AbilityNodeArgs`): Configuration and parameters for the ability node.
  - **name** (`string`): Name of the Ability node.
  - **abilityNameKey** (`string`): Key to extract the ability name (string) for the `/doability` command from the blackboard.
  - **abilityName** (`string`): The real value for the `/doability` if provided will be used instead of the abilityNameKey.

### Overview

The `AbilityNode` is used to activate a specific ability of a character, referenced by name. It reads the ability's name from the blackboard, verifies the ability is available and ready to use, then executes the ability using the `/doability` command.

- The node returns **Success** when the ability is successfully triggered.
- It returns **Failure** if the ability is not ready to be used or if the character does not possess the skill.
- It returns **Invalid** if the provided ability name is not found or the required blackboard parameters are missing.

This node is critical for automating the use of character skills and abilities, ensuring that they are used at appropriate times and under the right conditions.

## FaceNode

The `FaceNode` is a specialized type of [Node](#Node) designed for executing the MacroQuest /face command

### Arguments

- **FaceNodeArgs** (`FaceNodeArgs`): Configuration and parameters for the face node.
  - **name** (`string`): Name of the Ability node.
  - **faceIdKey** (`string`): Key to int value of the target we should face
  - **locationKey** (`string`): Key to Coordinates (table with X,Y,Z properties)

### Overview

The `FaceNode` is used to activate the MacroQuest /face command.

- The node returns **Success** when the ability is successfully triggered.

## AttackNode

The `AttackNode` is a type of [Node](#Node) designed to manage and control attack commands within the game. It allows behavior trees to dynamically initiate or cease character attacks based on the current state and context.

### Arguments

- **AttackNodeArgs** (`AttackNodeArgs`): The configuration and parameters for the attack node.
  - **name** (`string`): The name of the attack node. Used for identification and debugging purposes.
  - **desiredStateKey** (`string`): Key to the string value for the `/attack` command ('on' or 'off').
  - **attackTypeKey** (`string`): Key to the string value to determine if the command should be `attack` or `autofire`.

### Overview

An `AttackNode` is commonly used in combat scenarios where the behavior tree needs to decide when to start or stop attacking based on game conditions, strategy, or other factors. By providing dynamic control over the attack state, it enables complex and responsive behaviors in combat situations.

When executed, this node will retrieve the desired state ('on' or 'off') and the type of attack ('attack' or 'autofire') from the blackboard. It then constructs and executes the appropriate command to control the character's attack state accordingly.

## CastSpellNode

The `CastSpellNode` is a specialized type of [Node](#Node) designed for casting spells, disciplines, items, and alternate abilities within a behavior tree.

### Arguments

- **CastSpellNodeArgs** (`CastSpellNodeArgs`): Configuration and parameters for the cast spell node.
  - **name** (`string`): The name of the node, used for identification and debugging.
  - **targetIdKey** (`string`): Key to extract the target ID (number|string) from the blackboard.
  - **targetTypeKey** (`string`): Key to extract the target type (string) from the blackboard.
  - **spellIdKey** (`string`): Key to extract the spell ID (number|string) from the blackboard.
  - **spellTypeKey** (`string`): Key to extract the spell type (string, e.g., "Item", "AA", "Gem", "Disc") from the blackboard.
  - **spellResultKey** (`string`): Key to place the result of the spell (string, e.g., "Success", "Interrupt", "Fizzle", "Immune", etc) in the blackboard.
  - **spellKey** (`string`): Key to extra the actual Spell(userdata) from Keys are expected to exist in the `blackboard.Spells` table.

### Overview

The `CastSpellNode` is primarily used to initiate and manage the casting of various types of spells and abilities. It handles the specifics of casting, including validation of the spell or ability, checking readiness, and interpreting the result of the cast attempt.

- The node will return **Success** if the spell is cast successfully.
- It returns **Failure** if the spell isn't ready to be cast, if the casting is interrupted, or if the spell fails to complete successfully for any other reason.
- It returns **Invalid** if the spell or ability doesn't exist or if provided parameters in the blackboard are incorrect or insufficient.

This node is essential for implementing complex casting behaviors and strategies, providing a reliable and consistent way to handle various outcomes and scenarios associated with spell casting.

## MemorizeSpellNode

The `MemorizeSpellNode` is a type of [Node](#Node) designed to handle the memorization of spells into a character's spell gem slots in a behavior tree.

### Arguments

- **MemorizeSpellNodeArgs** (`MemorizeSpellNodeArgs`): Configuration and parameters for the memorize spell node.
  - **name** (`string`): Name of the MemorizeSpell node.
  - **spellGemKey** (`string`): Key to extract the gem slot number (integer) for the spell memorization from the blackboard.
  - **spellIdKey** (`string`): Key to extract the spell ID (integer) to be memorized from the blackboard.

### Overview

`MemorizeSpellNode` is responsible for managing the memorization of spells in a character's spellbook. It interacts with the game to place a specified spell into a designated spell gem slot. The node utilizes the `/memspell` command in MacroQuest to memorize the spell.

- When executed, the node checks if the desired spell is already memorized in the specified gem slot. If so, it returns **Success**.
- If the spell is not already memorized, the node issues the memorization command and waits for the process to complete before returning **Success**.
- The node returns **Invalid** if the specified spell is not found in the character's spellbook.
- It's typically used in scenarios where a character needs to prepare a specific set of spells for combat or utility purposes.

This node is crucial in ensuring that the character has the right spells memorized at the right time, contributing to the effectiveness and adaptability of the behavior tree's strategy.

## MoveToNode

The `MoveToNode` is a type of [Node](#Node) responsible for moving a character to a specified location or target in a behavior tree.

### Arguments

- **MoveToNodeArgs** (`MoveToNodeArgs`): Configuration and parameters for the move-to node.
  - **name** (`string`): Name of the MoveTo node.
  - **spawnIdKey** (`string`): Key to extract the spawn ID (number) from the blackboard, if moving towards a specific target.
  - **coordinatesKey** (`string`): Key to extract the target coordinates (object with X, Y, Z values) from the blackboard, if moving towards a specific location.
  - **positionKey** (`string`): Key to extract the position range (object with Min and Max values) from the blackboard, defining the arc range for positioning relative to the target.
  - **distanceKey** (`string`): Key to extract the distance range (object with Min and Max values) from the blackboard, defining how close the character needs to be to the target location.

### Overview

`MoveToNode` directs a character to move towards a specified location or target. It can be configured to move to static coordinates or to follow a moving target. The node uses MacroQuest's navigation system to find and follow a path to the target.

- The node returns **Running** while the character is in the process of moving towards the target.
- It returns **Success** once the character is within the specified range of the target location or spawn.
- If it cannot find a path to the target or if the target location changes significantly during navigation, it returns **Failure**.
- The node returns **Invalid** if the provided target or coordinates are not valid.

This node is often used in behavior trees to ensure that a character navigates to the right position for combat, resource gathering, or interaction with NPCs and objects.

## SitNode

The `SitNode` is a type of [Node](#Node) designed to manage the character's sitting state in a behavior tree.

### Arguments

- **SitNodeArgs** (`SitNodeArgs`): Configuration and parameters for the sit node.
  - **name** (`string`): Name of the Sit node.
  - **maxSitAttempts** (`number`): The maximum number of attempts the node should make to sit before returning failure.

### Overview

`SitNode` controls the character's sitting state, attempting to make the character sit down. It's typically used in behavior trees where the character needs to rest to regenerate resources like mana or health, or when a sitting posture is required for certain actions.

- The node returns **Running** while the character is attempting to sit down.
- It returns **Success** once the character successfully sits down.
- If the character fails to sit down after the specified number of attempts, it returns **Failure**.
- The node handles cases where the character is already sitting, returning **Success** immediately.

This node is useful in scenarios where the character's posture needs to be managed as part of a larger sequence of actions, such as preparing for combat, resting after an encounter, or when interacting with certain game mechanics that require the character to be seated.

## TargetNode

The `TargetNode` is a type of [Node](#Node) used to target specific entities within a behavior tree.

### Arguments

- **TargetNodeArgs** (`TargetNodeArgs`): Configuration and parameters for the targeting node.
  - **name** (`string`): Name of the Target node.
  - **targetIdKey** (`string`): Key to extract the spawn search(number or string) from the blackboard.
  - **targetTypeKey** (`string`, optional): Key to extract the target type (e.g., "NPC", "PC") from the blackboard.

### Overview

`TargetNode` attempts to target an entity based on the provided ID and type. It's commonly used in behavior trees where interacting with a specific entity is required, such as engaging an enemy, assisting an ally, or interacting with an object.

- The node checks the current target against the desired target and returns **Success** if they match.
- If the targets don't match, it attempts to target the desired entity and returns **Running** while doing so.
- It returns **Failure** if the desired target is invalid or cannot be targeted.

This node is essential in scenarios where precise interaction with specific entities is crucial. It ensures that the character's focus is correctly set to the intended target before proceeding with further actions like attacking, casting spells, or initiating dialogue.

## ConditionNode

The `ConditionNode` is a type of [Node](#Node) used to evaluate conditions within a behavior tree.

### Arguments

- **ConditionNodeArgs** (`ConditionNodeArgs`): Configuration and parameters for the condition node.
  - **name** (`string`): Name of the Condition node.
  - **conditionKey** (`string`): Key referencing the specific condition function to evaluate.
  - **paramKeys** (`string[]`, optional): ptional array of keys to extract parameters from the blackboard for use with the condition function. Defaults to an empty array.

### Overview

`ConditionNode` evaluates a specified condition function and returns a result based on the evaluation. It's a crucial element in behavior trees to facilitate decision-making based on the current state, environment, or other factors.

- The node retrieves the condition function based on the `conditionKey` provided. This function is expected to return a boolean value indicating the condition's result.
- Parameters for the condition function can be dynamically retrieved from the blackboard using the `paramKeys`.
- If the condition evaluates to `true`, the node returns **Success**; otherwise, it returns **Failure**.
- In case of an error during the condition evaluation or if the condition is undefined, the node returns

## FailerNode

The `FailerNode` is a specialized [Node](#Node) that always returns a **Failure** state when executed.

### Arguments

- **NodeArgs** (`NodeArgs`): Basic configuration for the node.
  - **name** (`string`): The name of the Failer node.

### Overview

`FailerNode` is a simple control node that can be used within a behavior tree to represent an action or condition that always fails. This might be useful in scenarios where you want to deliberately trigger the failure of a particular branch of your behavior tree under certain conditions.

- When executed, this node doesn't perform any checks or actions. It simply returns a **Failure** state regardless of any context or conditions.
- This node is typically used within more complex structures in a behavior tree, like decorators or composites, where the failure of a child node can influence the behavior of the parent node.
- The primary use case is to provide a predictable and controlled failure point in a behavior tree for testing or to force a particular flow of execution.

## SucceederNode

The `SucceederNode` is a type of [Node](#Node) that always returns **Success**, regardless of its child node's result. It's typically used to ensure that a branch of the behavior tree continues executing even if a non-critical action fails.

### Arguments

- **name** (`string`): The name of the `SucceederNode`, used for identification and debugging purposes.

### Overview

The `SucceederNode` is a simple utility node within a behavior tree. Its primary role is to wrap a potentially failing action or condition and neutralize its failure, treating it as a success instead. This can be useful in scenarios where the failure of a particular node should not halt the entire tree's execution or when used within more complex control nodes that manage multiple children.

When the `SucceederNode` is executed:

- It runs its child node (if any).
- Regardless of the child's result (Success, Failure, Running, or Invalid), the `SucceederNode` will return **Success**.

This behavior allows certain actions or checks to be optional within the broader context of the tree's logic. However, it's essential to use this node judiciously, as it can mask failures that might be significant in other contexts.

## WaitNode

The `WaitNode` is a type of [Node](#Node) that pauses execution for a specified duration. This node is commonly used to introduce delays or timed waits within a behavior tree.

### Arguments

- **name** (`string`): The name of the `WaitNode`, used for identification and debugging purposes.
- **time** (`number`): The duration to wait in seconds.

### Overview

The `WaitNode` is a utility node that causes the behavior tree to wait for a certain amount of time before proceeding. When the node is active, it continuously tracks the elapsed time and compares it against the specified duration.

- If the elapsed time is less than the specified duration, the node returns **Running**.
- Once the elapsed time meets or exceeds the specified duration, the node returns **Success**.

This node is especially useful in scenarios where a delay is needed between actions or to throttle the frequency of certain checks or behaviors.

### Use Cases

- **Throttling actions**: Prevent an action from running too frequently by ensuring a minimum wait time between executions.
- **Delays in sequences**: Introduce a pause between actions in a sequence, for instance, waiting for an animation to complete before starting the next action.
- **Timed behaviors**: Implement behaviors that should only trigger after a certain amount of time has passed, like reminders or time-based checks.
