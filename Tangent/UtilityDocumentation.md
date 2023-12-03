## Linear
#### Description
The linear function creates a straight line. The output increases at a constant rate as the input increases.

##### Parameters
- `input`: The value being passed into the function.
- `m`: The slope of the line. Determines how steep the line is.
- `b`: The y-intercept of the line. Determines where the line crosses the y-axis.

## Step
#### Description
The step function creates a curve that jumps from 0 to 1 at a specific input value (threshold).

##### Parameters
- `input`: The value being passed into the function.
- `threshold`: The input value where the step occurs.

## Logarithmic
#### Description
The logarithmic function creates a curve that increases slowly at first and then gradually speeds up.

##### Parameters
- `input`: The value being passed into the function.
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
- `mean`: The center of the bell curve.
- `sigma`: The width of the bell curve.

## Tanh
#### Description
The tanh function creates an S-shaped curve similar to the sigmoid but ranging from -1 to 1.

##### Parameters
- `input`: The value being passed into the function.

## Inverse
#### Description
The inverse function creates a curve that decreases as the input increases. The output is the reciprocal of the input.

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

## Cubic
#### Description
The cubic function can create a variety of curve shapes depending on the parameters. It can have zero, one, or two inflection points.

##### Parameters
- `input`: The value being passed into the function.
- `a`, `b`, `c`, `d`: Coefficients that define the curve's shape.

## Sinh
#### Description
The sinh function creates a curve that grows exponentially in both positive and negative directions.

##### Parameters
- `input`: The value being passed into the function.

## Cosh
#### Description
The cosh function creates a curve that grows exponentially in both directions but remains positive.

##### Parameters
- `input`: The value being passed into the function.

## Power
#### Description
The power function creates a curve that grows faster or slower than a linear curve, depending on the exponent.

##### Parameters
- `input`: The value being passed into the function.
- `exponent`: The power to which the input is raised.

## Absolute
#### Description
The absolute function creates a V-shaped curve. The output is always positive, reflecting the input across the y-axis if it's negative.

##### Parameters
- `input`: The value being passed into the function.

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
