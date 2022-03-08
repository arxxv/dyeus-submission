// SPDX-License-Identifier:MIT
pragma solidity ^0.6.0;

contract Game {

    struct Player {
        uint256 balance;
        uint256 bet;
        int256 choice;
        bool created;
    } 
    address payable public manager;
    uint256 tailBets;
    uint256 headBets;
    int256 public tossValue = -1;
    mapping(address => Player) players;
    address payable [] allPlayers;
    address GameFactoryAddress;
    uint256 insufficientFund;

    constructor(address payable _manager, address _gamefactory) public {
        manager = _manager;
        GameFactoryAddress = _gamefactory;
    }

    event myEvent(address _winner, uint256 _bet);

    modifier restricted() {
        require(msg.sender == manager, "Sender not authorized");
        _;
    }

    modifier gameNotOver() {
        require(tossValue == -1, "Already tossed");
        _;
    }

    function vrf() internal view returns (bytes32 result) {
        uint[1] memory bn;
        bn[0] = block.number;
        assembly {
            let memPtr := mload(0x40)
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
                invalid()
            }
            result := mload(memPtr)
        }
  }

    function join() public gameNotOver {
        if(!players[msg.sender].created){
            players[msg.sender] = Player(100000000000000000000, 0, -1, true);
        }
    }

    function bet(int256 _choice) public payable gameNotOver {
        require(msg.value > 0, "Bet cannot be zero or negative");
        require(_choice == 0 || _choice == 1, "Bet can either be 1(tail) or 0(head)");
        require(players[msg.sender].created == true, "Join the game first");
        require(players[msg.sender].choice == -1, "You already have placed a bet");
        require(players[msg.sender].balance >= msg.value, "You cannot bet more than your balance");

        if(_choice == 0)
            tailBets += msg.value;
        else 
            headBets += msg.value;
        
        players[msg.sender].bet = msg.value;
        players[msg.sender].balance -= msg.value;
        players[msg.sender].choice = _choice;
    }

    function flipCoin() public restricted gameNotOver returns (uint256){
        tossValue = int256(vrf()) % 2;
        uint256 totalContractPool = headBets + tailBets;
        insufficientFund = 0;

        if(tossValue == 0)
            if(totalContractPool < tailBets * 2)
                insufficientFund = tailBets * 2 - totalContractPool;
            
        if(tossValue == 1)
            if(totalContractPool < headBets * 2)
                insufficientFund = headBets * 2 - totalContractPool;
        
        return insufficientFund;
    }

    function checkInsufficientFunds() public view restricted returns(uint256) {
        return insufficientFund;
    }

    function endGame() external payable { 
        for(uint256 i = 0; i < allPlayers.length; i++){
            if(players[allPlayers[i]].choice == tossValue){
                emit myEvent(allPlayers[i], players[allPlayers[i]].bet);
                allPlayers[i].transfer(players[allPlayers[i]].bet * 2);
            }
            players[allPlayers[i]].choice = -1;
            players[allPlayers[i]].bet = 0;
        }
        GameFactory gameFactory = GameFactory(GameFactoryAddress);
        gameFactory.finishGame(this);
        selfdestruct(manager);
    }   
}

contract GameFactory{
    Game[] liveGames;
    Game[] staleGames;

    function createGame() public {
        Game newGame = new Game(msg.sender, address(this));
        liveGames.push(newGame);
    }

    function finishGame(Game game) external payable {
        for(uint256 i = 0; i < liveGames.length; i++){
            if(liveGames[i] == game){
                liveGames[i] = liveGames[liveGames.length-1];
                liveGames.pop();
                break;
            }
        }
        staleGames.push(game);
    }

    function getStaleGames() public view returns (Game[] memory){
        return staleGames;
    } 

    function getLiveGames() public view returns (Game[] memory){
        return liveGames;
    } 
    
}
