pragma solidity ^0.4.18;

import "./Token.sol";

contract TokenICO is Token {

    //Token Specification
    uint public tokenSupply;
    uint public tokenPrice;
    bytes32 public tokenName;
    bytes32 public tokenSymbol;
    uint8 public decimals;

    mapping (address => User) userList;

    modifier userRegistryCheck() { if(userList[msg.sender].userAddress != 0) _; }
    modifier tokenAvailabilityCheck(uint _amount) { if(tokenSupply - _amount >= 0) _;}

    event TokenPurchaseSuccessfull(address _buyer , uint _tokens);
    event TokenPurchaseFailure(address _buyer , uint _tokens);

    function TokenICO(uint _tokenSupply, uint _tokenPrice, bytes32 _tokenName, bytes32 _tokenSymbol, uint8 _decimals) public {
        tokenSupply = _tokenSupply;
        tokenPrice = _tokenPrice;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        decimals = _decimals;
    }
    
    function totalSupply() public constant returns (uint) {
        return tokenSupply;
    }

    //function to buy tokens
    function () public payable userRegistryCheck() tokenAvailabilityCheck(msg.value) {

        uint coinsPerWei = msg.value/tokenPrice;
        bytes32 nationality = userList[msg.sender].userNationality;

        //check if max amount of legal owned ETH according to sender's nationality - if not successful sender's eths are returend
        if(((nationality == "US") && (balances[msg.sender] + coinsPerWei) > 1000 ) || ((nationality == "US") && (balances[msg.sender] == 1000 ))) {
            revert();
            TokenPurchaseFailure(msg.sender , coinsPerWei);
        }
        if(((nationality != "US") && (balances[msg.sender] + coinsPerWei) > 2000 ) || ((nationality != "US") && (balances[msg.sender] == 2000 ))) {
            revert();
            TokenPurchaseFailure(msg.sender , coinsPerWei);
        }
        balances[msg.sender] += coinsPerWei;
        tokenSupply -= coinsPerWei;
        TokenPurchaseSuccessfull(msg.sender, coinsPerWei);
    }

    //User Registration
    struct User {
        address userAddress;
        bytes32 userName;
        bytes32 userEmail;
        bytes32 userNationality;
    }

    function registerUser(bytes32 _userName, bytes32 _userEmail, bytes32 _userNationality) public returns(bool success){
        userList[msg.sender].userAddress = msg.sender;
        userList[msg.sender].userName = _userName;
        userList[msg.sender].userEmail = _userEmail;
        userList[msg.sender].userNationality = _userNationality;
        return true;
    }
}
