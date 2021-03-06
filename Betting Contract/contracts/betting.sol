pragma solidity 0.4.19;

contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
      owner = msg.sender;
      outcomesCount = _outcomes.length;
      for (uint i = 0; i < _outcomes.length; i += 1) {
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
      for (uint i = 0; i < outcomesCount; i += 1) {
        if (outcomes[i] == outcome) {
          require(true);
        }
      }
      require(false);
      _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
      oracle = _oracle;
      return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
      if (oracle == 0) {
        revert(); // 'No oracle has been initialized, please try again once the owner has chosen an oracle.'
      }

      if (gamblerA == 0) {
        gamblerA = msg.sender;
      } else if (gamblerB == 0) {
        gamblerB = msg.sender;
        BetClosed();
      } else {
        revert(); // 'There are already two gamblers, please try again once winnings are dispersed.'
        return false;
      }

      bets[msg.sender] = Bet(_outcome, msg.value, true);

      BetMade(msg.sender);
      return true;
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
      uint pot = bets[gamblerA].amount + bets[gamblerB].amount;
      uint outA = bets[gamblerA].outcome;
      uint outB = bets[gamblerB].outcome;
      if ((outA == _outcome) && (outB == _outcome)) {
        winnings[gamblerA] = pot / 2.0;
        winnings[gamblerB] = pot / 2.0;
      } else if (outA == _outcome) {
        winnings[gamblerA] = pot;
      } else if (outB == _outcome) {
        winnings[gamblerB] = pot;
      }

      gamblerA = 0;
      gamblerB = 0;
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
      uint cashMoneyFlow = winnings[msg.sender];
      if (withdrawAmount <= cashMoneyFlow) {
        winnings[msg.sender] -= withdrawAmount;
        if (!msg.sender.send(withdrawAmount)) {
          winnings[msg.sender] += withdrawAmount;
        }
      }

      return winnings[msg.sender];
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
      if (outcome < outcomesCount) {
        return outcomes[outcome];
      } else {
        return 0;
      }
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
      return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
      delete(oracle);
      delete(gamblerA);
      delete(gamblerB);
    }
}
