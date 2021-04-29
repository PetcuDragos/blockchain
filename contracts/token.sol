// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./erc721.sol";
import "./Assets.sol";

contract Token is erc721 {
    
  function balanceOf(address _owner) external view returns (uint256) {
     return ownerAssetCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return assetToOwner[_tokenId];
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    // In this case the sender of the token calls the transferFrom function
  }

  function approve(address _approved, uint256 _tokenId) external payable {
    // in this case the owner or the approved receiver of the token calls it.
  }


    
}