pragma solidity 0.4.19;


contract Concatenate {
    function concatWithoutImport(string _s, string _t) public returns (string) {
      bytes memory aBytes = bytes(a);
      bytes memory bBytes = bytes(b);
      string memory ab = new string(aBytes.length + bBytes.length);
      bytes memory resultBytes = bytes(ab);

      for (uint i = 0; i < aBytes.length; i += 1) {
          resultBytes[i] = aBytes[i];
      }

      for (uint j = aBytes.length; j < aBytes.length + bBytes.length; j += 1) {
          resultBytes[j] = bBytes[j - aBytes.length];
      }

      return string(resultBytes);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
