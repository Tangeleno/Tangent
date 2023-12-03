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
- **Utility AI**: Responsible for making decisions based on the character's role and current situation.
- **Behavior Tree**: Manages action sequencing and execution, adapting to instructions from the Coordinator and the Utility AI.

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
