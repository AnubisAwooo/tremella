use std::str::FromStr;

use rand::Rng;

fn hmac_sha512(key: &[u8], data: &[u8]) -> [u8; 64] {
    use sha2::digest::{FixedOutput, KeyInit, Update};
    let mut hasher = hmac::Hmac::<sha2::Sha512>::new_from_slice(&key).unwrap();
    hasher.update(&data);
    hasher.finalize_fixed().into()
}

fn main() {
    // 1. 打印出钱包导入格式(wallet import format (WIF))
    println!("1. Wallet Import Format (WIF)");
    {
        // 非压缩的私钥 生成 非压缩公钥 继而生成 地址
        // https://en.bitcoin.it/wiki/Wallet_import_format
        let secret = "0c28fca386c7a227600b2fe50b7cae11ec86d3bf1fbe471be89827e19d72aa1d"; // 私钥 256 bit 随机数
        let secret_bytes = hex::decode(format!("80{secret}")).unwrap(); // ? 第一次 hash 要加前缀 80
        let hash_first = sha256::digest(&secret_bytes);
        println!("WIF: hash_first: {}", hash_first);
        let hash_second = sha256::digest(&hex::decode(hash_first).unwrap());
        println!("WIF: hash_second: {}", hash_second);
        // 80 代表比特币主网 ef 代表比特币测试网
        // 末尾 4 字节是 2 次 hash 后的校验码
        let extended_key = format!("{}{}{}", "80", secret, &hash_second[0..8]); // ? 80 + 私钥 + 校验码
        println!("WIF: extended_key: {}", extended_key);
        let encoded = bs58::encode(hex::decode(extended_key).unwrap()).into_string();
        println!("WIF: {}", encoded);
    }
    {
        // 压缩的私钥 生成 压缩公钥 继而生成 地址 （和非压缩有区别）
        // 只是钱包客户端在使用这两种格式的私钥的方式不同，具体的私钥其实是同一个，生成的公钥不同，上链的数据也就不同。
        // 之所以称为压缩私钥，具体指的是，上链的哪部分数据（公钥）确实是压缩了的。
        // https://zhuanlan.zhihu.com/p/21298725
        let secret = "e8d96a53e9c597e5a1e2ceaddd0b5ebe75588b26e71846b46a9b5f3666409355"; // 私钥 256 bit 随机数
        let secret_bytes = hex::decode(format!("80{secret}01")).unwrap(); // ? 第一次 hash 要加前缀 80 和 尾部压缩标识 01
        let hash_first = sha256::digest(&secret_bytes);
        println!("WIF: hash_first: {}", hash_first);
        let hash_second = sha256::digest(&hex::decode(hash_first).unwrap());
        println!("WIF: hash_second: {}", hash_second);
        // 末尾再加上 01 表示是压缩公钥的私钥
        let extended_key = format!("{}{}{}{}", "80", secret, "01", &hash_second[0..8]); // ? 80 + 私钥 + 01 + 校验码
        let encoded = bs58::encode(hex::decode(extended_key).unwrap()).into_string();
        println!("WIF Compressed: {}", encoded);
    }
    println!();

    // 2. bip 32 43
    // bip 32 确定分层钱包的衍生方式
    // bip 44 给出明确的路径 m/purpose'/coin'/account'/change/address_index
    // m 是固定的 强化衍生的意思 M 是公钥 普通衍生
    // Purpose 也是固定的，值为 44（或者 0x8000002C）因为 bip44
    // Coin type 这个代表的是币种，0 代表比特币，1 代表比特币测试链，60 代表以太坊 https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    // Account 代表这个币的账户索引，从 0 开始
    // Account 代表这个币的账户索引，从 0 开始s
    // Change 常量 0 用于外部链，常量 1 用于内部链（也称为更改地址）。外部链用于在钱包外可见的地址（例如，用于接收付款）。内部链用于在钱包外部不可见的地址，用于返回交易变更。 (所以一般使用 0)
    // address_index 这就是地址索引，从 0 开始，代表生成第几个地址，官方建议，每个 account 下的

    // 3. bip39 got mnemonic
    println!("3. bip39 got mnemonic");
    {
        // 8 * 32 = 256 bit
        // 助记词 2048 个（2^11）11bit
        // 11 * 24 = 264 bit
        let mut entropy: [u8; 32] = [0; 32]; // 熵
        rand::thread_rng().fill(&mut entropy);
        let mnemonic =
            bip39::Mnemonic::from_entropy_in(bip39::Language::English, &entropy).unwrap();
        println!(
            "mnemonic: {} {}",
            mnemonic.word_count(),
            mnemonic.words().collect::<Vec<_>>().join(" ")
        );

        let words = bip39::Language::word_list(bip39::Language::English);
        let mut extends: Vec<u8> = Vec::new();
        extends.extend(&entropy[..]); // 256
        let hash = sha256::digest(&extends);
        println!("mnemonic: hash {}", hash);
        extends.push(hex::decode(hash).unwrap()[0]); // 8
        let extends = extends
            .iter()
            .map(|n| format!("{:08b}", n))
            .collect::<Vec<_>>()
            .join("");
        println!("mnemonic: extends {} {}", extends.len(), extends);
        let extends = extends.chars().collect::<Vec<_>>();
        let extends = extends.chunks(11).collect::<Vec<_>>();
        let extends = extends
            .iter()
            .map(|ns| {
                let mut index: u32 = 0;
                for c in ns.iter() {
                    index <<= 1;
                    if *c == '1' {
                        index |= 1;
                    }
                }
                words[index as usize]
            })
            .collect::<Vec<_>>();
        println!("mnemonic: {} {}", extends.len(), extends.join(" "));
    }
    println!();

    // 4. bip39 mnemonic -> seed
    println!("4. bip39 mnemonic -> seed");
    {
        let mnemonic = "ready stumble dish media layer clutch yard either figure tonight fork control sudden assault angry school exclude code match awake man coil attack vacuum";
        let extends = mnemonic.split(" ").collect::<Vec<_>>();
        let mnemonic = bip39::Mnemonic::from_str(mnemonic).unwrap();

        println!(
            "mnemonic: {} {}",
            mnemonic.word_count(),
            mnemonic.words().collect::<Vec<_>>().join(" ")
        );
        let seed = mnemonic.to_seed("123456");
        println!("seed: {}", hex::encode(seed));

        // 使用 pbkdf2 库
        let mut key1 = [0u8; 64];
        pbkdf2::pbkdf2_hmac::<sha2::Sha512>(
            extends.join(" ").as_bytes(),
            &format!("mnemonic{}", "123456").as_bytes(),
            2048,
            &mut key1,
        );
        println!("seed: {}", hex::encode(&key1[..64]));

        // 自己计算
        fn xor(res: &mut [u8], salt: &[u8]) {
            res.iter_mut().zip(salt.iter()).for_each(|(a, b)| *a ^= b);
        }
        let mnemonic = extends.join(" ");
        let salt = {
            let mut salt: Vec<u8> = Vec::from_iter(b"mnemonic".iter().map(|b| *b));
            salt.extend(b"123456");
            salt.extend([0, 0, 0, 1]);
            salt
        };
        let mut salt = hmac_sha512(&mnemonic.as_bytes(), &salt);
        let mut seed = [0; 64];
        xor(&mut seed, &salt);
        for _ in 1..2048 {
            salt = hmac_sha512(&mnemonic.as_bytes(), &salt);
            xor(&mut seed, &salt);
        }
        println!("seed: {}", hex::encode(seed));
    }
    println!();

    // 5. bip44 seed -> main secret (hd wallet)
    println!("5. bip44 seed -> main secret (hd wallet)");
    {
        let mnemonic = "ready stumble dish media layer clutch yard either figure tonight fork control sudden assault angry school exclude code match awake man coil attack vacuum";
        let mnemonic = bip39::Mnemonic::from_str(mnemonic).unwrap();
        println!(
            "mnemonic: {} {}",
            mnemonic.word_count(),
            mnemonic.words().collect::<Vec<_>>().join(" ")
        );
        let seed = mnemonic.to_seed("123456");
        println!("seed: {}", hex::encode(seed));

        // m/44'/0'/0'/0/0

        // let main_result = hmac_sha512(b"Bitcoin seed", &seed);
        // let main_secret = &main_result[..32];
        // let main_chain_code = &main_result[32..];

        let main_result = hmac_sha512(
            b"Bitcoin seed",
            &hex::decode("000102030405060708090a0b0c0d0e0f").unwrap(),
        );
        let main_secret = &main_result[..32];
        println!("main_secret: {}", hex::encode(&main_secret));
        let main_chain_code = &main_result[32..];
        println!("main_chain_code: {}", hex::encode(&main_chain_code));

        let pk = hdwallet::extended_key::ExtendedPrivKey::with_seed(
            &hex::decode("000102030405060708090a0b0c0d0e0f").unwrap(),
        )
        .unwrap();
        println!("000: {}", hex::encode(&pk.private_key.as_ref()));
        println!("000: {}", hex::encode(&pk.chain_code));
        let pk1 = pk
            .derive_private_key(hdwallet::KeyIndex::Hardened(1 << 31 + 0))
            .unwrap();
        let pk = pk1.private_key.as_ref();
        println!("111: {}", hex::encode(&pk));

        let base = bs58::decode(b"xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7");
        println!("222: {}", hex::encode(&base.into_vec().unwrap()));

        // 111: edb2e14f9ee77d26dd93b4ecede8d16ed408ce149b6cd80b0715a2d911a0afea
        // 222: 0488ade4013442193e8000000047fdacbd0f1097043b78c63c20c34ef4ed9a111d980047ad16282c7ae623614100edb2e14f9ee77d26dd93b4ecede8d16ed408ce149b6cd80b0715a2d911a0afea0a794dec
        // 222: 04
        //      88ade4013442193e8000000047fdacbd0f1097043b78c63c20c34ef4ed9a111d
        //      980047ad16282c7ae623614100edb2e14f9ee77d26dd93b4ecede8d16ed408ce
        //      149b6cd80b0715a2d911a0afea0a794dec
    }
    println!();

    // 2. 通过私钥计算公钥

    // 3. 计算比特币地址
}
