// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;

struct Incharge{
    uint id;
    string name;
    address adress;
}
contract newFeature{
    uint public num1;
    uint public num2;
    constructor(){
        num1=256;
        num2=56;
    }
    function checkAssert()public view
    {
      assert(num1==256);
      assert(num2==56);
    }
    function undo(uint _i)public
    {
     num1+=1;
     require(_i<5);
    }

}


contract alterablemapping{
    Incharge[] public incharges;
    mapping(address=>Incharge)public incharge;
    mapping(address=>bool)public whiteaddress;
    // address[] public Incharges;
    address public owner;
     
     constructor()
     {
         owner=msg.sender;
     }

    modifier onlyOwner()
    {
        require(owner==msg.sender);
        _;
     }

    function setincharge(uint _id,string memory _name,address _Incharges)public onlyOwner{
        require(!whiteaddress[_Incharges],"Not incharge");
        whiteaddress[_Incharges]=true;
        incharge[_Incharges]=Incharge(_id,_name,_Incharges);
        Incharge memory incharg;
        incharg.id=_id;
        incharg.name=_name;
        incharg.adress=_Incharges;
        incharges.push(incharg);  
        // Name[_key]=_Name;
        
        // if(!whiteaddress[_key])
        // {
        // whiteaddress[_key]=true;
        // Incharges.push(_key);
        // } 
    }
    function add()public view returns(string memory _n)
    {
      require(whiteaddress[msg.sender],"Not Valid");
      return ("success");
    }
    // function getlength()public view returns(uint _length)
    // {
    //   return Incharges.length;
    // }

}