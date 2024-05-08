using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Encodings;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.OpenSsl;
using System;
using System.IO;
using System.Text;

namespace WorldServer.networking
{
    public class RSA
    {
        public static readonly RSA Instance = new RSA(
@"-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQDTa2VXtjKzQ8HO2hCRuXZPhezl0HcWdO0QxUhz1b+N5xJIXjvP
GYpawLnJHgVgjcTI4dqDW9sthI3hEActKdKV6Zm/dpPMuCvgEXq1ajOcr8WEX+pD
ji5kr9ELH0iZjjlvgfzUiOBI6q4ba3SRYiAJFgOoe1TCC1sDk+rDZEPcMwIDAQAB
AoGBAKB+m81NFAoAOuVjp0Zoy0atPVxst6rFkp2zlj/RGPyJWNi1KKQcGGqyeZcS
gjR9CtEQm0gy+B0Czo33E+uWHzSrh80lvmYxeHVgPfnyKf1bfCRvYdmm5YsWnvhV
Dsif5kC8BWfH9wxdmY3Li7UC38kzcqzYAbpMhBDFMtDh/xIJAkEA6uwmAbXk3sth
9GibetDdudJDSk2Xbf10GF2aiRlfHeKCj5OPwR/3rI0RBVcuA9LAPuYgWIJHEvWa
goQmjFI6RwJBAOZjaqd8ljbmhDEsQBrIxU2IBRLND8hJlmH/dSfkfq6GaptYtLdf
o7/caVCIDdmotNsmcUfiGIM9GR55DI0GGLUCQQCNtJzIc1v3OF+B+oeu8caNjFOi
wmMRqc0Z1XyeLnu9nyB6Utxn9kyD/SPDQO80xy/HwTDJsuwEd7oX+Hb4NbGJAkAC
dfVhrJb+JyAqVkqo/pP87AMB3GbawM52ZYAe2PXxb0YcOqpTexYIqpYFYi6jsIWe
AZ8cIXIZlMF77dcQeowxAkEAgCEggW6P+y0GKQDazGQiFEbq/tmu7vw/YqTnmEbP
aaLMuU/Y0INAj0MidC1vxVhS69+ceUK9WDxuAGULPYDYNw==
-----END RSA PRIVATE KEY-----"
        );

        private readonly AsymmetricKeyParameter key;
        private RsaEngine engine;

        private RSA(string privPem)
        {
            key = (new PemReader(new StringReader(privPem.Trim())).ReadObject() as AsymmetricCipherKeyPair).Private;
            engine = new RsaEngine();
            engine.Init(true, key);
        }

        public string Decrypt(string str)
        {
            if (string.IsNullOrEmpty(str)) return "";
            byte[] dat = Convert.FromBase64String(str);
            var encoding = new Pkcs1Encoding(engine);
            encoding.Init(false, key);
            return Encoding.UTF8.GetString(encoding.ProcessBlock(dat, 0, dat.Length));
        }

        public string Encrypt(string str)
        {
            if (string.IsNullOrEmpty(str)) return "";
            byte[] dat = Encoding.UTF8.GetBytes(str);
            var encoding = new Pkcs1Encoding(engine);
            encoding.Init(true, key);
            return Convert.ToBase64String(encoding.ProcessBlock(dat, 0, dat.Length));
        }
    }
}
