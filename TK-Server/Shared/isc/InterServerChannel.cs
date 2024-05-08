using Newtonsoft.Json;
using NLog.Targets;
using StackExchange.Redis;
using System;
using System.Text;

namespace Shared.isc
{
    public class InterServerChannel
    {
        public ISubscriber Subscriber { get; private set; }
        public string InstanceId { get; private set; }

        public InterServerChannel(ISubscriber db, string instId)
        {
            Subscriber = db;
            InstanceId = instId;
        }

        public void AddHandler<T>(Channel channel, EventHandler<InterServerEventArgs<T>> handler) where T : struct
        {
            Subscriber.Subscribe(channel.ToString(), (s, buff) =>
            {
                var message = JsonConvert.DeserializeObject<Message<T>>(Encoding.UTF8.GetString(buff));

                if (message.TargetInst != null && message.TargetInst != InstanceId)
                    return;

                handler.Invoke(this, new InterServerEventArgs<T>(message.InstId, message.Content));
            });
        }

        public void Publish<T>(Channel channel, T val, string target = null) where T : struct
        {
            var message = new Message<T>()
            {
                InstId = InstanceId,
                TargetInst = target,
                Content = val
            };
            var jsonMsg = JsonConvert.SerializeObject(message);
            Subscriber.PublishAsync(channel.ToString(), jsonMsg, CommandFlags.FireAndForget);
        }

        private struct Message<T> where T : struct
        {
            public T Content;
            public string InstId;
            public string TargetInst;
        }
    }
}
