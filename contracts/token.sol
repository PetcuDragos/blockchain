// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./erc721.sol";
import "./Assets.sol";

contract Token is erc721 {
    
    Assets assetsContract;
    uint transferFee;
    
    constructor(){
        transferFee = 0.001;
    }

  function setAssetsContractAddress(address _address) external onlyOwner {
    assetsContract = Assets(_address);
  }
    
  function balanceOf(address _owner) external view returns (uint256) {
     return assetsContract.getOwnerAssetCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return assetsContract.getOwnerFromAssetId[_tokenId];
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    // In this case the sender of the token calls the transferFrom function
    require (assetsContract.getOwnerFromAssetId(_tokenId) == _from);
    require (assetsContract.getForSale(_tokenId) == true);
    require (_from != _to);
    assetsContract.owner().send(transferFee);
    assetsContract.changeOwnerForAsset(_tokenId, _from, _to);
    // emit OwnerChanged();  // todo
  }

  function approve(address _approved, uint256 _tokenId) external payable {
        require (assetsContract.getOwnerFromAssetId(_tokenId) == _approved);
        assetsContract.owner().send(transferFee);
        emit Approval(msg.sender, _approved, _tokenId);
  }


    
}