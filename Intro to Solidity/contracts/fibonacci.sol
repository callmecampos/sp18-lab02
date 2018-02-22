pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
      if (n < 2) {
        return n;
      }

      return fib(n-1) + fib(n-2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
      uint prev = 0;
      uint curr = 1;
      for (uint i = 0; i < n; i += 1) {
          uint temp = curr;
          curr += prev;
          prev = temp;
      }

      return prev;
    }
}
