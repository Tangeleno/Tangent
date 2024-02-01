<!--CurveFunctionality.md-->
## Custom Curve Functionality

### Overview
The custom curve functionality supports various types of curves including:
- **Linear**: A straight line between two points.
- **Bezier**: Complex curves defined by 3, 4, 5, 6, or 8 control points.

### Types of Bezier Curves
- **3 Points**: Quadratic Bezier curve.
- **4 Points**: Cubic Bezier curve.
- **5, 6, or 8 Points**: Higher-order Bezier curves with additional complexity and flexibility.

### JSON Structure
The JSON structure to represent the custom curves is as follows:

#### For Linear Curve
```json
 {
    "name": "myLinear Curve",
    "interpolation":"linear",
    "points": [
      [0,0],
      [1,1],
      [2,0]
    ]
  }
```
#### For Bezier Curve
```json
 {
    "name": "myLinear Curve",
    "interpolation":"bezier",
    "points": [
      [0,0],
      [1,1],
      [2,0]
    ]
  }
```
- `interpolation`: Specifies the type of curve (either "linear" or "bezier").
- `points`: An array of control points for the curve. The number of points should correspond to the type of Bezier curve (3, 4, 5, 6, or 8) or any number for linear curves.

### Importing from JSON
The custom curves can be imported from JSON using an appropriate parsing method, matching the JSON structure above.

### Notes
- For Bezier curves with 3, 4, 5, 6, or 8 points, the complexity of the curve increases with the number of control points.
- Ensure that the JSON structure aligns with the expected format for proper parsing.