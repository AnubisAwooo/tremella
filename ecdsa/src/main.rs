use std::{
    fmt::Display,
    ops::{Add, Mul},
};

// const P: i64 = 257; // 模数
// const A: i64 = 0; // 椭圆曲线参数 y^2 = x^3 + ax + b
// const B: i64 = 7; // 椭圆曲线参数 y^2 = x^3 + 7

// const G: Point = Point::new(1, 120); // 基点

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Param {
    p: i64,
    a: i64,
    b: i64,
}

impl Param {
    fn new(p: i64, a: i64, b: i64) -> Self {
        Param { p, a, b }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Point<'a> {
    Infinity(&'a Param),
    Point { p: &'a Param, x: i64, y: i64 },
}

impl<'a> Point<'a> {
    const fn infinity(p: &'a Param) -> Self {
        Point::Infinity(p)
    }

    const fn new(p: &'a Param, x: i64, y: i64) -> Self {
        if (y * y - (x * x * x + p.a * x + p.b)) % p.p != 0 {
            panic!("invalid point");
        }
        Point::Point { p, x, y }
    }

    const fn negate(&self) -> Self {
        match self {
            Point::Infinity(p) => Point::Infinity(p),
            Point::Point { p, x, y } => Point::Point { p, x: *x, y: -*y },
        }
    }

    fn get_x(&self) -> i64 {
        match self {
            Point::Infinity(_) => panic!("infinity has no x"),
            Point::Point { x, .. } => *x,
        }
    }

    fn points(&self) -> Vec<Point> {
        let p = match self {
            Point::Infinity(param) => param,
            Point::Point { p, .. } => p,
        };
        let points = (0..p.p)
            .flat_map(move |x| (0..p.p).map(move |y| (x, y)))
            .filter(|(x, y)| (y * y - (x * x * x + p.a * x + p.b)) % p.p == 0)
            .collect::<Vec<_>>();
        let mut ps = Vec::with_capacity(points.len() + 1);
        ps.push(Point::infinity(p));
        ps.extend(points.iter().map(|(x, y)| Point::new(p, *x, *y)));
        ps
    }
}

impl Display for Point<'_> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Point::Infinity(_) => write!(f, "Infinity"),
            Point::Point { x, y, .. } => write!(f, "({},{})", x, y),
        }
    }
}

impl<'a> Add for Point<'a> {
    type Output = Point<'a>;

    fn add(self, rhs: Self) -> Self::Output {
        match (self, rhs) {
            (Point::Infinity(p), Point::Infinity(p2)) => {
                if p != p2 {
                    panic!("param is not same");
                }
                Point::Infinity(p)
            }
            (Point::Infinity(p), Point::Point { p: p2, x, y }) => {
                if p != p2 {
                    panic!("param is not same");
                }
                Point::Point { p, x, y }
            }
            (Point::Point { p, x, y }, Point::Infinity(p2)) => {
                if p != p2 {
                    panic!("param is not same");
                }
                Point::Point { p, x, y }
            }
            (
                Point::Point { p, x: x1, y: y1 },
                Point::Point {
                    p: p2,
                    x: x2,
                    y: y2,
                },
            ) => {
                if p != p2 {
                    panic!("param is not same");
                }
                if x1 == x2 && y1 != y2 {
                    return Point::Infinity(p);
                }

                let (k1, k2) = if x1 == x2 && y1 == y2 {
                    // println!("same -> {}/{}", 3 * x1 * x1 + p.a, 2 * y1);
                    (3 * x1 * x1 + p.a, 2 * y1)
                } else {
                    // println!("diff -> {}/{}", y2 - y1, x2 - x1);
                    (y2 - y1, x2 - x1)
                };

                // println!("k: {}/{}", k1, k2);

                fn positive(mut v: i64, p: i64) -> i64 {
                    v %= p;
                    loop {
                        if 0 <= v {
                            break;
                        }
                        v += p;
                    }
                    v
                }

                fn mod_inv(mut k1: i64, k2: i64, p: i64) -> i64 {
                    k1 = positive(k1, p);

                    let mut i = 0;
                    loop {
                        if p <= i {
                            panic!("can not find mod inv")
                        }

                        if positive(k2 * i, p) == k1 {
                            return i;
                        }

                        i += 1;
                    }
                }

                // ! 加法运算 对 p 取模

                let x3 = positive(mod_inv(k1 * k1, k2 * k2, p.p) - x1 - x2, p.p);
                let y3 = positive(mod_inv(k1 * (x1 - x3), k2, p.p) - y1, p.p);

                Point::Point { p, x: x3, y: y3 }
            }
        }
    }
}

impl<'a> Mul<u64> for Point<'a> {
    type Output = Point<'a>;

    fn mul(self, rhs: u64) -> Self::Output {
        if rhs == 0 {
            return Point::Infinity(match self {
                Point::Infinity(p) => p,
                Point::Point { p, .. } => p,
            });
        }

        if rhs == 1 {
            return self;
        }

        let mut points = vec![self];
        let mut r = rhs >> 1;
        while 0 < r {
            let last = points[points.len() - 1];
            points.push(last + last);
            r >>= 1;
        }

        let mut v = None;
        let mut r = rhs;
        let mut i = 0;
        while 0 < r {
            if r & 1 == 1 {
                let p = points[i];
                v = match v {
                    None => Some(p),
                    Some(v) => Some(v + p),
                };
            }
            r >>= 1;
            i += 1;
        }

        v.unwrap()
    }
}

fn print_points(param: &Param, points: &[Point]) {
    println!(
        "points: {:?} -> {} [{}]",
        param,
        points.len(),
        points
            .iter()
            .map(|p| p.to_string())
            .collect::<Vec<_>>()
            .join(",")
    );
    println!();
}

fn main() {
    fn positive(mut v: i64, n: i64) -> i64 {
        v %= n;
        loop {
            if 0 <= v {
                break;
            }
            v += n;
        }
        v
    }

    fn mod_inv(mut k1: i64, k2: i64, n: i64) -> i64 {
        k1 = positive(k1, n);

        let mut i = 0;
        loop {
            if n <= i {
                panic!("can not find mod inv")
            }

            if positive(k2 * i, n) == k1 {
                return i;
            }

            i += 1;
        }
    }

    fn get_n(point: Point) -> i64 {
        let mut n = 1;
        loop {
            let current = point * n;
            if let Point::Infinity(_) = current {
                break;
            }
            if current == point && n != 1 {
                break;
            }
            n += 1;
        }
        n as i64
    }

    println!("Hello, world!");

    let param = Param::new(11, 1, 6);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);

    let param = Param::new(23, 1, 1);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);

    let param = Param::new(257, 0, 7);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);

    let param = Param::new(23, 1, 1);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);
    let p = Point::new(&param, 3, 10);
    let q = Point::new(&param, 9, 7);
    println!("{} + {} = {}", p, q, p + q);
    println!("{} + {} = {}", p, p, p + p);
    println!("{} * 1 = {}", p, p * 1);
    println!("{} * 2 = {}", p, p * 2);
    println!("{} * 3 = {}", p, p * 3);
    println!("{} * 4 = {}", p, p * 4);
    println!("{} * 5 = {}", p, p * 5);
    println!("{} * 6 = {}", p, p * 6);
    println!("{} * 7 = {}", p, p * 7);
    println!("{} * 8 = {}", p, p * 8);
    println!("{} * 9 = {}", p, p * 9);
    println!("{} * 10 = {}", p, p * 10);
    println!("{} * 11 = {}", p, p * 11);
    println!("{} * 12 = {}", p, p * 12);
    println!("{} * 13 = {}", p, p * 13);
    println!("{} * 14 = {}", p, p * 14);
    println!("{} * 15 = {}", p, p * 15);
    println!("{} * 16 = {}", p, p * 16);
    println!("{} * 17 = {}", p, p * 17);
    println!("{} * 18 = {}", p, p * 18);
    println!("{} * 19 = {}", p, p * 19);
    println!("{} * 20 = {}", p, p * 20);
    println!();

    let param = Param::new(11, 1, 6);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);
    let g = Point::new(&param, 3, 5); // 基点
    let n = get_n(g);
    let key = 7; // 私钥
    let p = g * key; // 公钥
    println!("{} * {} = {} | n: {}", g, key, p, n);

    {
        // ? 公钥加密 私钥解密
        println!("============ crypto ============");

        let m = Point::new(&param, 10, 9); // 明文
        println!("m: {}", m);
        let random = 3; // 随机整数
        let c1 = g * random; // 提供加密随机数
        println!("c1: {} * {} = {}", g, random, c1);
        let c2 = m + p * random; // 明文和公钥加入计算 c2 = m + p * k = m + g * key * k
        println!("c2: {} + {} * {} = {}", m, p, random, c2);

        println!("cm: ({},{})", c1, c2); // 密文

        let m2 = c2 + (c1.negate() * key); // 私钥解密 m = c2 - c1 * key = c2 - g * k * key
        println!("m2: {}", m2);

        assert_eq!(m, m2);
    }

    {
        // ? 私钥签名 公钥验证
        println!("============ signature ============");

        let random = 5; // 随机整数
        let p1 = g * random; // 提供随机数信息
        let hash = 5;
        let s = (hash * key) as i64 + random as i64; // 提供私钥信息
        println!("s: {}", s);

        println!("signature: ({}, {})", p1, s); // 签名

        let x = p * hash + p1; // g * key * hash + g * random = g * (key * hash + random)
        let y = g * s as u64;
        println!("x: {}", x);
        println!("y: {}", y);
        assert_eq!(x, y);
    }

    {
        // ? 私钥签名 公钥验证
        println!("============ signature r ============");

        let random = 5; // 随机整数
        let p1 = g * random;
        let r = p1.get_x(); // 提供随机数信息
        let hash = 5;
        println!("r: {} <- {} ", r, p1);
        let s = positive(
            mod_inv(1, random as i64, n) * (hash as i64 + key as i64 * r),
            n,
        ); // 提供私钥信息
        println!("s: {}", s);

        println!("signature: ({}, {})", r, s); // 签名

        let u1 = positive(mod_inv(1, s, n) * hash as i64, n);
        let u2 = positive(mod_inv(1, s, n) * r, n);
        println!("1/s: {}", mod_inv(1, s, n));
        println!("u1: {}, u2: {}", u1, u2);
        let pp = g * (u1 as u64) + p * (u2 as u64);
        println!("pp: {}", pp);
        assert_eq!(p1.get_x(), pp.get_x());
    }

    let param = Param::new(199, 0, -4);
    let point = Point::Infinity(&param);
    let points = point.points();
    print_points(&param, &points);
    let g = Point::new(&param, 2, 2); // 基点
    let n = get_n(g);
    let key = 7; // 私钥
    let p = g * key; // 公钥
    println!("{} * {} = {} | n: {}", g, key, p, n);

    {
        // ? 公钥加密 私钥解密
        println!("============ crypto ============");

        let m = Point::new(&param, 67, 95); // 明文
        println!("m: {}", m);
        let random = 3; // 随机整数
        let c1 = g * random; // 提供加密随机数
        println!("c1: {} * {} = {}", g, random, c1);
        let c2 = m + p * random; // 明文和公钥加入计算 c2 = m + p * k = m + g * key * k
        println!("c2: {} + {} * {} = {}", m, p, random, c2);

        println!("cm: ({},{})", c1, c2); // 密文

        let m2 = c2 + (c1.negate() * key); // 私钥解密 m = c2 - c1 * key = c2 - g * k * key
        println!("m2: {}", m2);

        assert_eq!(m, m2);
    }

    {
        // ? 私钥签名 公钥验证
        println!("============ signature ============");

        let random = 5; // 随机整数
        let p1 = g * random; // 提供随机数信息
        let hash = 5;
        let s = (hash * key) as i64 + random as i64; // 提供私钥信息
        println!("s: {}", s);

        println!("signature: ({}, {})", p1, s); // 签名

        let x = p * hash + p1; // g * key * hash + g * random = g * (key * hash + random)
        let y = g * s as u64;
        println!("x: {}", x);
        println!("y: {}", y);
        assert_eq!(x, y);
    }

    {
        // ? 私钥签名 公钥验证
        println!("============ signature r ============");

        let random = 5; // 随机整数
        let p1 = g * random;
        let r = p1.get_x(); // 提供随机数信息
        let hash = 5;
        println!("r: {} <- {} ", r, p1);
        let s = positive(
            mod_inv(1, random as i64, n) * (hash as i64 + key as i64 * r),
            n,
        ); // 提供私钥信息
        println!("s: {}", s);

        println!("signature: ({}, {})", r, s); // 签名

        let u1 = positive(mod_inv(1, s, n) * hash as i64, n);
        let u2 = positive(mod_inv(1, s, n) * r, n);
        println!("1/s: {}", mod_inv(1, s, n));
        println!("u1: {}, u2: {}", u1, u2);
        let pp = g * (u1 as u64) + p * (u2 as u64);
        println!("pp: {}", pp);
        assert_eq!(p1.get_x(), pp.get_x());
    }

    {
        // ? 私钥签名 公钥验证 Schnorr签名
        println!("============ signature r ============");

        let random = 39; // 随机整数
        let r = g * random;
        println!("r: {}", r);
        let hash = 5; // e = H(m || R) 这里假设 hash 就是结果
        let s = random - hash * key; // 提供私钥信息
        println!("s: {}", s);

        println!("signature: ({}, {})", r, s); // 签名

        let pp = g * s + p * hash;
        println!("pp: {}", pp);
        assert_eq!(r, pp);
    }

    {
        // ? 私钥签名 公钥验证 Schnorr签名 聚合
        println!("============ signature r ============");

        let key2 = 11; // 私钥
        let p2 = g * key2; // 公钥

        let random = 57; // 随机整数
        let r = g * random;
        println!("r: {}", r);
        let hash = 5; // e = H(m || R) 这里假设 hash 就是结果
        let s1 = random - hash * key; // 提供私钥信息
        let s2 = random - hash * key2; // 提供私钥信息
        let s = s1 + s2;
        println!("s: {}", s);

        println!("signature: ({}, {})", r, s); // 签名

        let pp = g * s + p * hash + p2 * hash;
        println!("pp: {}", pp);
        assert_eq!(r * 2, pp);
    }
}
