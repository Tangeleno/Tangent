export interface Point {
    x: number;
    y: number;
}
export class Curve {
    static GenerateLinearCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        function linearFunction(x: number, m: number, b: number): number {
            return m * x + b;
        }


        const points = [] as Point[];
        if (curveData.m == null || curveData.b == null) {
            return points;
        }
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            let y = linearFunction(x, curveData.m, curveData.b);

            // Scale y to fit in the range -1 to 1
            y = Math.max(-1, Math.min(1, y));

            points.push({ x, y });
        }

        return points;
    }

    static GenerateStepCurvePoints(minXRange: number, maxXRange: number, curveData: any): { x: number; y: number }[] {
        const base = curveData.base;
        const threshold = curveData.threshold;

        // Ensure threshold is within the x-axis range
        const validThreshold = Math.max(minXRange, Math.min(maxXRange, threshold));

        // Points for the step curve
        const points = [
            { x: minXRange, y: base }, // Start point
            { x: validThreshold, y: base }, // Step start
            { x: validThreshold, y: 1 }, // Step end
            { x: maxXRange, y: 1 }, // End point
        ];

        return points;
    }

    static GenerateLogarithmicCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        function computeLogValue(input: number, base: number): number {
            base = base || Math.E;
            if (input <= 0) {
                return curveData.clamp;
            }
            return Math.log(input) / Math.log(base);
        }

        function scaleLogarithmicValue(input: number, minLogValue: number, maxLogValue: number): number {
            const logValue = computeLogValue(input, curveData.base);
            const adjustedMaxLogValue = Math.max(maxLogValue, Number.EPSILON);
            let scaledValue = ((logValue - minLogValue) / (adjustedMaxLogValue - minLogValue)) * 2 - 1;
            return Math.min(Math.max(scaledValue, curveData.clamp), 1); // Ensure y-values never fall below the clamp value
        }

        const points = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        let minLogValue = Infinity;
        let maxLogValue = -Infinity;
        for (let x = minXRange; x <= maxXRange; x += stepSize) {
            const logValue = computeLogValue(x, curveData.base);
            minLogValue = Math.min(minLogValue, logValue);
            maxLogValue = Math.max(maxLogValue, logValue);
        }

        // You may adjust or remove this cap based on your specific requirements
        maxLogValue = Math.min(maxLogValue, 10);

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const y = scaleLogarithmicValue(x, minLogValue, maxLogValue);
            points.push({ x, y });
        }

        return points;
    }


    // Function to generate points for the exponential curve
    static GenerateExponentialCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints = 200) {
        function scaleExponentialValue(input: number, minExpValue: number, maxExpValue: number) {
            // Scale exponential value to fit within -1 to 1 range
            return ((input - minExpValue) / (maxExpValue - minExpValue)) * 2 - 1;
        }

        const points = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Find the minimum and maximum exponential values in the range
        let minExpValue = Infinity;
        let maxExpValue = -Infinity;
        for (let x = minXRange; x <= maxXRange; x += stepSize) {
            const expValue = Math.pow(curveData.base, x);
            minExpValue = Math.min(minExpValue, expValue);
            maxExpValue = Math.max(maxExpValue, expValue);
        }

        // Consider adjusting maxExpValue if it's excessively large
        if (maxExpValue > 10) {
            // Adjust this threshold as needed
            maxExpValue = 10; // Cap it to a reasonable value
        }

        // Scale the exponential values to fit within -1 to 1
        const scale = Math.max(Math.abs(minExpValue), Math.abs(maxExpValue));
        minExpValue = -scale;
        maxExpValue = scale;

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            let y = scaleExponentialValue(Math.pow(curveData.base, x) - Math.pow(curveData.base, minXRange), minExpValue, maxExpValue);

            // Clamp y-value to ensure it's within -1 to 1
            y = Math.min(Math.max(y, -1), 1);

            points.push({ x, y });
        }

        return points;
    }
    static GenerateQuadraticCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints = 200) {
        const points = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);
        const midXRange = minXRange + (maxXRange - minXRange) / 2;

        // Function to shift and normalize x-values (so that the curve's vertex is at midXRange)
        function normalizeAndShiftX(x: number) {
            return ((x - midXRange) / (maxXRange - minXRange)) * 2;
        }

        // Function to scale y-values
        function scaleY(y: number) {
            const scaledY = y * 2; // Scale to range -1 to 1
            return Math.min(Math.max(scaledY, -1), 1); // Clamp minimum to -1 and max 1
        }

        // Calculate the quadratic function values and scale them
        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const shiftedAndNormalizedX = normalizeAndShiftX(x);
            const y = curveData.a * shiftedAndNormalizedX * shiftedAndNormalizedX + curveData.b * shiftedAndNormalizedX + curveData.c;
            const scaledY = scaleY(y);
            points.push({ x, y: scaledY });
        }

        return points;
    }

    static GenerateGaussianCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints = 200) {
        const points = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Function to calculate Gaussian y-value
        function gaussian(x: number, mean: number, sigma: number) {
            return Math.exp(-Math.pow(x - mean, 2) / (2 * Math.pow(sigma, 2)));
        }

        // Function to scale y-values
        function scaleY(y: number, minY: number, maxY: number) {
            return minY + y * (maxY - minY);
        }

        // Find the max y-value for scaling (Gaussian peak)
        const maxYValue = gaussian(curveData.mean, curveData.mean, curveData.sigma);

        // Calculate the Gaussian function values and scale them
        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const y = gaussian(x, curveData.mean, curveData.sigma);
            const scaledY = scaleY(y, curveData.floor, 1) / maxYValue; // Scaling the peak to 1
            points.push({ x, y: scaledY });
        }

        return points;
    }

    static GenerateTanhCurvePoints(minXRange: number, maxXRange: number, numberOfPoints = 200) {
        const points = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Function to scale x-values
        function scaleX(x: number, minX: number, maxX: number) {
            // Scaling x to fit the curve within the graph range
            const range = maxX - minX;
            return ((x - minX) / range) * 6 - 3; // Scale and shift to span a useful range of the tanh function
        }

        // Calculate the tanh function values
        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const scaledX = scaleX(x, minXRange, maxXRange);
            const y = Math.tanh(scaledX);
            points.push({ x, y });
        }

        return points;
    }

    static GenerateCosineCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        const points: { x: number; y: number }[] = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            // Normalize x to fit within a typical cosine wave period
            const normalizedX = (2 * Math.PI * curveData.frequency * (x - minXRange)) / (maxXRange - minXRange);
            // Calculate cosine value and adjust by amplitude
            const y = curveData.amplitude * Math.cos(normalizedX);
            // The cosine function naturally fits within the range -1 to 1, so no additional scaling is needed
            points.push({ x, y });
        }

        return points;
    }

    static GenerateSineCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        const points: { x: number; y: number }[] = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            // Normalize x to fit within a typical sine wave period
            const normalizedX = (2 * Math.PI * curveData.frequency * (x - minXRange)) / (maxXRange - minXRange);
            // Calculate sine value and adjust by amplitude
            const y = curveData.amplitude * Math.sin(normalizedX);
            // The sine function naturally fits within the range -1 to 1, so no additional scaling is needed
            points.push({ x, y });
        }

        return points;
    }

    static GenerateLogisticCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        const points: { x: number; y: number }[] = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Logistic function
        function logistic(x: number, a: number): number {
            return 1 / (1 + Math.exp(-a * x));
        }

        // Scale and center the x-values
        const midXRange = (minXRange + maxXRange) / 2;
        const rangeX = maxXRange - minXRange;

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const normalizedX = (2 * (x - midXRange)) / rangeX; // Normalize x to -1 to 1
            const y = logistic(normalizedX, curveData.a);
            // Scale y to -1 to 1 range
            const scaledY = 2 * (y - 0.5);
            points.push({ x, y: scaledY });
        }

        return points;
    }
    static GenerateSmoothstepCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        const points: { x: number; y: number }[] = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Normalize x to 0-1 range
        function normalizeX(x: number): number {
            return (x - minXRange) / (maxXRange - minXRange);
        }

        // Smoothstep function
        function smoothstep(x: number): number {
            if (curveData.degree === 3) {
                // Cubic smoothstep
                return x * x * (3 - 2 * x);
            } else if (curveData.degree === 5) {
                // Quintic smoothstep
                return x * x * x * (x * (x * 6 - 15) + 10);
            } else {
                // Default to linear if degree is not 3 or 5
                return x;
            }
        }

        for (let i = 0; i < numberOfPoints; i++) {
            const x = minXRange + i * stepSize;
            const normalizedX = normalizeX(x);
            const y = smoothstep(normalizedX);
            points.push({ x, y });
        }

        return points;
    }

    static GenerateCubicCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): { x: number; y: number }[] {
        const points: { x: number; y: number }[] = [];
        const stepSize = (maxXRange - minXRange) / (numberOfPoints - 1);

        // Function to scale and shift x-values
        function normalizeX(x: number): number {
            return ((x - minXRange) / (maxXRange - minXRange)) * 2 - 1; // Normalize x to -1 to 1
        }

        // Function to evaluate the cubic equation
        function cubic(x: number, a: number, b: number, c: number, d: number): number {
            return a * x * x * x + b * x * x + c * x + d;
        }

        // Function to scale y-values
        function scaleY(y: number, minY: number, maxY: number): number {
            const rangeY = maxY - minY;
            return minY + ((y + 1) / 2) * rangeY; // Scale y to fit within the graph's y-range
        }

        for (let i = 0; i < numberOfPoints; i++) {
            const rawX = minXRange + i * stepSize;
            const normalizedX = normalizeX(rawX);
            const rawY = cubic(normalizedX, curveData.a, curveData.b, curveData.c, curveData.d);
            const scaledY = scaleY(rawY, -1, 1);
            points.push({ x: rawX, y: scaledY });
        }

        return points;
    }
    static GenerateBezierCurvePoints(minXRange: number, maxXRange: number, curveData: any, numberOfPoints: number = 200): Point[] {
        const points: Point[] = [];
        const stepSize = 1 / (numberOfPoints - 1);
        const controlPointCount = curveData.controlPoints;
        if (!controlPointCount) {
            return points;
        }
        function bezierInterpolation(t: number, controlPoints: Point[]): number {
            let result = 0;
            const n = controlPoints.length - 1; // Number of control points minus 1
            controlPoints.forEach((point, i) => {
                result += binomialCoefficient(n, i) * Math.pow(1 - t, n - i) * Math.pow(t, i) * point.y;
            });
            return result;
        }

        function binomialCoefficient(n: number, k: number): number {
            let coeff = 1;
            for (let i = n - k; i < n; ++i) {
                coeff *= i + 1;
            }
            for (let i = 1; i <= k; ++i) {
                coeff /= i;
            }
            return coeff;
        }

        for (let i = 0; i < numberOfPoints; i++) {
            const t = i * stepSize;
            const y = bezierInterpolation(t, curveData.points.slice(0, controlPointCount));
            const x = minXRange + t * (maxXRange - minXRange); // Map t to the graph's x-range
            points.push({ x, y });
        }

        return points;
    }

    static GenerateLinearInterpolationPoints(minXRange: number, maxXRange: number, curveData: any): Point[] {
        const points: Point[] = [];
        if (!curveData.points || curveData.points.length === 0) {
            return points;
        }
    
        // Function to interpolate between two points
        function interpolate(x: number, point1: Point, point2: Point): number {
            if (point1.x === point2.x) return point1.y; // Prevent division by zero
            return point1.y + ((point2.y - point1.y) * (x - point1.x)) / (point2.x - point1.x);
        }
    
        // Function to clamp y value between -1 and 1
        function clampY(y: number): number {
            return Math.max(-1, Math.min(1, y));
        }
    
        // Create a copy of the points array and add the starting point at minXRange
        const interpolationPoints = [{ x: minXRange, y: clampY(curveData.base??0) }, ...curveData.points];
    
        // Iterate over each pair of points
        for (let i = 0; i < interpolationPoints.length - 1; i++) {
            const point1 = interpolationPoints[i];
            const point2 = interpolationPoints[i + 1];
    
            for (let x = point1.x; x < point2.x; x += (point2.x - point1.x) / 10) {
                const y = clampY(interpolate(x, point1, point2));
                points.push({ x, y });
            }
        }
    
        // Handle the endpoint at maxXRange
        const lastActualPoint = interpolationPoints[interpolationPoints.length - 1];
        if (maxXRange > lastActualPoint.x) {
            const endPointY = clampY(interpolate(maxXRange, interpolationPoints[interpolationPoints.length - 2], lastActualPoint));
            points.push({ x: maxXRange, y: endPointY });
        } else if (maxXRange === lastActualPoint.x) {
            points.push({ x: maxXRange, y: clampY(lastActualPoint.y) });
        }
    
        return points;
    }
    
}

export const ValueLookups = {
    MyHealth:{
        min:0,
        max:100
    },
    AverageGroupHealth:{
        min:0,
        max:100
    },
    Grouped:{
        min:0,
        max:1
    }
    ,
    GroupMembers:{
        min:0,
        max:5
    }
}

export const CurveTypes = {
    linear: {
        description: "The linear function creates a straight line. The output increases at a constant rate as the input increases.",
        parameters: {
            m: "The slope of the line. Determines how steep the line is.",
            b: "The y-intercept of the line. Determines where the line crosses the y-axis."
        }
    },
    step: {
        description: "The step function creates a curve that jumps from `base` to 1 at a specific input value (threshold).",
        parameters: {
            base: "The base value of the step.",
            threshold: "The input value where the step occurs."
        }
    },
    logarithmic: {
        description: "The logarithmic function creates a curve that increases slowly at first and then gradually speeds up.",
        parameters: {
            clamp: "The minimum value as the input approaches 0",
            base: "The base of the logarithm. Common values are e (natural logarithm) or 10."
        }
    },
    exponential: {
        description: "The exponential function creates a curve that increases slowly at first and then speeds up.",
        parameters: {
            base: "The base of the exponential. If not provided, e is used."
        }
    },
    quadratic: {
        description: "The quadratic function creates a U-shaped or inverted U-shaped curve, depending on the 'parameters'.",
        parameters: {
            a: "Coefficients that define the curve's shape.",
            b: "Coefficients that define the curve's shape.",
            c: "Coefficients that define the curve's shape."
        }
    },
    gaussian: {
        description: "The Gaussian function creates a bell-shaped curve, often used to represent a normal distribution.",
        parameters: {
            floor: "The floor of the function, a value between -1 and 1",
            mean: "The center of the bell curve.",
            sigma: "The width of the bell curve."
        }
    },
    tanh: {
        description: "The tanh function creates an S-shaped curve similar to the sigmoid but ranging from -1 to 1."
    },
    cosine: {
        description: "The cosine function creates a wave-like curve that oscillates between positive and negative values.",
        parameters: {
            frequency: "The number of oscillations.",
            amplitude: "The height of the oscillations."
        }
    },
    sine: {
        description: "The sine function creates a wave-like curve similar to cosine, starting at 0.",
        parameters: {
            frequency: "The number of oscillations.",
            amplitude: "The height of the oscillations."
        }
    },
    logistic: {
        description: "The logistic function creates an S-shaped curve.",
        parameters: {
            a: "Controls the steepness of the curve."
        }
    },
    smoothstep: {
        description: "The smoothstep function creates a smooth curve that starts slow, accelerates, and then slows down again. Can be a smooth or a smoother curve based on the degree.",
        parameters: { degree: "The degree of smoothness; use 3 for smooth and 5 for smoother." }
    },
    cubic: {
        description: "The cubic function can create a variety of curve shapes depending on the 'parameters'. It can have zero, one, or two inflection points.",
        parameters: {
            a: "Coefficients that define the curve's shape.",
            b: "Coefficients that define the curve's shape.",
            c: "Coefficients that define the curve's shape.",
            d: "Coefficients that define the curve's shape."
        }
    },
    lerp: {
        parameters: {
            base: "Initial Y value"
        }
    },
    bezier: {}
}
