// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
import "./erc721.sol";
import "./Assets.sol";

contract Service is ERC721,Assets {

    event NewAsset(string name, string game, string asset_type, uint cost);
    event OwnerChanged(uint token_id);
    event TransferFailed(string error);
    event AssetForSale(uint token_id, bool value);
    event AssetCost(uint token_id, uint256 value);
    uint256 transferFee;
    uint256 addFee;
    
    constructor(){
        addFee = 1;
        transferFee = 1;
    }
    
    function createAsset(string memory name, string memory game, string memory asset_type, uint cost) public payable{
        require(msg.value == addFee, "The fee for creating asset is 1 wei");
        (bool sent,) = owner().call{value: addFee}("");
        require(sent, "add fee couldn't be payed");
        Asset memory asset = Asset(name,game,asset_type,cost,true);
        _createAsset(asset);
        emit NewAsset(name,game,asset_type,cost);
    }
    
    function balanceOf(address _owner) override external view returns (uint256) {
        uint256 result = _getOwnerAssetCount(_owner);
        return result;
    }

    function ownerOf(uint256 _tokenId) override external view returns (address) {
        return _getOwnerFromAssetId(_tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override external payable {
        require (_getOwnerFromAssetId(_tokenId) == _from, "from address is not owner of tokenId");
        require (asset_list[_tokenId].forSale == true, "the token is not for sale");
        require (_from != _to, "cannot transfer from == to");
        require (msg.value >= _getCostForAsset(_tokenId), string(abi.encodePacked("The cost of this asset is ", _getCostForAsset(_tokenId), " wei")));
        require (msg.value >= _getCostForAsset(_tokenId) + transferFee, string(abi.encodePacked("The transfer fee must be added of ", transferFee, " wei")));
        (bool sentMoneyForAsset,) = _from.call{value: _getCostForAsset(_tokenId) }("");
        (bool sentMoneyForFee,) = owner().call{value: _getCostForAsset(_tokenId) }("");
        if(!sentMoneyForAsset || !sentMoneyForFee){ 
            emit TransferFailed("not enough gas"); // todo
        }
        else {
            _changeOwnerForAsset(_tokenId, _from, _to);
            emit OwnerChanged(_tokenId);  // todo
        }
    }
    
    function setAssetForSale(uint256 _tokenId, bool value) external{
        require(_getOwnerFromAssetId(_tokenId) == msg.sender);
        _setForSaleForAsset(_tokenId, value);
        emit AssetForSale(_tokenId,value);
    }
    
    function setCostForAsset(uint256 _tokenId, uint256 value) external{
        require(_getOwnerFromAssetId(_tokenId) == msg.sender);
        _setCostForAsset(_tokenId, value);
        emit AssetCost(_tokenId,value);
    }
    
    function getTotalNumberOfAssets() external view returns (uint256){
        return asset_list.length;
    }
    
    
}