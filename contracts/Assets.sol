// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
import "./Ownable.sol";

contract Assets is Ownable{
   
   event NewAsset(string name, string game, string asset_type, uint cost);
   
   struct Asset{
       string name;
       string game;
       string asset_type;
       uint cost;
       bool forSale;
   }
   
   Asset[] internal asset_list;
   
   mapping (uint => address) assetToOwner;
   mapping (address => uint) ownerAssetCount;
   
   function _createAsset(Asset memory asset) internal {
        asset_list.push(asset);
        uint id = asset_list.length - 1;
        assetToOwner[id] = msg.sender;
        ownerAssetCount[msg.sender]++;
        emit NewAsset(asset.name,asset.game,asset.asset_type,asset.cost);
    }
    
    function getOwnerFromAssetId(uint256 id) internal view returns (address){
        return assetToOwner[id];
    }
    
    function getOwnerAssetCount(address ownerAdress) internal view returns (uint256){
        return ownerAssetCount[ownerAdress];
    }
    
    function changeOwnerForAsset(uint256 id, address oldOwner, address newOwner) internal{
        assetToOwner[id] = newOwner;
        ownerAssetCount[oldOwner]--;
        ownerAssetCount[newOwner]++;
        asset_list[id].forSale = false;
    }
    
    function setForSale(uint asset_id, bool forSale) public {
        require(assetToOwner[asset_id] == msg.sender);
        asset_list[asset_id].forSale = forSale;
    }
    
    function getForSale(uint asset_id) public view returns (bool){
        return asset_list[asset_id].forSale;
    }
    
    function setCost(uint asset_id, uint cost) public {
        require(assetToOwner[asset_id] == msg.sender);
        asset_list[asset_id].cost = cost;
    }
    
    function getCost(uint asset_id) public view returns(uint){
        return asset_list[asset_id].cost;
    }
    
    
    

}
