# 解析比特币交易内容

# 1. 1输入 2输出 ============ P2PKH ============
# fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4
# https://mempool.space/api/tx/fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4
# https://blockchair.com/bitcoin/transaction/fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4
# 总长度 259 weight 1036
0100000001032e38e9c0a84c6046d687d10556dcacc41d275ec55fc00779ac88fdf357a187000000008c493046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1ebcc6028d9cdb1c3af7748014104f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f25f87c161bc6f8a630121df2b3d3ffffffff0200e32321000000001976a914c398efa9c392ba6013c5e04ee729755ef7f58b3288ac000fe208010000001976a914948c765a6914d43f2a7ac177da2c2f6b52de3d7c88ac00000000
# 下面分别解析
01000000                                                                                                                                           # 版本 1 小端法 其实是 00000001
01                                                                                                                                                 # 输入 1 个
032e38e9c0a84c6046d687d10556dcacc41d275ec55fc00779ac88fdf357a187                                                                                   # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 87a157f3fd88ac7907c05fc55e271dc4acdc5605d187d646604ca8c0e9382e03
00000000                                                                                                                                           # 第 0 个输出
8c                                                                                                                                                 # 解锁脚本长度 140 字节 前一份输出是 p2pkh
49                                                                                                                                                 # OP_PUSHBYTES_73 推入 73 字节
3046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1ebcc6028d9cdb1c3af774801 # 这是签名数据
41                                                                                                                                                 # OP_PUSHBYTES_65 推入 65 字节
04f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f25f87c161bc6f8a630121df2b3d3                 # 这是公钥
ffffffff                                                                                                                                           # 这是 sequence 不知道干嘛用的
02                                                                                                                                                 # 输出 2 个
00e3232100000000                                                                                                                                   # 金额, 注意小端法, 其实是 000000002123e300, 也就是 556000000 satosh 5.56 BTC
19                                                                                                                                                 # 锁定脚本长度 25
76                                                                                                                                                 # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                                 # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                                 # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
c398efa9c392ba6013c5e04ee729755ef7f58b32                                                                                                           # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                                 # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                                 # OP_CHECKSIG 检查签名是否正确
000fe20801000000                                                                                                                                   # 金额, 注意小端法, 其实是 0000000108e20f00, 也就是 4444000000 satosh 44.44 BTC
19                                                                                                                                                 # 锁定脚本长度 25
76                                                                                                                                                 # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                                 # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                                 # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
948c765a6914d43f2a7ac177da2c2f6b52de3d7c                                                                                                           # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                                 # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                                 # OP_CHECKSIG 检查签名是否正确
00000000                                                                                                                                           # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# 2. 1输入 1输出  ============ P2PKH ============
# e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d
# https://mempool.space/api/tx/e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d
# https://blockchair.com/bitcoin/transaction/e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d
# 总长度 225 weight 900
01000000010b6072b386d4a773235237f64c1126ac3b240c84b917a3909ba1c43ded5f51f4000000008c493046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3014104a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbbffffffff0140420f00000000001976a91439aa3d569e06a1d7926dc4be1193c99bf2eb9ee088ac00000000
# 下面分别解析
01000000                                                                                                                                           # 版本 1 小端法 其实是 00000001
01                                                                                                                                                 # 输入 1 个
0b6072b386d4a773235237f64c1126ac3b240c84b917a3909ba1c43ded5f51f4                                                                                   # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b
00000000                                                                                                                                           # 第 0 个输出
8c                                                                                                                                                 # 解锁脚本长度 140 字节
49                                                                                                                                                 # OP_PUSHBYTES_73 推入 73 字节
3046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f301 # 这是签名数据
41                                                                                                                                                 # OP_PUSHBYTES_65 推入 65 字节
04a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbb                 # 这是公钥
ffffffff                                                                                                                                           # 这是 sequence 不知道干嘛用的
01                                                                                                                                                 # 输出 1 个
40420f0000000000                                                                                                                                   # 金额, 注意小端法, 其实是 00000000000f4240, 也就是 1000000 satosh 0.01 BTC
19                                                                                                                                                 # 锁定脚本长度 25
76                                                                                                                                                 # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                                 # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                                 # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
39aa3d569e06a1d7926dc4be1193c99bf2eb9ee0                                                                                                           # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                                 # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                                 # OP_CHECKSIG 检查签名是否正确
00000000                                                                                                                                           # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# 3. 0输入 1输出 Coinbase  ============ P2PK ============
# 8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87
# https://mempool.space/api/tx/8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87
# https://blockchair.com/bitcoin/transaction/8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87
# 总长度 135 weight 540
01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff08044c86041b020602ffffffff0100f2052a010000004341041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84ac00000000
# 下面分别解析
01000000                                                                                                                           # 版本 1 小端法 其实是 00000001
01                                                                                                                                 # 输入 1 个
0000000000000000000000000000000000000000000000000000000000000000                                                                   # 没有前置交易
ffffffff                                                                                                                           # 不需要指定第几个输出
08                                                                                                                                 # 解锁脚本长度 8 字节 这里不需要解锁
04                                                                                                                                 # OP_PUSHBYTES_4
4c86041b                                                                                                                           # 这是任意 4 字节数据
02                                                                                                                                 # OP_PUSHBYTES_2
0602                                                                                                                               # 这是任意 2 字节数据
ffffffff                                                                                                                           # 这是 sequence 不知道干嘛用的
01                                                                                                                                 # 输出 1 个
00f2052a01000000                                                                                                                   # 金额, 注意小端法, 其实是 000000012a05f200, 也就是 5000000000 satosh 50 BTC
43                                                                                                                                 # 锁定脚本长度 67
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 字节
041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84 # 这是公钥 # 说明是 p2pk 向公钥输出 # 这笔交易使用了 f3e6066078e815bb24db0dfbff814f738943bddaaa76f8beba360cfe2882480a
ac                                                                                                                                 # OP_CHECKSIG 检查签名是否正确
00000000                                                                                                                           # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# p2pk 如何解锁
483045022100b36f8a4692c2b9d46c0d2f3878e51187f145d44568d97ecbb281aaa6077bd83b02202f7505b4667a95d1de27f25a149263c272f5468891efce678663a0bfef406e5d01
48                                                                                                                                               # OP_PUSHBYTES_72 推入 72 字节
3045022100b36f8a4692c2b9d46c0d2f3878e51187f145d44568d97ecbb281aaa6077bd83b02202f7505b4667a95d1de27f25a149263c272f5468891efce678663a0bfef406e5d01 # 这就是签名数据
# 配合锁定脚本 即可解锁
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 字节
041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84 # 这是公钥 # 说明是 p2pk 向公钥输出 # 这笔交易使用了 f3e6066078e815bb24db0dfbff814f738943bddaaa76f8beba360cfe2882480a
ac                                                                                                                                 # OP_CHECKSIG 检查签名是否正确

# 4. 1 输入 2 输出  ============ P2PKH ============
# 45a38677e1be28bd38b51bc1a1c0280055375cdf54472e04c590a989ead82515
# https://mempool.space/api/tx/45a38677e1be28bd38b51bc1a1c0280055375cdf54472e04c590a989ead82515
# https://blockchair.com/bitcoin/transaction/45a38677e1be28bd38b51bc1a1c0280055375cdf54472e04c590a989ead82515
# 总长度 258 weight 1032
010000000126c384984f63446a4f2be8dd6531ba9837bd5f2c3d37403c5f51fb9192ee754e010000008b48304502210083af8324456f052ff1b2597ff0e6a8cce8b006e379a410cf781be7874a2691c2022072259e2f7292960dea0ffc361bbad0b861f719beb8550476f22ce0f82c023449014104f3ed46a81cba02af0593e8572a9130adb0d348b538c829ccaaf8e6075b78439b2746a76891ce7ba71abbcbb7ca76e8a220782738a6789562827c1065b0ce911dffffffff02c0dd9107000000001976a91463d4dd1b29d95ed601512b487bfc1c49d84d057988ac00a0491a010000001976a91465746bef92511df7b34abf71c162efb7ae353de388ac00000000
# 下面分别解析
01000000                                                                                                                                         # 版本 1 小端法 其实是 00000001
01                                                                                                                                               # 输入 1 个
26c384984f63446a4f2be8dd6531ba9837bd5f2c3d37403c5f51fb9192ee754e                                                                                 # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 4e75ee9291fb515f3c40373d2c5fbd3798ba3165dde82b4f6a44634f9884c326
01000000                                                                                                                                         # 第 1 个输出
8b                                                                                                                                               # 解锁脚本长度 139 字节
48                                                                                                                                               # OP_PUSHBYTES_72 推入 72 字节
304502210083af8324456f052ff1b2597ff0e6a8cce8b006e379a410cf781be7874a2691c2022072259e2f7292960dea0ffc361bbad0b861f719beb8550476f22ce0f82c02344901 # 这应该是签名
41                                                                                                                                               # OP_PUSHBYTES_65  推入 65 字节
04f3ed46a81cba02af0593e8572a9130adb0d348b538c829ccaaf8e6075b78439b2746a76891ce7ba71abbcbb7ca76e8a220782738a6789562827c1065b0ce911d               # 这应该是公钥
ffffffff                                                                                                                                         # 这是 sequence 不知道干嘛用的
02                                                                                                                                               # 输出 2 个
c0dd910700000000                                                                                                                                 # 金额, 注意小端法, 其实是 000000000791ddc0, 也就是 127000000 satosh 1.27 BTC
19                                                                                                                                               # 锁定脚本长度 25
76                                                                                                                                               # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                               # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                               # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
63d4dd1b29d95ed601512b487bfc1c49d84d0579                                                                                                         # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                               # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                               # OP_CHECKSIG 检查签名是否正确
00a0491a01000000                                                                                                                                 # 金额, 注意小端法, 其实是 000000011a49a000, 也就是 4736000000 satosh 47.36 BTC
19                                                                                                                                               # 锁定脚本长度 25
76                                                                                                                                               # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                               # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                               # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
65746bef92511df7b34abf71c162efb7ae353de3                                                                                                         # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                               # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                               # OP_CHECKSIG 检查签名是否正确
00000000                                                                                                                                         # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# P2PK 和 P2PKH 的特点是脚本最后是 OP_CHECKSIG 验证签名

# 5. 2 输入 2 输出 ============ P2SH ============
# b5dc37cdd06a93bfcddf49874504beef8d06dcfdc7bbf426a9362c7ac10160f1
# https://mempool.space/api/tx/b5dc37cdd06a93bfcddf49874504beef8d06dcfdc7bbf426a9362c7ac10160f1
# https://blockchair.com/bitcoin/transaction/b5dc37cdd06a93bfcddf49874504beef8d06dcfdc7bbf426a9362c7ac10160f1
# 总长度 1136 weight 4544
0200000002944f6b35e41372ee2b8e1fd4288f8bd2b836553d88847e5b7f2fa24456e2561130000000fde8010047304402205beae824976d30c817802e493233b29d1189b13031afc792801e6a7615433980022077c1b576fc314f1064dc1513988585932c5de888f797021bcea537a89f9d49ad014830450221009d2be4a84bd253fb2c7c8c6bd4d34e6fe703458d9c788d7f8e41215845bb505b022017e5daa66d64beddf438a6d6c11445a27bafd13fd7abbdefdf6e4df363f2375301473044022067a81035a5eaa525fd9f6b2e17878a7cded02e95551bda91b38b5689d7e61a74022042231be1abb71049b1d58f44701e893df202fcb65029f34c798fbcfd2cee9a9e014d0b01534104220936c3245597b1513a9a7fe96d96facf1a840ee21432a1b73c2cf42c1810284dd730f21ded9d818b84402863a2b5cd1afe3a3d13719d524482592fb23c88a3410465f553898d26fa1a829864d5974f8715ef3f6d94a91d41c4d23832c701110835300f20df7639c5a4bf5ef22607d89009ab1a572d19bd5a202cd4c3f409959d9d410472225d3abc8665cf01f703a270ee65be5421c6a495ce34830061eb0690ec27dfd1194e27b6b0b659418d9f91baec18923078aac18dc19699aae82583561fefe54104a24db5c0e8ed34da1fd3b6f9f797244981b928a8750c8f11f9252041daad7b2d95309074fed791af77dc85abdd8bb2774ed8d53379d28cd49f251b9c08cab7fc54aefffffffff007d10f665f3c3428dedd1e051255e2730f5e778474f50e1cbe02071fb689ca01000000fde8010047304402203864ec57854242d590799b33b0179ff90bd9450a265ae9a8de04e7addb82654f02200cdf0cd5d388a93eaef26931f1a5aec12bad1dc6c2c9fbf608cc67d800a48e8001483045022100873ba7c1bcbfe2a7c9c93b9dbb81faf2e6cb9316333a8af5254b2dde4061cf75022012de2e2c0c0e43caf61bee4510bbef5b20c229e90d3ae5e241a1ea67b5d7ebbc01473044022019b649ba17253df98d158e2d2dbad3aeaa7b102e19431d768e7ac63615638a7a022059b79d3f55e1c7c1aa31d533f51b32087446c0258946c7fa94c20f9d58ab8fe0014d0b01534104220936c3245597b1513a9a7fe96d96facf1a840ee21432a1b73c2cf42c1810284dd730f21ded9d818b84402863a2b5cd1afe3a3d13719d524482592fb23c88a3410465f553898d26fa1a829864d5974f8715ef3f6d94a91d41c4d23832c701110835300f20df7639c5a4bf5ef22607d89009ab1a572d19bd5a202cd4c3f409959d9d410472225d3abc8665cf01f703a270ee65be5421c6a495ce34830061eb0690ec27dfd1194e27b6b0b659418d9f91baec18923078aac18dc19699aae82583561fefe54104a24db5c0e8ed34da1fd3b6f9f797244981b928a8750c8f11f9252041daad7b2d95309074fed791af77dc85abdd8bb2774ed8d53379d28cd49f251b9c08cab7fc54aeffffffff0258f866000000000017a914ac0621a7390fa4daa69129a131e73ad663b8cf2c877dce03000000000017a91469f3769e72153aa4e5a808b894b5755b3324a9e18700000000
# 下面分别解析
02000000                                                                                                                                         # 版本 2 小端法 其实是 00000002
02                                                                                                                                               # 输入 2 个
944f6b35e41372ee2b8e1fd4288f8bd2b836553d88847e5b7f2fa24456e25611                                                                                 # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 1156e25644a22f7f5b7e84883d5536b8d28b8f28d41f8e2bee7213e4356b4f94
30000000                                                                                                                                         # 第 48 个输出 小端法 其实是 00000030 是 48
fd                                                                                                                                               # ? 不知道是啥
e801                                                                                                                                             # 解锁脚本长度 488 字节 01e8
00                                                                                                                                               # OP_0 这个貌似是一个 bug, 必须先推入一个 0
47                                                                                                                                               # OP_PUSHBYTES_71 推入 71 个字节
304402205beae824976d30c817802e493233b29d1189b13031afc792801e6a7615433980022077c1b576fc314f1064dc1513988585932c5de888f797021bcea537a89f9d49ad01   # 像是签名
48                                                                                                                                               # OP_PUSHBYTES_72 推入 72 个字节
30450221009d2be4a84bd253fb2c7c8c6bd4d34e6fe703458d9c788d7f8e41215845bb505b022017e5daa66d64beddf438a6d6c11445a27bafd13fd7abbdefdf6e4df363f2375301 # 像是签名
47                                                                                                                                               # OP_PUSHBYTES_71 推入 71 个字节
3044022067a81035a5eaa525fd9f6b2e17878a7cded02e95551bda91b38b5689d7e61a74022042231be1abb71049b1d58f44701e893df202fcb65029f34c798fbcfd2cee9a9e01   # 像是签名
4d                                                                                                                                               # OP_PUSHDATA2 4c是OP_PUSHDATA1 后面 1 个是长度 4d是OP_PUSHDATA2 后面 2 个是长度 4e是OP_PUSHDATA4 后面 4 个是长度
0b01                                                                                                                                             # 010b 表示后面 267 个字节都是推入的
# 下面就是赎回脚本
53                                                                                                                                               # OP_PUSHNUM_3 推入数字 3 前面 3 个一组
41                                                                                                                                               # OP_PUSHBYTES_65 推入 65 个字节
04220936c3245597b1513a9a7fe96d96facf1a840ee21432a1b73c2cf42c1810284dd730f21ded9d818b84402863a2b5cd1afe3a3d13719d524482592fb23c88a3               # 公钥
41                                                                                                                                               # OP_PUSHBYTES_65 推入 65 个字节
0465f553898d26fa1a829864d5974f8715ef3f6d94a91d41c4d23832c701110835300f20df7639c5a4bf5ef22607d89009ab1a572d19bd5a202cd4c3f409959d9d               # 公钥
41                                                                                                                                               # OP_PUSHBYTES_65 推入 65 个字节
0472225d3abc8665cf01f703a270ee65be5421c6a495ce34830061eb0690ec27dfd1194e27b6b0b659418d9f91baec18923078aac18dc19699aae82583561fefe5               # 公钥
41                                                                                                                                               # OP_PUSHBYTES_65 推入 65 个字节
04a24db5c0e8ed34da1fd3b6f9f797244981b928a8750c8f11f9252041daad7b2d95309074fed791af77dc85abdd8bb2774ed8d53379d28cd49f251b9c08cab7fc               # 公钥
54                                                                                                                                               # OP_PUSHNUM_4  推入数字 4 前面 4 个一组
ae                                                                                                                                               # OP_CHECKMULTISIG 验证多签 3/4
ffffffff                                                                                                                                         # 这是 sequence 不知道干嘛用的
f007d10f665f3c3428dedd1e051255e2730f5e778474f50e1cbe02071fb689ca                                                                                 # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 ca89b61f0702be1c0ef57484775e0f73e25512051eddde28343c5f660fd107f0
01000000                                                                                                                                         # 第 1 个输出 小端法 其实是 00000001 是 1
fd                                                                                                                                               # ? 不知道是啥
e801                                                                                                                                             # 解锁脚本长度 488 字节 01e8
00                                                                                                                                               # OP_0 这个貌似是一个 bug, 必须先推入一个 0
47                                                                                                                                               # OP_PUSHBYTES_71 推入 71 个字节
304402203864ec57854242d590799b33b0179ff90bd9450a265ae9a8de04e7addb82654f02200cdf0cd5d388a93eaef26931f1a5aec12bad1dc6c2c9fbf608cc67d800a48e8001   # 像是签名
48                                                                                                                                               # OP_PUSHBYTES_72 推入 72 个字节
3045022100873ba7c1bcbfe2a7c9c93b9dbb81faf2e6cb9316333a8af5254b2dde4061cf75022012de2e2c0c0e43caf61bee4510bbef5b20c229e90d3ae5e241a1ea67b5d7ebbc01 # 像是签名
47                                                                                                                                               # OP_PUSHBYTES_71 推入 71 个字节
3044022019b649ba17253df98d158e2d2dbad3aeaa7b102e19431d768e7ac63615638a7a022059b79d3f55e1c7c1aa31d533f51b32087446c0258946c7fa94c20f9d58ab8fe001   # 像是签名
4d                                                                                                                                               # OP_PUSHDATA2
0b01                                                                                                                                             # 010b 表示后面 267 个字节都是推入的
# 下面就是赎回脚本
53                                                                                                                                 # OP_PUSHNUM_3 推入数字 3 前面 3 个一组
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 个字节
04220936c3245597b1513a9a7fe96d96facf1a840ee21432a1b73c2cf42c1810284dd730f21ded9d818b84402863a2b5cd1afe3a3d13719d524482592fb23c88a3 # 公钥
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 个字节
0465f553898d26fa1a829864d5974f8715ef3f6d94a91d41c4d23832c701110835300f20df7639c5a4bf5ef22607d89009ab1a572d19bd5a202cd4c3f409959d9d # 公钥
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 个字节
0472225d3abc8665cf01f703a270ee65be5421c6a495ce34830061eb0690ec27dfd1194e27b6b0b659418d9f91baec18923078aac18dc19699aae82583561fefe5 # 公钥
41                                                                                                                                 # OP_PUSHBYTES_65 推入 65 个字节
04a24db5c0e8ed34da1fd3b6f9f797244981b928a8750c8f11f9252041daad7b2d95309074fed791af77dc85abdd8bb2774ed8d53379d28cd49f251b9c08cab7fc # 公钥
54                                                                                                                                 # OP_PUSHNUM_4  推入数字 4 前面 4 个一组
ae                                                                                                                                 # OP_CHECKMULTISIG 验证多签 3/4
ffffffff                                                                                                                           # 这是 sequence 不知道干嘛用的
02                                                                                                                                 # 输出 2 个
58f8660000000000                                                                                                                   # 金额, 注意小端法, 其实是 000000000066f858, 也就是 6748248 satosh 0.06748248 BTC
17                                                                                                                                 # 锁定脚本长度 23
a9                                                                                                                                 # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                 # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
ac0621a7390fa4daa69129a131e73ad663b8cf2c                                                                                           # 脚本 hash
87                                                                                                                                 # OP_EQUAL 判断是否相等 false 不判定失败
7dce030000000000                                                                                                                   # 金额, 注意小端法, 其实是 000000000003ce7d, 也就是 249469 satosh 0.00249469 BTC
17                                                                                                                                 # 锁定脚本长度 23
a9                                                                                                                                 # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                 # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
69f3769e72153aa4e5a808b894b5755b3324a9e1                                                                                           # 脚本 hash
87                                                                                                                                 # OP_EQUAL 判断是否相等 false 不判定失败
00000000                                                                                                                           # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# 6. 1 输入 1 输出 ============ P2WSH ============
# 6e5b3b34dfd43abc4781f85e7f6e10250a32b754eff607039be46eebe2e7a47a
# https://mempool.space/api/tx/6e5b3b34dfd43abc4781f85e7f6e10250a32b754eff607039be46eebe2e7a47a
# https://blockchair.com/bitcoin/transaction/6e5b3b34dfd43abc4781f85e7f6e10250a32b754eff607039be46eebe2e7a47a
# 总长度 217 weight 541
02000000000101f16001c17a2c36a926f4bbc7fddc068defbe04458749dfcdbf936ad0cd37dcb50000000017160014c0f8ef92734b92e304c941bc33f1eb0314bb5d76ffffffff01e0bb6600000000001976a914946780e976a0897f7fa4bc7a1e710b27cfa04b7b88ac0247304402203442e5e0d665d79f6091922fc8a5b173175c24e960d9f760edde31541a624598022019fea65e5747a5d2a4f3d26cb46f59c806e68873a0d939c6d7ea0e42e9920666012102fcfad56a5de34b6f8466c5f3e9891a6bd5b642e1d2064d9f1ebba83cd185e07f00000000
# 下面分别解析
02000000                                                                                                                                       # 版本 2 小端法 其实是 00000002
0001                                                                                                                                           # ? 这是啥 ?
01                                                                                                                                             # 输入 1 个
f16001c17a2c36a926f4bbc7fddc068defbe04458749dfcdbf936ad0cd37dcb5                                                                               # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 b5dc37cdd06a93bfcddf49874504beef8d06dcfdc7bbf426a9362c7ac10160f1
00000000                                                                                                                                       # 第 0 个输出
17                                                                                                                                             # 解锁脚本长度 23
16                                                                                                                                             # OP_PUSHBYTES_22 推入 22 字节
00                                                                                                                                             # OP_0 这个貌似是一个 bug, 必须先推入一个 0
14                                                                                                                                             # OP_PUSHBYTES_20 推入 20 字节
c0f8ef92734b92e304c941bc33f1eb0314bb5d76                                                                                                       # 赎回脚本签名
ffffffff                                                                                                                                       # 这是 sequence 不知道干嘛用的
01                                                                                                                                             # 输出 1 个
e0bb66000000                                                                                                                                   # 金额, 注意小端法, 其实是 000000000066bbe0, 也就是 6732768 satosh 0.06732768 BTC
0000                                                                                                                                           # ? 这是啥 ?
19                                                                                                                                             # 锁定脚本长度 25
76                                                                                                                                             # OP_DUP 复制上一份数据, 上个推入
a9                                                                                                                                             # OP_HASH160 将上份数据进行 Hash160
14                                                                                                                                             # OP_PUSHBYTES_20 推入 20 字节 # 说明是 p2pkh 向公钥Hash输出
946780e976a0897f7fa4bc7a1e710b27cfa04b7b                                                                                                       # 这是公钥 Hash 结果, 也是比特币地址 base58 解码后的结果
88                                                                                                                                             # OP_EQUALVERIFY 检查前 2 份数据是否相等
ac                                                                                                                                             # OP_CHECKSIG 检查签名是否正确
02                                                                                                                                             # 有 2 组隔离见证信息
47                                                                                                                                             # 长度 71
304402203442e5e0d665d79f6091922fc8a5b173175c24e960d9f760edde31541a624598022019fea65e5747a5d2a4f3d26cb46f59c806e68873a0d939c6d7ea0e42e992066601 # 71 字节
21                                                                                                                                             # 长度 33
02fcfad56a5de34b6f8466c5f3e9891a6bd5b642e1d2064d9f1ebba83cd185e07f                                                                             # 33 字节
00000000                                                                                                                                       # 解锁时间戳, 好像小于多少标识块高, 否则就是时间戳来着, 0 表示不限制

# 0247304402203442e5e0d665d79f6091922fc8a5b173175c24e960d9f760edde31541a624598022019fea65e5747a5d2a4f3d26cb46f59c806e68873a0d939c6d7ea0e42e9920666012102fcfad56a5de34b6f8466c5f3e9891a6bd5b642e1d2064d9f1ebba83cd185e07f

# 7. 1 输入 2 输出 ============ V1_P2TR ============
# bfdc91133634a1e7df01bdb505810e9e7084416581a9aa27dea49aa0090499c8
# https://mempool.space/api/tx/bfdc91133634a1e7df01bdb505810e9e7084416581a9aa27dea49aa0090499c8
# https://blockchair.com/bitcoin/transaction/bfdc91133634a1e7df01bdb505810e9e7084416581a9aa27dea49aa0090499c8
# 总长度 297 weight 672
010000000001017085a18931f53bdb77609dbc0402462bd63577c25081eda6f0d6de98f39617bd0100000000fdffffff022202000000000000160014d6092fd70da2da324f0710f72f1e9a7f427c75cb147c10010000000022512075b2f0c4a131bbef0d634c2d8bfc9d3f532a46bffb70fad064f966064e86cf0c0340e8f048b3e6dce32ff89f863f255e9e2b78725ce3e3cacb949f299aef2a7c6595f58c7d115bc0c3a47ccb37cac148785b0fea9feb43df00de2005652e53ea1201452073be53d7905d24366c5d45b39c9ae1129322196b6d9f1ed3d4f75f5574f2b96aac0063036f726401010a746578742f706c61696e000d3831383937382e6269746d61706821c173be53d7905d24366c5d45b39c9ae1129322196b6d9f1ed3d4f75f5574f2b96a00000000
# 下面分别解析
01000000                                                                                                                         # 版本 1 小端法 其实是 00000001
0001                                                                                                                             # ? 这是啥 ?
01                                                                                                                               # 输入 1 个
7085a18931f53bdb77609dbc0402462bd63577c25081eda6f0d6de98f39617bd                                                                 # 前面 UTXO 的交易序号, 注意小端写法, 反过来的, 实际上是 bd1796f398ded6f0a6ed8150c27735d62b460204bc9d6077db3bf53189a18570
01000000                                                                                                                         # 第 1 个输出
00                                                                                                                               # 解锁脚本长度 0 字节
fdffffff                                                                                                                         # 这是 sequence 不知道干嘛用的
02                                                                                                                               # 输出 2 个
2202000000000000                                                                                                                 # 金额, 注意小端法, 其实是 0000000000000222, 也就是 546 satosh 0.00000546 BTC
16                                                                                                                               # 锁定脚本长度 22
00                                                                                                                               # OP_0 这个貌似是一个 bug, 必须先推入一个 0
14                                                                                                                               # OP_PUSHBYTES_20 推入 20 字节 #
d6092fd70da2da324f0710f72f1e9a7f427c75cb                                                                                         # 见证脚本的 hash160 # 说明是 P2WPKH
147c100100000000                                                                                                                 # 金额, 注意小端法, 其实是 0000000001107c14, 也就是 17857556 satosh 0.17857556 BTC
22                                                                                                                               # 锁定脚本长度 34
51                                                                                                                               # OP_PUSHNUM_1
20                                                                                                                               # OP_PUSHBYTES_32 推入 32 字节 # 说明是 V1_P2TR
75b2f0c4a131bbef0d634c2d8bfc9d3f532a46bffb70fad064f966064e86cf0c                                                                 # 见证信息 hash256
03                                                                                                                               # 有 2 组隔离见证信息
40                                                                                                                               # 长度 64
e8f048b3e6dce32ff89f863f255e9e2b78725ce3e3cacb949f299aef2a7c6595f58c7d115bc0c3a47ccb37cac148785b0fea9feb43df00de2005652e53ea1201 # 估计是签名
45                                                                                                                               # 长度 69 额外的见证信息
20                                                                                                                               # OP_PUSHBYTES_32 推入 32 字节
73be53d7905d24366c5d45b39c9ae1129322196b6d9f1ed3d4f75f5574f2b96a
ac                                                                 # OP_CHECKSIG
00                                                                 # OP_0
63                                                                 # OP_IF
03                                                                 # OP_PUSHBYTES_3
6f7264                                                             # ord 字符
01                                                                 # OP_PUSHBYTES_1 推入 1 字节
01                                                                 # 推入 1
0a                                                                 # OP_PUSHBYTES_10 推入 10 字节
746578742f706c61696e                                               # text/plain
00                                                                 # OP_0
0d                                                                 # OP_PUSHBYTES_13
3831383937382e6269746d6170                                         # 818978.bitmap
68                                                                 # OP_ENDIF
21                                                                 # 长度 33
c173be53d7905d24366c5d45b39c9ae1129322196b6d9f1ed3d4f75f5574f2b96a # 估计是公钥
00000000

# P2WPKH V0_P2WPKH
# V0_P2WSH

# V1_P2TR

02000000
0001
04
d26a9d97256da4ffb6a8e5c953193843f9ebec450cc012d425fcadc68de52519
00000000
00
ffffffff
d26a9d97256da4ffb6a8e5c953193843f9ebec450cc012d425fcadc68de52519
01000000
00
ffffffff
c49c42cfe6254d846e1a32e98f2f7a6ca19055f188dd608d146041b82d27d838
00000000
00
ffffffff
d26a9d97256da4ffb6a8e5c953193843f9ebec450cc012d425fcadc68de52519
0a000000
00
ffffffff
07
b004000000000000
160014
098258438e25aee05d4b998df8f6e29720fd1ebb
2601000000000000
160014
098258438e25aee05d4b998df8f6e29720fd1ebb
3de3020000000000
160014
d6092fd70da2da324f0710f72f1e9a7f427c75cb
8b12000000000000
160014
c015c65276d5f38d599d445c4cb03aa7aa0dc365
5802000000000000
160014
098258438e25aee05d4b998df8f6e29720fd1ebb
5802000000000000
160014
098258438e25aee05d4b998df8f6e29720fd1ebb
1136630000000000
160014
098258438e25aee05d4b998df8f6e29720fd1ebb
02
48
3045022100ebd0ececdb4e9ccaa9fa2f0a6c6d48d1483e450ee5d23eec5d61edfc1f50d89402205ec6c9214278c2880eaf399fa81b66d2d7fe2089c83e0f78af95868f8d528cd701
21
02fe6acf8ff1ed29330333e6a9709e8f7f661fa6be8e89c393e8e51468d104158a
02
48
30450221009a59fa10a524b2193f4ca182f118e268392172a6ce075d0f381e0158c3a6c09302201dc8d1abe82c55dda87ec11888107e08bed8055b00925e7ddf729a0246db6c1d01
21
02fe6acf8ff1ed29330333e6a9709e8f7f661fa6be8e89c393e8e51468d104158a
02
47
3044022028f319a73adc86962e3ac32eafb2746b6740cfab3af6fcb380abb1372b7d1cd402202c1f9d5b0e719e3e93d7344980d33dad34332d31c5ae22c04bd723fbfd74155183
21
03eac483bf7bfcd9f932d70a6c403855eea01ca64a83676d1bee68fb8f4210b67a
02
47
3044022100b14d6414e1bce1728eccf56969210cc467459df7c446d5d4c3d152e18904aa47021f3478cf32960c534a73bc9cf3265349ff3050b607df8bfcd531c13ec32e702c01
21
02fe6acf8ff1ed29330333e6a9709e8f7f661fa6be8e89c393e8e51468d104158a
00000000
