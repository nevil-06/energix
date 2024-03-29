// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Token {
    struct Trade {
        address payable seller; // Making seller payable
        uint256 quantity;
        uint256 price;
        bool isActive;
    }

    Trade[] public trades;

    string public name = "YourTokenName";
    string public symbol = "YTN";
    uint256 public totalSupply = 1000000; // 1 million tokens
    uint8 public decimals = 18;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Insufficient allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
   
    function createTrade(uint256 _quantity, uint256 _price) public {
        require(_quantity > 0 && _price > 0, "Invalid trade parameters");
        trades.push(Trade(payable(msg.sender), _quantity, _price, true));
    }

    function acceptTrade(uint256 tradeIndex) public payable {
        require(tradeIndex < trades.length, "Trade does not exist");
        Trade storage trade = trades[tradeIndex];
        require(trade.isActive, "Trade is not active");
        require(msg.value == trade.price, "Incorrect value sent");

        trade.seller.transfer(msg.value);
        trade.isActive = false;
    }

    function getTradeCount() public view returns (uint256) {
        return trades.length;
    }

    function getTrade(uint256 index) public view returns (address seller, uint256 quantity, uint256 price, bool isActive) {
        require(index < trades.length, "Trade does not exist");
        Trade storage trade = trades[index];
        return (trade.seller, trade.quantity, trade.price, trade.isActive);
    }
}
