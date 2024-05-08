using System;
using WorldServer.core.objects;

namespace WorldServer.core.net.stats
{
    public sealed class StatTypeValue<T>
    {
        private readonly StatDataType _type;
        private readonly bool _updateSelfOnly;

        private readonly Entity _owner;
        private readonly Func<T, T> _transform;
        private T _transformValue;
        private T _value;

        public StatTypeValue(Entity e, StatDataType type, T value, bool updateSelfOnly = false, Func<T, T> transform = null)
        {
            _owner = e;
            _type = type;
            _updateSelfOnly = updateSelfOnly;
            _transform = transform;
            _value = value;
            _transformValue = Transform(value);
        }

        public T GetValue() => _value;

        public void SetValue(T value)
        {
            if (_value != null && _value.Equals(value))
                return;

            _value = value;

            var tVal = Transform(value);

            if (_transformValue != null && _transformValue.Equals(tVal))
                return;

            _transformValue = tVal;

            // hacky fix to xp
            if (_owner is Player && _type == StatDataType.Experience)
                _owner.InvokeStatChange(_type, (int)(object)tVal - Player.GetLevelExp((_owner as Player).Level), _updateSelfOnly);
            else
                _owner.InvokeStatChange(_type, tVal, _updateSelfOnly);
        }

        public override string ToString() => _value.ToString();

        private T Transform(T value) => _transform == null ? value : _transform.Invoke(value);
    }
}
