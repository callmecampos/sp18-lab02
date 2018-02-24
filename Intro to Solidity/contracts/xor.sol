pragma solidity 0.4.19;


contract XOR {
    function xor(uint a, uint b) public pure returns (uint) {
      if (a != b) {
        return 1;
      }
      return 0;
    }
}
