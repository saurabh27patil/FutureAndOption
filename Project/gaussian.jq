jsoniq version "1.0";
module namespace np = "http://cs.gmu.edu/dgal/Gaussian.jq";
declare namespace an = "http://zorba.io/annotations";
import module namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace r = "http://zorba.io/modules/random";

declare function np:gaussian($x) {
    math:exp(-$x * $x div 2) div math:sqrt(2 * math:pi())
};

declare function np:gaussian($x, $mu, $sigma) {
    np:gaussian(($x - $mu) div $sigma) div $sigma
};

declare %an:nondeterministic function np:gaussian() {
    let $x := r:random-between(0,100000000) div 100000
    return np:gaussian($x)
};

declare %an:nondeterministic function np:gaussian($mu, $sigma) {
    let $x := r:random-between(0,100000000) div 100000
    return np:gaussian($x, $mu, $sigma)
};
