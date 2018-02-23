pragma solidity 0.4.19;

contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
      owner = msg.sender;
      outcomesCount = _outcomes.length;
      for (int i = 0; i < _outcomes.length; i += 1) {
        outcomes[i] = _outcomes[i];
      }
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    uint public outcomesCount;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
      require(msg.sender == owner);
      _;
    }
    modifier oracleOnly() {
      require(msg.sender == oracle);
      _;
    }
    modifier outcomeExists(uint outcome) {
      for (int i = 0; i < outcomesCount; i += 1) {
        if (outcome[i] == outcome) {
          require(true);
        }
      }
      require(false);
      _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
      oracle = _oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
      if (gamblerA == null) {
        gamblerA = msg.sender;
      } else if (gamblerB == null) {
        gamblerB = msg.sender;
      } else {
        revert('There are already two gamblers, please try again once winnings are dispersed.');
        return false;
      }

      bets[msg.sender] = new Bet(_outcome, msg.value, true);

      BetMade(msg.sender);
      return true;
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
      if bets[gamblerA]
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
      //
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
      //
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
      //
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
      //
    }
}
