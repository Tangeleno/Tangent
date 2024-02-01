<!--decisionagent.md-->
# DecisionAgent Class

The `DecisionAgent` class manages a collection of utility functions and is responsible for making decisions based on these functions.

## Methods

### `create(jsonFile)`

Creates a new decision agent instance.

- `jsonFile` (string, optional): The path to the JSON file containing utility function definitions.
- Returns: The created decision agent.

### `addUtilityFunction(uf)`

Adds a utility function to the agent.

- `uf` (UtilityFunction): The utility function to add.

### `loadUtilityFunctions(jsonFile)`

Loads utility functions from a JSON file.

- `jsonFile` (string): The path to the JSON file containing utility function definitions.

### `calculateUtilities()`

Calculates utilities for all utility functions.

- Returns: A table of utility values, and the total utility.

### `makeDecision()`

Makes a decision based on the calculated utilities.

- Returns: The action associated with the best utility. If total utility is zero, a small value is used to avoid division by zero.

## JSON Structure for DecisionAgent

The JSON file used to define utility functions should follow this structure:

```json
[
    {
        "name": "ActionName",
        "parameter": "parameterName",
        "curve": "curveType",
        "scale": 1.0,
        "weight": 1.0,
        "normalize": true,
        "aggregate": "AGGREGATION_TYPE",
        "childFunctions": [
            {
                "name": "ChildActionName",
                "parameter": "childParameterName",
                "curve": "childCurveType",
                "scale": 1.0,
                "weight": 1.0,
                "normalize": true
            }
        ]
    }
]
```
- `name`: The name of the action.
- `parameter`: The parameter used for the action.
- `curve`: The type of curve used.
- `scale`: The scale factor.
- `weight`: The weight of the utility function.
- `normalize`: A boolean indicating whether the utility should be normalized.
- `aggregate`: The aggregation type used (e.g., "SUM", "AVERAGE").
- `childFunctions`: An array of child functions, following the same structure as the parent.
