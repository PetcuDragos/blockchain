// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
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
   
   Asset[] public asset_list;
   
   mapping (uint => address) assetToOwner;
   mapping (address => uint) ownerAssetCount;
   
   function _createAsset(string memory name, string memory game, string memory asset_type, uint cost) public onlyOwner {
        asset_list.push(Asset(name,game,asset_type,cost,true));
        uint id = asset_list.length - 1;
        assetToOwner[id] = msg.sender;
        ownerAssetCount[msg.sender]++;
        emit NewAsset(name,game,asset_type,cost);
    }
    
    function getOwnerFromAssetId(uint256 id) external view returns (address){
        return assetToOwner[id];
    }
    
    function getOwnerAssetCount(address ownerAdress) external view returns (uint256){
        return ownerAssetCount[ownerAdress];
    }
    
    function changeOwnerForAsset(uint256 id, address oldOwner, address newOwner) external{
        assetToOwner[id] = newOwner;
        ownerAssetCount[oldOwner]--;
        ownerAssetCount[newOwner]++;
        asset_list[id].forSale = false;
    }
    
    function setForSale(uint asset_id, bool forSale) external {
        asset_list[asset_id].forSale = forSale;
    }
    
    function getForSale(uint asset_id) external view returns (bool){
        return asset_list[asset_id].forSale;
    }
    
    function setCost(uint asset_id, uint cost) external {
        asset_list[asset_id].cost = cost;
    }
    
    function getCost(uint asset_id) external view returns(uint){
        return asset_list[asset_id].cost;
    }
    
    
    

}
