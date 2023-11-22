package haxepunk.tweens.misc;

import haxepunk.FramePerfectTween;
import haxepunk.Tween;

/**
 * A simple alarm, useful for timed events, etc.
 */
class FramePerfectAlarm extends FramePerfectTween
{
	/**
	 * Constructor.
	 * @param	duration	Duration of the alarm.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(durationInFrames:Int, ?complete:Void -> Void, ?type:TweenType)
	{
		super(durationInFrames, type, complete);
	}

	/**
	 * Sets the alarm.
	 * @param	duration	Duration of the alarm.
	 */
	public function reset(durationInFrames:Int)
	{
		_targetInFrames = durationInFrames;
		start();
	}

	/**
	 * How much time has passed since reset.
	 */
	public var elapsed(get, never):Float;
	function get_elapsed():Float return _timeInFrames;

	/**
	 * Current alarm duration.
	 */
	public var duration(get, never):Float;
	function get_duration():Float return _targetInFrames;

	/**
	 * Time remaining on the alarm.
	 */
	public var remaining(get, never):Float;
	function get_remaining():Float return _targetInFrames - _timeInFrames;
}

