// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
import "./erc721.sol";
import "./Assets.sol";

contract Token is ERC721,Assets {

    uint256 transferFee;
    uint256 addFee;
    
    constructor(){
        addFee = 1;
        transferFee = 1;
    }
    
    function createAsset(string memory name, string memory game, string memory asset_type, uint cost) public payable{
        (bool sent,) = owner().call{value: msg.value}("");
        require(sent, "add fee couldn't be payed");
        Asset memory asset = Asset(name,game,asset_type,cost,true);
        _createAsset(asset);
    }
    
    
  function balanceOf(address _owner) override external view returns (uint256) {
     return getOwnerAssetCount(_owner);
  }

  function ownerOf(uint256 _tokenId) override external view returns (address) {
    return getOwnerFromAssetId(_tokenId);
  }
  
  function getContractMoney() public view returns (uint256){
      return address(this).balance;
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) override external payable {
    // In this case the sender of the token calls the transferFrom function
    require (getOwnerFromAssetId(_tokenId) == _from, "from address is not owner of tokenId");
    require (asset_list[_tokenId].forSale == true, "the token is not for sale");
    require (_from != _to, "cannot transfer from == to");
    require (msg.value == getCost(_tokenId)*1e18, " no money to pay");
    (bool sent,) = _from.call{value: getCost(_tokenId)*1e18 }("eruare");
    if(!sent){ 
        require(sent,"not enough gas");
        //emit OwnerChangedFailed();
    }
    else {
        changeOwnerForAsset(_tokenId, _from, _to);
        // emit OwnerChanged();  // todo
    }
  }
 
  
  function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external payable{
      
  }
  
  function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) override external payable{
      
  }
  
  


    
}