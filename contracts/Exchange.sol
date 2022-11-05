//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

contract Exchange {
    address public feeAccount;
    uint256 public feePercent;
    uint256 public orderCount;

    // This mapping here to know the amount of tokens user own in the exchange
    // Mapping from user address, to the token address, how much amount
    mapping(address => mapping(address => uint256)) public tokens;

    // Orders mapping
    mapping(uint256 => _Order) public orders;

    // Struct
    // Why using underscore, to avoid naming confict with the events, because we'll have event Order
    struct _Order {
        uint256 id;
        address user;
        address tokenGet;
        uint256 amountGet;
        address tokenGive;
        uint256 amountGive;
        uint256 timestamp;
    }

    event Deposit(address token, address user, uint256 amount, uint256 balance);
    event TestDeposit(
        address token,
        address user,
        uint256 amount,
        uint256 balance
    );

    event TestWithdraw(
        address token,
        address user,
        uint256 amount,
        uint256 balance
    );

    constructor(address _feeAccount, uint256 _feePercent) {
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    // Deposit Tokens
    function depositToken(address _token, uint256 _amount) public {
        // Transfer token to exchange
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));
        // Update user balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;
        // Emit the event
        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    // Test Deposit Tokens : The test deposit tokens function
    function testDepositToken(address _token, uint256 _amount) public {
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));
        tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;
        emit TestDeposit(
            _token,
            msg.sender,
            _amount,
            tokens[_token][msg.sender]
        );
    }

    //Check Balance
    function balanceOf(address _token, address _user)
        public
        view
        returns (uint256)
    {
        return tokens[_token][_user];
    }

    //Check Test Balance
    function testBalanceOf(address _token, address _user)
        public
        view
        returns (uint256)
    {
        return tokens[_token][_user];
    }

    //Withdraw Token
    function testWithdrawToken(address _token, uint256 _amount) public {
        require(tokens[_token][msg.sender] >= _amount);
        //Withdraw token from exchange to user
        Token(_token).transfer(msg.sender, _amount);
        //Update user balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;

        // Emit event
        emit TestWithdraw(
            _token,
            msg.sender,
            _amount,
            tokens[_token][msg.sender]
        );
    }

    // MAKE AND CANCEL order

    // Which parameter
    // Token Give (The token you want to give)
    // Token Get (The token you'll get)

    function makeOrder(
        address _tokenGet,
        uint256 _amountGet,
        address _tokenGive,
        uint256 _amountGive
    ) public {
        orderCount = orderCount + 1;
        orders[orderCount] = _Order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
        );
    }
}
