module mj;

// take a seed value and return array of n, each element is a copy of seed
macro @repeat(seed, $n) {
    $typeof(seed)* ret = ($typeof(seed)*) malloc($typeof(seed).sizeof * $n);
    $for (var $i = 0; $i < $n; $i++)
        ret[$i] = seed;
    $endfor
    return ret[:$n];
}

macro @repeatn(seed, n) {
    $typeof(seed)* ret = ($typeof(seed)*) malloc($typeof(seed).sizeof * n);
    for ($typeof(n) i = 0; i < n; i++) {
        ret[i] = seed;
    }
    return ret[:n];
}

def Matrix4f = Matrix4x4(<float>);
def Vec4f = float[<4>];
def Vec3f = float[<3>];
def Vec2f = float[<2>];
