import std::io;

macro @duplicate(seed, $n) {
    $typeof(seed)* ret = ($typeof(seed)*)malloc($typeof(seed).sizeof * $n);
    $for (var $i = 0; $i < $n; $i++)
        ret[$i] = seed;
    $endfor
    return ret[:$n];
}
macro @duplicaten(seed, n) {
    $typeof(seed)* ret = ($typeof(seed)*)malloc($typeof(seed).sizeof * n);
    for (var $i = 0; $i < n; $i++) ret[$i] = seed;
    return ret[:n];
}

fn void! testMacro() @test {
    int seed = 10;
    int[] arr = @duplicate(seed, 5); // ok
    // int n = 3; int[] arr = @duplicaten(seed, n); // freeze
    foreach(x:arr) assert(x == seed);
}
