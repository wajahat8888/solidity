// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ERC1155{
    event TranferSingleFor(address indexed _operator,address indexed _from,address indexed _to,uint256 _id,uint256 _value);
    event TranferBatchFor(address indexed _operator,address indexed _from,address indexed _to,uint256[] _id,uint256[] _value);
    event ApprovalForAll(address indexed _owner,address indexed _operator,bool _approved);
    event _URL(uint _value,uint indexed _id);

    uint256 public Shieldid=0;   //fungiable
    uint256 public Westid=1;     //fungiable
    uint256 public Sword=2;      //fungiable
    uint256 public Hamber=3;     //non-fungiable

    address public owner;

    mapping(uint256=>mapping(address=>uint256)) public balanceOf;
    mapping(uint256=>uint256) public limit;
    // mapping(uint256=>uint256) public totalMint;
    mapping(address=>mapping(address=>bool))public operatorApproval;

    constructor()
    {
      owner=msg.sender;
      limit[0]=50;
      limit[1]=100;
      limit[2]=50;
      limit[3]=1;
    //   totalMint[0]=0;
    //   totalMint[1]=0;
    //   totalMint[2]=0;
    //   totalMint[3]=0;
    }

    modifier onlyOwner()
    {
        require(owner==msg.sender);
        _;
    }
    function limitIncrease(uint256 _id,uint256 _value) public onlyOwner
    {
      limit[_id]+=_value;
    }
    // Single Type of Token Mint function
    function mint(address _to,uint256 _id,uint256 _value) public 
    {
       require(limit[_id]>=_value,"ERC1155: limited minting");
       require(_to!= address(0), "ERC1155: mint to the zero address");  
       balanceOf[_id][_to] += _value;
       limit[_id]-=_value;
       emit TranferSingleFor(msg.sender,address(0),_to,_id,_value);
    }

    //multiple type of token mint function
    function mintBatch(address _to,uint[] memory _ids,uint[] memory _values) public 
    {
        require(_to!= address(0), "ERC1155: mint to the zero address");
        require(_ids.length == _values.length, "ERC1155: ids and amounts length mismatch");
       for(uint i=0;i<_ids.length;i++) 
       {
       require(limit[_ids[i]]>=_values[i],"ERC1155: limited minting"); 
       balanceOf[_ids[i]][_to] += _values[i];
       limit[_ids[i]]-=_values[i];
       
       }
       emit TranferBatchFor(msg.sender,address(0),_to,_ids,_values);
    }

    //sigletransfer function
    function transfersigle(address _from,address _to,uint256 _id,uint256 _value)public 
    {
     require(balanceOf[_id][_from]>=_value);
     balanceOf[_id][_from]-=_value;
     balanceOf[_id][_to]+=_value;
     emit TranferSingleFor(msg.sender,_from,_to,_id,_value);
     }

     //Batchtransfer Function
     function transferbatch(address _from,address _to,uint256[] memory _ids,uint256[] memory _values)public 
    {
      for(uint i=0;i<_ids.length;i++) 
       {  
       require(balanceOf[_ids[i]][_from]>=_values[i]);
       balanceOf[_ids[i]][_from]-=_values[i];
       balanceOf[_ids[i]][_to]+=_values[i];
       }
     emit TranferBatchFor(msg.sender,_from,_to,_ids,_values);
     }

     //single burn function
     function burn(uint256 _id,uint256 _value)public
     {
         require(balanceOf[_id][msg.sender]>=_value);
         balanceOf[_id][msg.sender]-=_value;
         limit[_id]+=_value;
         emit TranferSingleFor(msg.sender,msg.sender,address(0),_id,_value);
     }

     //BatchBurn function
     function batchBurn(uint256[] memory _ids,uint256[] memory _values)public
     {
        for(uint i=0;i<_ids.length;i++) 
       { 
         require(balanceOf[_ids[i]][msg.sender]>=_values[i]);
         balanceOf[_ids[i]][msg.sender]-=_values[i];
         limit[_ids[i]]+=_values[i];
         
       }
       emit TranferBatchFor(msg.sender,msg.sender,address(0),_ids,_values);
     }


     //isApprovalorAll()
     function isApprovalorAll(address _account,address _operater)public view returns(bool success)
     {
          return operatorApproval[_account][_operater];
     } 

     //setApprovalforAll()
     function setApprovalforAll(address  _owner,address  _operator,bool approved) public
     {
       require(_owner!= _operator, "ERC1155: setting approval status for self");
       operatorApproval[_owner][_operator]=approved;
       emit ApprovalForAll(_owner,_operator,approved);

     }     




}