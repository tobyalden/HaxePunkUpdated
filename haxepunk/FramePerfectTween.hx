package haxepunk;

import haxepunk.Tween;
import haxepunk.Signal.Signal0;
import haxepunk.ds.Maybe;
import haxepunk.utils.Ease.EaseFunction;

class FramePerfectTween extends Tween
{
	public function new(durationInFrames:Int, ?type:TweenType, ?complete:Void->Void, ?ease:EaseFunction)
	{
		super(999);
		if (durationInFrames < 0)
		{
			throw "Tween durationInFrames must be positive!";
		}
		_targetInFrames = durationInFrames;
		_type = type == null ? TweenType.Persist : type;
		_ease = ease;
		_t = 0;
		if (complete != null)
		{
			onComplete.bind(complete);
		}
	}

	override public function update(_:Float)
	{
		var isFinished = false;
		if (active)
		{
			_timeInFrames += 1;
			_t = percent;
			if (_t > 0 && _t < 1) _ease.may(function(f) _t = f(_t));
			if (_timeInFrames >= _targetInFrames)
			{
				_t = forward ? 1 : 0;
				isFinished = true;
			}
			updateInternal();
			onUpdate.invoke();
		}
		if (isFinished)
		{
			finish();
		}
	}

	override public function start()
	{
		_timeInFrames = 0;
		if (_targetInFrames == 0)
		{
			active = false;
			onComplete.invoke();
		}
		else
		{
			active = true;
			onStart.invoke();
		}
	}

	override function finish()
	{
		switch (_type)
		{
			case Persist:
				_timeInFrames = _targetInFrames;
				active = false;
			case Looping, PingPong:
				if (_type == PingPong) forward = !forward;
				start();
			case OneShot:
				_timeInFrames = _targetInFrames;
				cancel();
		}
		onComplete.invoke();

		if (_type == TweenType.OneShot)
		{
			onComplete.clear();
		}
	}

	override function get_percent():Float {
        return _targetInFrames == 0 ? 0 : (
            (forward ? _timeInFrames : (_targetInFrames - _timeInFrames)) / Std.parseFloat(Std.string(_targetInFrames))
        );
    }
	override function set_percent(value:Float):Float return _timeInFrames = Std.int(_targetInFrames * value);

	var _timeInFrames:Int = 0;
	var _targetInFrames:Int;
}
