#include <stdio.h>
#include "../lib/examples/hello.h"
#include "../lib/examples/fibo.h"

int main() {
    hello_asm();

    int n = 10;
    int result = fibo_asm(n);
    printf("Fibonacci(%d) = %d\n", n, result);

    return 0;
}
