// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
import "./Ownable.sol";

contract Assets is Ownable{
   
   struct Asset{
       string name;
       string game;
       string asset_type;
       uint cost;
       bool forSale;
       bool forBid;
   }
   
   Asset[] internal asset_list;
   
   mapping (uint => address) assetToOwner;
   mapping (address => uint) ownerAssetCount;
   
   function _createAsset(Asset memory asset) internal {
        asset_list.push(asset);
        uint id = asset_list.length - 1;
        assetToOwner[id] = msg.sender;
        ownerAssetCount[msg.sender]++;
    }
    
    function _getOwnerFromAssetId(uint256 id) internal view returns (address){
        return assetToOwner[id];
    }
    
    function _getOwnerAssetCount(address ownerAdress) internal view returns (uint256){
        return ownerAssetCount[ownerAdress];
    }
    
    function _changeOwnerForAsset(uint256 id, address oldOwner, address newOwner) internal{
        assetToOwner[id] = newOwner;
        ownerAssetCount[oldOwner]--;
        ownerAssetCount[newOwner]++;
        asset_list[id].forSale = false;
    }
    
    function _setForSaleForAsset(uint asset_id, bool forSale) internal {
        asset_list[asset_id].forSale = forSale;
    }
    
    function _getAssetForSaleForAsset(uint asset_id) public view returns (bool){
        return asset_list[asset_id].forSale;
    }
    
    function _setCostForAsset(uint asset_id, uint cost) internal {
        asset_list[asset_id].cost = cost;
    }
    
    function _getCostForAsset(uint asset_id) public view returns(uint){
        return asset_list[asset_id].cost;
    }
    
    function _setAssetForBid(uint asset_id, bool forBid) internal {
        asset_list[asset_id].forBid = forBid;
    }
    
    function _getAssetForBid(uint asset_id) public view returns(bool) {
        return asset_list[asset_id].forBid;
    }
    
    
    

}
