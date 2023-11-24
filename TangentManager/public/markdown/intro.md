We are building a Cooperative Bot system for the game MMORPG EverQuest using MacroQuest to interface with the game
The current goal is to control 6 characters as a team, able to take on normal group content, with the end goal of being able to complete entire raids with 54 characters working together. Each bot will need to run in a separate process, without the ability to communicate directly between each other.

The current plan is
1. A Shared Blackboard using Redis key/value store with redis pub/sub for communication between the bots. Since Redis is single threaded concurrency isn't a huge concern
    1. Each character will insert a key with their own relevant information (HP,Mana,Spell/Abilities ready,position, etc.), the key will be `<server>:<leaderName>:characters:<characterName>` updated frequently
    1. The leader of each group of characters will insert a key with data about nearby enemies, (Position, HP, etc), the key will be `<server>:<leaderName>:spawns` updated frequently
    1. Each character will store their planned action in a key of `<server>:<leaderName>:plan:<characterName>` that will expire when the estimated action completion is updated frequently
    1. each character will add enemies they crowd controlled to the blackboard in a key of `<server>:<leaderName>:cc:<spawnId>`, with an expiration of the duration of the CC, and will be removed if the CC is broken early. The data in the key will be CC type (root, mezz, stun), caster, and duration
    1. each character will add enemies they debuff to the blackboard in a key of `<server>:<leaderName>:debuff:<spawnId>:<debuffType>` with the value being specific data about the debuff (slow percentage, tash level, etc) and general information, the caster, and duration of the spell each will be set to expire at the end of the duration of the spell. debuffTypes are Slow,Tash,Malo,Scent,Snare,Cripple
1. An Agent System to control each of the characters independently using Utility AI for the decision making and a behavior tree for action sequencing in LUA
1. A Coordinator to read the data in the shared blackboard and provide the independent agent systems with what actions need to be completed to complete it's goals. The team coordinator will use GOAP written in C#
1. A custom page written with a C# backend leveraging SignalR and Vue3 front end to display metrics, dashboards chat, and other information, also allowing commands to be sent overriding the AI to each character
1. Learning Modules - Likely Deep Q-Learning, the state is complex and currently the number of inputs aren't well defined but they could be large
    1. Agent Learning will be done for each agent archetype (healer, dps, tank, cc) and merged with learning for each class (details on how to do this are fuzzy). The learning will adjust the utility weights and activation scores of the utility AI
    1. Coordinator Learning will be done for all teams as a baseline and then specifically for each team. The learning will adjust the cost estimations, and action selection, with possible future state effecting world state representation
       for each the agent system and the team coordinator to improve their functionality over time,The state is complex, currently unknown number of inputs.


Possible names are
- **TANGENT** (Tangeleno's Agent Network for Game Environment and Tactical Navigation): This clever play on your handle 'tangeleno' suggests a system that is slightly divergent or innovative, appropriate for an advanced AI system.
- **NORRATH** (Networked Operational Robots for Raiding, Assisting, and Tactical Hunting): "Norrath" is the world in which EverQuest is set, encompassing the entire game's environment.
- **NEXUS** (Networked Expert System for Unified Gameplay): This acronym conveys the bot system's role as a networked expert system that facilitates seamless and unified gameplay experiences.
