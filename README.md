# Tangent System Plan for EverQuest

## Overview
Tangent  (Tangeleno's Agent Network for Game Environment and Tactical Navigation) is a sophisticated AI system designed to control a team of characters in the MMORPG EverQuest, ultimately capable of managing an entire raid team. The system comprises multiple agents (characters), a central coordinator, and a shared blackboard for communication.

## System Components

### 1. Shared Blackboard (Redis Key/Value Store)
- **Function**: Facilitates communication between agents using a Redis key/value store with pub/sub capabilities.
- **Character Data**: Stores character-specific information like HP, Mana, position, etc., in the format `<server>:<leaderName>:characters:<characterName>`.
- **Enemy Data**: Leaders post data about nearby enemies under `<server>:<leaderName>:spawns`.
- **Action Plans**: Characters store their planned actions in `<server>:<leaderName>:plan:<characterName>`.
- **Crowd Control and Debuffs**: Information about controlled and debuffed enemies is stored and managed.

### 2. Agent System (Utility AI and Behavior Tree in LUA)

#### 2.1 Utility AI
- **Description**: The Utility AI is responsible for making medium-term tactical decisions within the context of the Coordinator's directives. It understands the character's role and capabilities (like how to play a wizard) and decides the best way to fulfill the Coordinator's objectives.
- **Responsibilities**:
  - **Tactical Decisions**: Determines how to best achieve the Coordinator's objectives based on the character's specific skills, spells, and abilities. For example, choosing the most effective spell to deal damage quickly.
  - **Directive Interpretation**: Interprets the Coordinator's broad objectives (e.g., "attack this target") into specific actions (e.g., "use Fireball on target").
  - **Decision-Making Process**: Uses algorithms to evaluate different tactical options and chooses the most effective one based on the current situation and character's capabilities.

#### 2.2 Behavior Tree
- **Description**: The Behavior Tree manages the detailed sequencing and execution of actions as defined by the Utility AI. It ensures that the character carries out actions correctly and efficiently.
- **Responsibilities**:
  - **Action Validation**: Confirms that an action is possible and viable at the moment. This includes checking for target validity, resource availability, cooldowns, and other prerequisites.
  - **Action Execution**: Handles the specifics of carrying out the action, including targeting, movement, and timing.
  - **Outcome Assessment**: Evaluates the success or failure of the action and provides feedback to the Utility AI.

##### Example Process:
1. **Coordinator Directive**: Engage in combat against the NPC "Foo."
2. **Utility AI Decision**: Choose to cast the spell "Fireball" for high damage.
3. **Behavior Tree Execution**:
   - **Validate Target**: 
     ```plaintext
     Check if "Foo" exists and is an NPC. If not, return FAILURE.
     ```
   - **Validate Spell**: 
     ```plaintext
     Check if "Fireball" is memorized and ready. If not, return FAILURE.
     ```
   - **Targeting**: 
     ```plaintext
     Ensure "Foo" is targeted. If not, target "Foo."
     ```
   - **Casting**: 
     ```plaintext
     Initiate the casting of "Fireball." Monitor the casting process.
     ```
   - **Outcome**: 
     ```plaintext
     Return SUCCESS if "Fireball" is cast successfully on "Foo," otherwise return FAILURE.
     ```

#### 2.3 Implementation Considerations:
- **Clear Interface**: Ensure a clear and consistent interface for communication between the Utility AI and the Behavior Tree, and between the overall system and the Coordinator.
- **Feedback Loops**: Implement feedback mechanisms where the Behavior Tree informs the Utility AI of the success or failure of actions, and the Utility AI can adjust tactics accordingly.
- **Modularity and Reusability**: Design Behavior Tree nodes to be modular and reusable for different characters and scenarios, enhancing the system's flexibility and ease of maintenance.
- **Error Handling and Recovery**: Establish robust error handling and recovery mechanisms within the Behavior Tree to ensure the agent can recover gracefully from unexpected situations and continue operating effectively.

### 3. Coordinator (GOAP in C#)
- **Role**: Manages overall team strategy, assigns tasks to agents, and ensures efficient operation and synchronization.
- **Action Management**: Validates and adjusts actions proposed by Utility AI to optimize team performance and prevent redundancy.

### 4. Custom Web Interface (C# Backend, SignalR, Vue3 Frontend)
- **Dashboard**: Displays metrics, dashboards, chat, and other relevant information.
- **Control Interface**: Allows for manual commands and overrides, facilitating hotseatability for players.

### 5. Learning Modules (Deep Q-Learning)
- **Agent Learning**: Tailored for each agent archetype (healer, DPS, tank, CC) and class.
- **Coordinator Learning**: Adjusts cost estimations and action selection for improved team coordination.

## Operational Cycle

### Tick-Based Synchronization
- **Heartbeat**: Coordinator sends a heartbeat signal at regular intervals via Redis pub/sub.
- **Agent Response**: Each agent receives the heartbeat, executes tasks, and sends back a 'pong' response.

### Agent Workflow
1. **Receive Coordinator's Heartbeat**: Marks the beginning of a new operational tick.
2. **Perform Tasks**: Based on current role and state, execute actions.
3. **Update Blackboard**: Post current status and planned actions.

### Coordinator Workflow
1. **Collect Data**: Read agents' statuses and action suggestions from the blackboard.
2. **Decision Making**: Assign tasks to each agent, considering their suggestions and overall strategy.
3. **Broadcast Decisions**: Send action assignments to agents via Redis.

## Hotseatability Feature
- **Control Transfer**: Players can take control of any agent at any time.
- **Coordinator Notification**: System informs the Coordinator about the change in control.
- **AI Suspension**: Suspends AI operations for the hotseated agent, allowing player-driven actions.
- **Role Definition**: Players can define their role upon taking control.
- **Reversion to AI**: Players can return control to the AI, which then reassesses and resumes its operations.

## Conclusion
Tangent is a complex and adaptive AI system designed for enhancing gameplay in EverQuest. It combines advanced AI techniques with real-time data processing and player interaction to create a dynamic and immersive gaming experience.
