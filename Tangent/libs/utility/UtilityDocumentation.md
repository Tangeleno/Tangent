<!--UtilityDocumentation-->

## Linear

#### Description

The linear function creates a straight line. The output increases at a constant rate as the input increases.

##### Parameters

- `input`: The value being passed into the function.
- `m`: The slope of the line. Determines how steep the line is.
- `b`: The y-intercept of the line. Determines where the line crosses the y-axis.

## Step

#### Description

The step function creates a curve that jumps from `base` to 1 at a specific input value (threshold).

##### Parameters

- `input`: The value being passed into the function.
- `base`: The base value of the step.
- `threshold`: The input value where the step occurs.

## Logarithmic

#### Description

The logarithmic function creates a curve that increases slowly at first and then gradually speeds up.

##### Parameters

- `input`: The value being passed into the function.
- `clamp`: The minimum value as the input approaches 0
- `base`: The base of the logarithm. Common values are e (natural logarithm) or 10.

## Exponential

#### Description

The exponential function creates a curve that increases slowly at first and then speeds up.

##### Parameters

- `input`: The value being passed into the function.
- `base`: The base of the exponential. If not provided, e is used.

## Quadratic

#### Description

The quadratic function creates a U-shaped or inverted U-shaped curve, depending on the parameters.

##### Parameters

- `input`: The value being passed into the function.
- `a`, `b`, `c`: Coefficients that define the curve's shape.

## Gaussian

#### Description

The Gaussian function creates a bell-shaped curve, often used to represent a normal distribution.

##### Parameters

- `input`: The value being passed into the function.
- `floor`: The floor of the function, a value between -1 and 1
- `mean`: The center of the bell curve.
- `sigma`: The width of the bell curve.

## Tanh

#### Description

The tanh function creates an S-shaped curve similar to the sigmoid but ranging from -1 to 1.

##### Parameters

- `input`: The value being passed into the function.

## Cosine

#### Description

The cosine function creates a wave-like curve that oscillates between positive and negative values.

##### Parameters

- `input`: The value being passed into the function.
- `frequency`: The number of oscillations.
- `amplitude`: The height of the oscillations.

## Sine

#### Description

The sine function creates a wave-like curve similar to cosine, starting at 0.

##### Parameters

- `input`: The value being passed into the function.
- `frequency`: The number of oscillations.
- `amplitude`: The height of the oscillations.

## Logistic

#### Description

The logistic function creates an S-shaped curve.

##### Parameters

- `input`: The value being passed into the function.
- `a`: Controls the steepness of the curve.

## Smoothstep

#### Description

The smoothstep function creates a smooth curve that starts slow, accelerates, and then slows down again. Can be a smooth or a smoother curve based on the degree.

##### Parameters

- `input`: The value being passed into the function.
- `degree`: The degree of smoothness; use 3 for smooth and 5 for smoother.

## Cubic

#### Description

The cubic function can create a variety of curve shapes depending on the parameters. It can have zero, one, or two inflection points.

##### Parameters

- `input`: The value being passed into the function.
- `a`, `b`, `c`, `d`: Coefficients that define the curve's shape.

## Linear Interpolation

#### Description

Linear interpolation is a method for estimating values between a series of points on a line. It is particularly useful for creating a smooth transition between a set of known data points. This method involves drawing straight lines between pairs of points and estimating values along these lines.

##### Parameters

- `input`: The input value for which the output is interpolated.
- `points`: An array of points defining the linear segments. Each point is typically an object or tuple representing coordinates (x, y).

#### Usage

The function interpolates the output value based on the `input` and the positions of the points in the `points` array. It finds the two points in the array that the input value falls between and then calculates the interpolated output linearly between these two points.

##### Example

Consider `points = [(0, 0), (1, 10), (2, 20)]`:

- If `input = 0.5`, the output is interpolated between the points (0, 0) and (1, 10), resulting in an output close to 5.
- If `input = 1.5`, the output is interpolated between the points (1, 10) and (2, 20), resulting in an output close to 15.

## Bezier Curves

#### Description

Bezier curves are parametric curves frequently used in computer graphics, animation, and related fields for modeling smooth and scalable curves. They are defined by a set of control points, with the number of points determining the curve's degree and complexity.

##### Parameters

- `input`: The parameter (typically between 0 and 1) representing the position along the curve.
- `points`: An array of control points defining the Bezier curve. The array length can be 3, 4, 5, 6, or 8, representing different degrees of the curve.

#### Usage

The function calculates the position on the Bezier curve corresponding to the `input` value using the specified control points. The control points define the shape and complexity of the curve.

- 3 points create a quadratic Bezier curve.
- 4 points create a cubic Bezier curve.
- 5, 6, or 8 points create higher-degree Bezier curves for more complex shapes.

The first and last points in the array are the start and end points of the curve, respectively, while the intermediate points define the curvature.

##### Example

Consider `points = [(0, 0), (0.5, 1), (1, 0)]` for a quadratic Bezier curve:

- An `input` value of 0.5 would calculate the point on the curve halfway along its length.

Bezier curves are extensively used for creating smooth and intricate paths in graphic design, animations, font design, and user interface elements.

#### Limitations

This implementation supports Bezier curves with 3 (quadratic), 4 (cubic), 5, 6, or 8 control points. Each increase in the number of points allows for more complex and nuanced curves but also increases the computational complexity.
