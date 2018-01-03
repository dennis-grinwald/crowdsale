pragma solidity ^0.4.18;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}


contract Token is owned {

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint))  allowances;

    //events
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    //modifier
    modifier checkLiquidityOfSender(uint _value) { if(balanceOf(msg.sender) >= _value) _; }
    modifier nonNegativeValueTransfer(uint _value) { if(_value > 0) _;}

    //functions
    function totalSupply() public constant returns (uint);


    function balanceOf(address _owner) public constant returns (uint balance){
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public checkLiquidityOfSender(_value) nonNegativeValueTransfer(_value) returns (bool success) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public nonNegativeValueTransfer(_value) returns (bool success) {
        if(approve(_from, _value) && allowance(_from, msg.sender) >= _value) {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else {return false;}
    }

    function approve(address _spender, uint _value) public checkLiquidityOfSender(_value) nonNegativeValueTransfer(_value) returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining){
        return allowances[_owner][_spender];
    }

}
