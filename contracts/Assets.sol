// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
import "./Ownable.sol";

contract Assets is Ownable{
   
   event NewAsset(string name, string game, string asset_type);
   
   struct Asset{
       string name;
       string game;
       string asset_type;
   }
   
   Asset[] public asset_list;
   
   mapping (uint => address) public assetToOwner;
   mapping (address => uint) ownerAssetCount;
   
   function _createAsset(string memory name, string memory game, string memory asset_type) internal {
        asset_list.push(Asset(name,game,asset_type));
        uint id = asset_list.length - 1;
        assetToOwner[id] = msg.sender;
        ownerAssetCount[msg.sender]++;
        emit NewAsset(name,game,asset_type);
    }
    
    function showMessage() pure public returns(uint){
        return 5;
    }
    
    
    // function _generateId(string memory _str) private view returns (uint) {
    //     uint rand = uint(keccak256(abi.encodePacked(_str)));
    //     return rand % dnaModulus;
    // }

}
