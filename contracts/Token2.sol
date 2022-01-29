// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

import "./IERC20.sol";
import "./IMintableToken.sol";
import "./IDividends.sol";
import "./SafeMath.sol";

contract Token is IERC20, IMintableToken, IDividends {
  
  using SafeMath for uint256;
  uint256 public totalSupply;
  uint256 public decimals = 18;
  string public name = "Test token";
  string public symbol = "TEST";
  mapping (address => uint256) public balanceOf;
  



  // Events

  event Transfer(address from, address to, uint256 value);

  event Approval(address owner, address spender, uint256 value);

  event Minted(uint amount);

  event Burned(uint amount);


  // Variables

  uint public scaledDividendPerToken;

  uint public scaling = 10**8;


  // Mappings

  mapping (address => mapping (address => uint256)) internal allowed;

  mapping (address => uint) scaledOutstandingDividend; 

  mapping (address => uint) scaledDividendCreditedTo; 
  

  /**
   * @dev Updates individual address dividends
   */
  function update(address _address) private {
    uint owed = scaledDividendPerToken - scaledDividendCreditedTo[_address];
    scaledOutstandingDividend[_address] += balanceOf[_address] * owed;
    scaledDividendCreditedTo[_address] = scaledDividendPerToken;
  }




  // IERC20

  /**
   * @dev Returns the amount which 'spender' is still allowed to withdraw from 'owner'.
   */
  function allowance(address owner, address spender) external view override returns (uint256) {
    return allowed[owner][spender];
  }


  /**
   * @dev Transfers 'value' amount of tokens to address 'to'.
   *
   * Throws if the message caller’s account balance does not have enough tokens to spend.
   *
   * Emits {Transfer} event.
   */
  function transfer(address to, uint256 value) external override returns (bool) {
    require(msg.sender != to);
    require(to != address(0));
    require(value <= balanceOf[msg.sender]);

    update(msg.sender);
    update(to);

    balanceOf[msg.sender] -= value;
    balanceOf[to] += value;

    emit Transfer(msg.sender, to, value);
    return true;
  }


  /**
   * @dev Allows 'spender' to withdraw from your account multiple times, up to the 'value' amount. 
   *
   * If this function is called again it overwrites the current allowance with 'value'.
   *
   * Emits {Approval} event.
   */
  function approve(address spender, uint256 value) external override returns (bool) {
    allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }


  /**
   * @dev Transfers 'value' amount of tokens from address 'from' to address 'to'.
   *
   * Emits {Transfer} event.
   */
  function transferFrom(address from, address to, uint256 value) external override returns (bool) {
    require(to != from);
    require(to != address(0));
    require(value <= balanceOf[from]);
    require(value <= allowed[from][msg.sender]);

    update(msg.sender);
    update(to);

    balanceOf[from] -= value;
    balanceOf[to] += value;
    allowed[from][msg.sender] -= value;

    emit Transfer(from, to, value);
    return true;
  }




  // IMintableToken


  /**
   * @dev Deposit ETH and mint equal no. of tokens to the caller's balance.
   *
   * Throws error if no ETH is supplied.
   *
   * Emits {Minted} event.
   */
  function mint() external payable override {
    require(msg.value > 0, "No ETH supplied.");

    update(msg.sender);

    balanceOf[msg.sender] += msg.value;
    totalSupply += msg.value;

    emit Minted(msg.value);
  }


  /**
   * @dev Burn caller's token balance and send the equivalent amount of ETH to given destination address.
   *
   * Throws error if no token balance is zero.
   */
  function burn(address payable dest) external override {
    uint burnAmount = balanceOf[msg.sender];
    require(burnAmount > 0, "No tokens to burn.");

    update(msg.sender);

    balanceOf[msg.sender] -= burnAmount;
    totalSupply -= burnAmount;
    dest.transfer(burnAmount);

    emit Burned(burnAmount);
  }


  

  // IDividends

  uint public scaledRemainder = 0;
  function recordDividend() external payable override {
    // scale the deposit and add the previous remainder
    uint256 available = (msg.value * scaling) + scaledRemainder;
    scaledDividendPerToken += available / totalSupply;
    // compute the new remainder
    scaledRemainder = available % totalSupply;
  }

  
  function getWithdrawableDividend(address payee) external view override returns (uint256) {
    // update(payee);   would throw error as non-payable view function
    return (scaledOutstandingDividend[msg.sender] / scaling); // technically not up to date
  }

  function withdrawDividend(address payable dest) external override {
    update(msg.sender);
    uint256 amount = scaledOutstandingDividend[msg.sender] / scaling;
    scaledOutstandingDividend[msg.sender] %= scaling;  // retain the remainder
    dest.transfer(amount);
  }
}
