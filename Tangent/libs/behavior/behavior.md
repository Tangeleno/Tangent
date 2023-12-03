## Node
### Description
Base class for all node types
### Constructor Parameters
- `name`: Name of the node
### Properties
- `NodeType`: String representing the type of the node, set to "Unknown".
### Methods
  - `new(name)`: Creates a new node instance
  - `Tick(blackboard)`: Update function, handles the node's operation and returns the state of the node
  - `Abort()`: Aborts the node
  - `IsTerminated()`: Returns true if the node is terminated
  - `IsSuccess()`: Returns true if the node is successful
  - `IsFailure()`: Returns true if the node is failed
  - `IsRunning()`: Returns true if the node is running


## CompositeNode
### Description
Base class for nodes that contain children
### Constructor Parameters
- `name`: Name of the node
### Properties
- `Children`: The the children of this node
### Methods
  - `AddChild(node)`: Adds a child to the composite node
### Inheritance
- Inherits from [Node](#Node) class.

## DecoratorNode
### Description
Base class for nodes that have a single child
### Constructor Parameters
- `name`: Name of the node
### Properties
- `Child`: The child of this node
### Methods
  - `SetChild(node)`: Sets the child of the decorator node
### Inheritance
- Inherits from [Node](#Node) class.

## SelectNode
### Description
Returns the first successful child or failure if all children fail
### Constructor Parameters
- `name`: Name of the node
### Properties
- `Children`: The the children of this node
### Inheritance
- Inherits from [CompositeNode](#CompositeNode) class.

## SequenceNode
### Description
Returns success only if all children succeed in order
### Constructor Parameters
- `name`: Name of the node
### Properties
- `Children`: The the children of this node
### Inheritance
- Inherits from [CompositeNode](#CompositeNode) class.

## ParallelNode
### Description
Runs all children simultaneously, returning success based on a success percentage
### Constructor Parameters
  - `name`: Name of the node
  - `percentage`: Percentage of nodes that need to have succeeded for this node to succeed
### Properties
- `Children`: The the children of this node
### Methods
  - `new(name)`: Creates a new ParallelNode instance
### Inheritance
- Inherits from [CompositeNode](#CompositeNode) class.

## InvertNode
### Description
Inverts the result of its child
### Constructor Parameters
  - `name`: Name of the  node
### Inheritance
- Inherits from [DecoratorNode](#DecoratorNode) class.

## RepeatNode
### Description
Repeats its child the specified number of times or until failure
### Constructor Parameters
  - `name`: Name of the node
  - `repeatCount`: Number of times to repeat the node
### Inheritance
- Inherits from [DecoratorNode](#DecoratorNode) class.

## RetryNode
### Description
Retries its child the specified number of times or until success
### Constructor Parameters
  - `name`: Name of the node
  - `repeatCount`: Number of times to retry the node
### Inheritance
- Inherits from [DecoratorNode](#DecoratorNode) class.

## ActionNode
### Description
The `ActionNode` is a specific node type in a Behavior Tree system. It represents an action that can be performed and encapsulates the logic required to execute it.
### Constructor Parameters
- `name` (string): Name of the Action node.
- `actionName` (string): Name of the action to perform.
- `paramKeys` (string[]): Keys used to extract the parameters from the blackboard.
### Properties
- `Action`: The action function to be executed.
### Methods
  - `new(name)`: Creates a new node instance
  - `Tick(blackboard)`: Update function, handles the node's operation and returns the state of the node
  - `Abort()`: Aborts the node
  - `IsTerminated()`: Returns true if the node is terminated
  - `IsSuccess()`: Returns true if the node is successful
  - `IsFailure()`: Returns true if the node is failed
  - `IsRunning()`: Returns true if the node is running
### Inheritance
- Inherits from [Node](#Node) class.

## WaitNode
### Description
The `WaitNode` waits for a specified amount of time.
### Constructor Parameters
- `name` (string): Name of the Wait node.
- `time` (number): Time to wait in seconds.
### Properties
- `NodeType`: String representing the type of the node, set to "WaitNode".
### Inheritance
- Inherits from [Node](#Node) class.

## ConditionNode
### Description
The `ConditionNode` checks the specified condition, returning successfully if the condition is true, else failure
### Constructor Parameters
- `name` (string): Name of the Condition node.
- `condition` (function): A function that returns a boolean. If true, the node will succeed before the time has elapsed.
- `paramKeys` (string[]): Keys used to extract the parameters from the blackboard.
### Properties
- `NodeType`: String representing the type of the node, set to "ConditionNode".
### Inheritance
- Inherits from [Node](#Node) class.

## RandomSelector
### Description
The `RandomSelector` randomly shuffles its children and then behaves like a regular selector, choosing the first child that succeeds.
### Constructor Parameters
- `name` (string): Name of the RandomSelector node.
### Properties
- `NodeType`: String representing the type of the node, set to "RandomSelector".
### Inheritance
- Inherits from [SelectNode](#SelectNode) class.

## FailerNode
### Description
The `FailerNode` always returns a failure status.
### Constructor Parameters
- `name` (string): Name of the Failer node.
### Properties
- `NodeType`: String representing the type of the node, set to "FailerNode".
### Inheritance
- Inherits from [Node](#Node) class.

## SucceederNode
### Description
The `SucceederNode` always returns a success status.
### Constructor Parameters
- `name` (string): Name of the Succeeder node.
### Properties
- `NodeType`: String representing the type of the node, set to "SucceederNode".
### Inheritance
- Inherits from [Node](#Node) class.

## LoopNode
### Description
The `LoopNode` executes its child node a specified number of times.
### Constructor Parameters
- `name` (string): Name of the Loop node.
- `loopCount` (number): Number of times to execute the child node.
### Properties
- `NodeType`: String representing the type of the node, set to "LoopNode".
- `LoopCount`: Number of times to execute the child node.
- `CurrentLoop`: Current iteration of the loop.
### Inheritance
- Inherits from [DecoratorNode](#DecoratorNode) class.


## Running
### LuaRocks Libraries
make sure your LUA_INCDIR and LUA_LIBDIR are set to your vcpkg installed static library like so
`LUA_INCDIR = "\macroquest\contrib\vcpkg\installed\x64-windows-static\include\luajit",`
`LUA_LIBDIR = "\macroquest\contrib\vcpkg\installed\x64-windows-static\lib",`
- open x64 Native Tools command Prompt for VS2022
- cd into your macroquest executable folder and run the following commands
- "luarocks.exe" install --tree "\modules\2.1.1697887905\luarocks" "lua-messagepack"
- "luarocks.exe" install --tree "\modules\2.1.1697887905\luarocks" "redis-lua"
- "luarocks.exe" install --tree "\modules\2.1.1697887905\luarocks" "luasocket"
- "luarocks.exe" install --tree "\modules\2.1.1697887905\luarocks" "rapidjson"
