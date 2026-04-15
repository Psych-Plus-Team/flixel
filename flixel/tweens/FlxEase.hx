package flixel.tweens;

/**
 * Static class with useful easer functions that can be used by tweens.
 *
 * Operation of in/out easers:
 *
 * - **in(t)**:
 *
 *       return t;
 *
 * - **out(t)**
 *
 *       return 1 - in(1 - t);
 *
 * - **inOut(t)**
 *
 *       return (t <= .5) ? in(t * 2) / 2 : out(t * 2 - 1) / 2 + .5;
 */
class FlxEase
{
	/** Easing constants */
	static var PI2:Float = Math.PI / 2;

	static var EL:Float = 2 * Math.PI / .45;
	static var B1:Float = 1 / 2.75;
	static var B2:Float = 2 / 2.75;
	static var B3:Float = 1.5 / 2.75;
	static var B4:Float = 2.5 / 2.75;
	static var B5:Float = 2.25 / 2.75;
	static var B6:Float = 2.625 / 2.75;
	static var ELASTIC_AMPLITUDE:Float = 1;
	static var ELASTIC_PERIOD:Float = 0.4;

	static inline function sampleCurveX(t:Float, x1:Float, x2:Float):Float
	{
		final invT = 1 - t;
		return 3 * x1 * invT * invT * t + 3 * x2 * invT * t * t + t * t * t;
	}

	static inline function sampleCurveY(t:Float, y1:Float, y2:Float):Float
	{
		final invT = 1 - t;
		return 3 * y1 * invT * invT * t + 3 * y2 * invT * t * t + t * t * t;
	}

	static inline function sampleCurveDerivativeX(t:Float, x1:Float, x2:Float):Float
	{
		return 3 * x1 * (-3 * t * t + 4 * t - 1) + 3 * x2 * (-3 * t * t + 2 * t);
	}

	static function solveCurveX(t:Float, x1:Float, x2:Float):Float
	{
		var x = t;

		for (_ in 0...6)
		{
			final dx = sampleCurveX(x, x1, x2) - t;
			final d = sampleCurveDerivativeX(x, x1, x2);
			if (Math.abs(d) < 1e-6)
				break;
			x -= dx / d;
		}

		return x;
	}

	static inline function cubicBezier(t:Float, x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		final x = solveCurveX(t, x1, x2);
		return sampleCurveY(x, y1, y2);
	}

	/** @since 4.3.0 */
	public static inline function linear(t:Float):Float
	{
		return t;
	}

	public static inline function standard(t:Float):Float
	{
		return cubicBezier(t, 0.2, 0.0, 0.0, 1.0);
	}

	public static inline function decelerate(t:Float):Float
	{
		return cubicBezier(t, 0.0, 0.0, 0.0, 1.0);
	}

	public static inline function accelerate(t:Float):Float
	{
		return cubicBezier(t, 0.3, 0.0, 1.0, 1.0);
	}

	public static inline function emphasizedDecelerate(t:Float):Float
	{
		return cubicBezier(t, 0.05, 0.7, 0.1, 1.0);
	}

	public static inline function emphasizedAccelerate(t:Float):Float
	{
		return cubicBezier(t, 0.3, 0.0, 0.8, 0.15);
	}

	public static inline function instant(t:Float):Float
	{
		return 1;
	}

	public static inline function tri(t:Float):Float
	{
		return 1 - Math.abs(2 * t - 1);
	}

	public static inline function bell(t:Float):Float
	{
		return quintInOut(tri(t));
	}

	public static inline function pop(t:Float):Float
	{
		return 3.5 * (1 - t) * (1 - t) * Math.sqrt(t);
	}

	public static inline function tap(t:Float):Float
	{
		return 3.5 * t * t * Math.sqrt(1 - t);
	}

	public static inline function pulse(t:Float):Float
	{
		return t < 0.5 ? tap(t * 2) : -pop(t * 2 - 1);
	}

	public static inline function bounce(t:Float):Float
	{
		return 4 * t * (1 - t);
	}

	public static inline function spike(t:Float):Float
	{
		return Math.exp(-10 * Math.abs(2 * t - 1));
	}

	public static inline function inverse(t:Float):Float
	{
		return t * t * (1 - t) * (1 - t) / (0.5 - t);
	}

	public static inline function quadIn(t:Float):Float
	{
		return t * t;
	}

	public static inline function quadOut(t:Float):Float
	{
		return -t * (t - 2);
	}

	public static inline function quadInOut(t:Float):Float
	{
		return t <= .5 ? t * t * 2 : 1 - (--t) * t * 2;
	}

	public static inline function quadOutIn(t:Float):Float
	{
		return t < 0.5 ? quadOut(t * 2) * 0.5 : quadIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInQuad(t:Float):Float
	{
		return quadOutIn(t);
	}

	public static inline function cubeIn(t:Float):Float
	{
		return t * t * t;
	}

	public static inline function cubeOut(t:Float):Float
	{
		return 1 + (--t) * t * t;
	}

	public static inline function cubeInOut(t:Float):Float
	{
		return t <= .5 ? t * t * t * 4 : 1 + (--t) * t * t * 4;
	}

	public static inline function cubicOutIn(t:Float):Float
	{
		return t < 0.5 ? cubeOut(t * 2) * 0.5 : cubeIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInCubic(t:Float):Float
	{
		return cubicOutIn(t);
	}

	public static inline function quartIn(t:Float):Float
	{
		return t * t * t * t;
	}

	public static inline function quartOut(t:Float):Float
	{
		return 1 - (t -= 1) * t * t * t;
	}

	public static inline function quartInOut(t:Float):Float
	{
		return t <= .5 ? t * t * t * t * 8 : (1 - (t = t * 2 - 2) * t * t * t) / 2 + .5;
	}

	public static inline function quartOutIn(t:Float):Float
	{
		return t < 0.5 ? quartOut(t * 2) * 0.5 : quartIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInQuart(t:Float):Float
	{
		return quartOutIn(t);
	}

	public static inline function quintIn(t:Float):Float
	{
		return t * t * t * t * t;
	}

	public static inline function quintOut(t:Float):Float
	{
		return (t = t - 1) * t * t * t * t + 1;
	}

	public static inline function quintInOut(t:Float):Float
	{
		return ((t *= 2) < 1) ? (t * t * t * t * t) / 2 : ((t -= 2) * t * t * t * t + 2) / 2;
	}

	public static inline function quintOutIn(t:Float):Float
	{
		return t < 0.5 ? quintOut(t * 2) * 0.5 : quintIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInQuint(t:Float):Float
	{
		return quintOutIn(t);
	}

	/** @since 4.3.0 */
	public static inline function smoothStepIn(t:Float):Float
	{
		return 2 * smoothStepInOut(t / 2);
	}

	/** @since 4.3.0 */
	public static inline function smoothStepOut(t:Float):Float
	{
		return 2 * smoothStepInOut(t / 2 + 0.5) - 1;
	}

	/** @since 4.3.0 */
	public static inline function smoothStepInOut(t:Float):Float
	{
		return t * t * (t * -2 + 3);
	}

	/** @since 4.3.0 */
	public static inline function smootherStepIn(t:Float):Float
	{
		return 2 * smootherStepInOut(t / 2);
	}

	/** @since 4.3.0 */
	public static inline function smootherStepOut(t:Float):Float
	{
		return 2 * smootherStepInOut(t / 2 + 0.5) - 1;
	}

	/** @since 4.3.0 */
	public static inline function smootherStepInOut(t:Float):Float
	{
		return t * t * t * (t * (t * 6 - 15) + 10);
	}

	public static inline function sineIn(t:Float):Float
	{
		return -Math.cos(PI2 * t) + 1;
	}

	public static inline function sineOut(t:Float):Float
	{
		return Math.sin(PI2 * t);
	}

	public static inline function sineInOut(t:Float):Float
	{
		return -Math.cos(Math.PI * t) / 2 + .5;
	}

	public static inline function sineOutIn(t:Float):Float
	{
		return t < 0.5 ? sineOut(t * 2) * 0.5 : sineIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInSine(t:Float):Float
	{
		return sineOutIn(t);
	}

	public static function bounceIn(t:Float):Float
	{
		return 1 - bounceOut(1 - t);
	}

	public static function bounceOut(t:Float):Float
	{
		if (t < B1)
			return 7.5625 * t * t;
		if (t < B2)
			return 7.5625 * (t - B3) * (t - B3) + .75;
		if (t < B4)
			return 7.5625 * (t - B5) * (t - B5) + .9375;
		return 7.5625 * (t - B6) * (t - B6) + .984375;
	}

	public static function bounceInOut(t:Float):Float
	{
		return t < 0.5
			? (1 - bounceOut(1 - 2 * t)) / 2
			: (1 + bounceOut(2 * t - 1)) / 2;
	}

	public static inline function bounceOutIn(t:Float):Float
	{
		return t < 0.5 ? bounceOut(t * 2) * 0.5 : bounceIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInBounce(t:Float):Float
	{
		return bounceOutIn(t);
	}

	public static inline function circIn(t:Float):Float
	{
		return -(Math.sqrt(1 - t * t) - 1);
	}

	public static inline function circOut(t:Float):Float
	{
		return Math.sqrt(1 - (t - 1) * (t - 1));
	}

	public static function circInOut(t:Float):Float
	{
		return t <= .5 ? (Math.sqrt(1 - t * t * 4) - 1) / -2 : (Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2;
	}

	public static inline function circOutIn(t:Float):Float
	{
		return t < 0.5 ? circOut(t * 2) * 0.5 : circIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInCirc(t:Float):Float
	{
		return circOutIn(t);
	}

	public static inline function expoIn(t:Float):Float
	{
		return Math.pow(2, 10 * (t - 1));
	}

	public static inline function expoOut(t:Float):Float
	{
		return -Math.pow(2, -10 * t) + 1;
	}

	public static function expoInOut(t:Float):Float
	{
		return t < .5 ? Math.pow(2, 10 * (t * 2 - 1)) / 2 : (-Math.pow(2, -10 * (t * 2 - 1)) + 2) / 2;
	}

	public static inline function expoOutIn(t:Float):Float
	{
		return t < 0.5 ? expoOut(t * 2) * 0.5 : expoIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInExpo(t:Float):Float
	{
		return expoOutIn(t);
	}

	public static inline function backIn(t:Float):Float
	{
		return t * t * (2.70158 * t - 1.70158);
	}

	public static inline function backOut(t:Float):Float
	{
		return 1 - (--t) * (t) * (-2.70158 * t - 1.70158);
	}

	public static function backInOut(t:Float):Float
	{
		t *= 2;
		if (t < 1)
			return t * t * (2.70158 * t - 1.70158) / 2;
		t--;
		return (1 - (--t) * (t) * (-2.70158 * t - 1.70158)) / 2 + .5;
	}

	public static inline function backOutIn(t:Float):Float
	{
		return t < 0.5 ? backOut(t * 2) * 0.5 : backIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInBack(t:Float):Float
	{
		return backOutIn(t);
	}

	public static inline function elasticIn(t:Float):Float
	{
		return -(ELASTIC_AMPLITUDE * Math.pow(2,
			10 * (t -= 1)) * Math.sin((t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD));
	}

	public static inline function elasticOut(t:Float):Float
	{
		return (ELASTIC_AMPLITUDE * Math.pow(2,
			-10 * t) * Math.sin((t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD)
			+ 1);
	}

	public static function elasticInOut(t:Float):Float
	{
		if (t < 0.5)
		{
			return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD));
		}
		return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD) * 0.5 + 1;
	}

	public static inline function elasticOutIn(t:Float):Float
	{
		return t < 0.5 ? elasticOut(t * 2) * 0.5 : elasticIn(t * 2 - 1) * 0.5 + 0.5;
	}

	public static inline function outInElastic(t:Float):Float
	{
		return elasticOutIn(t);
	}
}

typedef EaseFunction = Float->Float;
