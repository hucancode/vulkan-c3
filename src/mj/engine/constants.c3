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
def Vec4i = int[<4>];
def Vec3i = int[<3>];
def Vec2i = int[<2>];
def Vec4u = uint[<4>];
def Vec3u = uint[<3>];
def Vec2u = uint[<2>];
def Position = float[<3>];
def Position4 = float[<4>];
def Scale = float[<3>];
def Scale4 = float[<4>];
def Color = float[<4>];

const VEC_UP = Vec3f {0.0, 1.0, 0.0};
const VEC_DOWN = Vec3f {0.0, -1.0, 0.0};
const VEC_RIGHT = Vec3f {1.0, 0.0, 0.0};
const VEC_LEFT = Vec3f {-1.0, 0.0, 0.0};
const VEC_FORWARD = Vec3f {0.0, 0.0, 1.0};
const VEC_BACKWARD = Vec3f {0.0, 0.0, -1.0};
const VEC_Y = VEC_UP;
const VEC_Y_NEG = VEC_DOWN;
const VEC_X = VEC_RIGHT;
const VEC_X_NEG = VEC_LEFT;
const VEC_Z = VEC_FORWARD;
const VEC_Z_NEG = VEC_BACKWARD;
