// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Bank{
    event Transfer(address _accounts,uint _amount);
    // event accountopen(address _account,uint _amount);
    string public bankName;
    address public owner;
    mapping(address=>uint256)  balance;
    mapping(address=>bool) public validAccount;
    address payable wallet=payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    uint count;
    
    constructor(string memory _name)payable
    {
    require(msg.value>=50 ether,"Invalid balance to OpenBank");
    bankName=_name;
    owner=msg.sender;
    balance[address(this)]=msg.value;
    payable(address(this)).transfer(msg.value);
    emit Transfer(address(this),msg.value);
    count=0;
    }

    modifier onlyOwner()
    {
     require(msg.sender==owner);
     _;
    }
    function openAccount()public payable
    {
      // require(address(this).balance>0,"No Bank avaliable");
      require(balance[address(this)]>0,"No Bank avaliable");
      require(!validAccount[msg.sender],"Account Already Open");
      require(msg.value>=5 ether,"Invalid balance to OpenAccount");
      if(count<5)
      {
      validAccount[msg.sender]=true;
      balance[msg.sender]=msg.value+1000000000000000000;
      balance[address(this)]+=msg.value;
      count++;
      emit Transfer(msg.sender,msg.value);
      
      }
      else
      {
      validAccount[msg.sender]=true;
      balance[msg.sender]=msg.value;
      balance[address(this)]+=msg.value;
      count++;
      emit Transfer(msg.sender,msg.value);
      
      }
    }

    function closingBalance()public onlyOwner
    {
     wallet.transfer(address(this).balance);
    //  wallet.transfer(balance[address(this)]);
     balance[address(this)] =0; 
    
    }
    function checkAccountBallance(address _account)public view returns(uint)
    {
      require(address(this).balance>0,"No Bank avaliable");  
      return (balance[ _account]/1000000000000000000);
    }
    function withdraw(uint amount)public
    {
        require(address(this).balance>0,"No Bank avaliable");
        require(validAccount[msg.sender]==true," invalid Account");
        require(balance[msg.sender]>=amount,"Out of Balance");
        require(1<= (balance[msg.sender]-amount*1000000000000000000),"you must have balance greater than 1 ether");
        balance[msg.sender]-=amount*1000000000000000000;
        balance[address(this)]-=amount*1000000000000000000;
        address  payable account=payable(msg.sender);
        account.transfer(amount*1000000000000000000);
        emit Transfer(msg.sender,balance[msg.sender]);
    }
    function closingAccount()public
    {
      require(address(this).balance>0,"No Bank avaliable");
      require(validAccount[msg.sender]==true," invalid Account");
      require(balance[msg.sender]>0,"Account Deactivated");
      //  balance[msg.sender]-=amount*1000000000000000000;
      address  payable account=payable(msg.sender);
      account.transfer(balance[msg.sender]);
      balance[address(this)]-=balance[msg.sender];
      balance[msg.sender]=0;
      emit Transfer(msg.sender,balance[msg.sender]);

    }
    function DepositeAmount()public payable
    {
      require(address(this).balance>0,"No Bank avaliable");
      require(validAccount[msg.sender]==true,"No Such Account Avaliable");
      require(balance[msg.sender]>0,"Account Deactivated");
      // require(msg.value>=5 ether,"Invalid balance to OpenAccount");
      // validAccount[msg.sender]=true;
      balance[msg.sender]+=msg.value;
      balance[address(this)]+=msg.value;
      emit Transfer(msg.sender,balance[msg.sender]);
    }

}