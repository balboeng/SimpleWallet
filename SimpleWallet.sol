// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    event AllowanceChanged(address indexed _forWho, address indexed _forWhom, uint _oldAmount, uint _newAmount);
    mapping(address => uint) public allowance;

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[owner()] >= _amount, "your are not allowed");
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance (address _who, uint _amount) internal{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
}
∫
contract SimpleWallet is Allowance{

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        require(_amount <= address(this).balance, "There arent enough funds stored in da smart contract");
        if(owner() != msg.sender){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }

    function () external payable {
        emit MoneyReceived(msg.sender, msg.value)
    }
}
