// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ERC20_Transfer{

   uint public totalSupply=1000000;
   string public name="Waj";
   string public symbol="WAJ";
   uint8 public decimals = 18;
   mapping(address=>uint) public balanceOf;
   
   event Transfer(address indexed _from,address indexed  _to,uint value);

   constructor(){
   balanceOf[msg.sender]=totalSupply;
   }

   function transfer(address _to,uint _value) public returns(bool flag)
   {
       //If balanceOf[msg.sender]=>Totalsupply is less than equal to value(demand-token) then it will tranfer
       //It will check is the number of token avaliable or not
       require(balanceOf[msg.sender]>=_value);
       balanceOf[msg.sender]-=_value;
       balanceOf[_to]+=_value;
       emit Transfer(msg.sender,_to,_value);
       return true;
   }



} 