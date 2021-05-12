// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
import "./erc721.sol";
import "./Assets.sol";
import "./Bidding.sol";

contract Service is ERC721,Assets,Bidding {

    event NewAsset(string name, string game, string asset_type, uint cost);
    event OwnerChanged(uint token_id);
    event TransferFailed(string error);
    event AssetForSale(uint token_id, bool value);
    event AssetCost(uint token_id, uint256 value);
    event NewBidding(uint token_id,uint start_time,uint duration,uint starting_price);
    event HigherBidder(uint bid_id,uint newBest);
    
    uint256 transferFee;
    uint256 addFee;
    uint256 create_bid_Fee;
    
    constructor(){
        addFee = 1;
        transferFee = 1;
        create_bid_Fee = 3;
    }
    
    function createAsset(string memory name, string memory game, string memory asset_type, uint cost) public payable{
        require(msg.value == addFee, "The fee for creating asset is 1 wei");
        (bool sent,) = owner().call{value: addFee}("");
        require(sent, "add fee couldn't be payed");
        Asset memory asset = Asset(name,game,asset_type,cost,true,false);
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
    
    function changeAddFee(uint newAddFee) public onlyOwner {
        addFee = newAddFee;
    }

    function changeTransferFee(uint newTransferFee) public onlyOwner{
        transferFee = newTransferFee;
    }
    
    function buyAsset(uint256 _tokenId) public payable{
        address _to = msg.sender;
        address _from = _getOwnerFromAssetId(_tokenId);
        transferFrom(_from,_to,_tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
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
    
    
    
    function setAssetForSale(uint256 _tokenId, bool value) public{
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
        require(_getOwnerFromAssetId(_tokenId) == msg.sender);
        _setForSaleForAsset(_tokenId, value);
        emit AssetForSale(_tokenId,value);
    }
    
    function setCostForAsset(uint256 _tokenId, uint256 value) public{
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
        require(_getOwnerFromAssetId(_tokenId) == msg.sender);
        require(_getAssetForSaleForAsset(_tokenId) == false);
        _setCostForAsset(_tokenId, value);
        emit AssetCost(_tokenId,value);
    }
    
    function getTotalNumberOfAssets() public view returns (uint256){
        return asset_list.length;
    }
    
    function getAssetFromId(uint _tokenId) view  public returns (Asset memory){
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
        return asset_list[_tokenId];
    }
    
    function createBid(uint _tokenId, uint duration, uint starting_price) payable public{
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
        require(_getOwnerFromAssetId(_tokenId) == msg.sender);
        require(_getAssetForSaleForAsset(_tokenId) == false); 
        require(_getAssetForBid(_tokenId) == false); 
        require(msg.value == create_bid_Fee, "The fee for creating a bid is 1 wei");
        (bool sent,) = owner().call{value: create_bid_Fee}("");
        require(sent, "create bid fee couldn't be payed");
        uint current_time = block.timestamp;
        _setAssetForBid(_tokenId,true);
        _createBid(_tokenId,current_time,duration,starting_price);
        emit NewBidding(_tokenId, current_time , duration , starting_price );
    }
    
    function makeBid(uint _bid_id, uint money) public payable{
        require(_bid_id >= 0 && _bid_id < getNumberOfBids() );
        require(msg.sender != _getOwnerFromAssetId(getBidFromId(_bid_id).token_id));
        uint current_time = block.timestamp;
        Bid memory b = getBidFromId(_bid_id);
        require(b.start_time  + b.duration >= current_time);
        require(b.currentBest < money && b.starting_price <= money);
        if (b.currentBest != 0){
            (bool sentBiddingMoneyToPreviousBuyer,) = b.buyer.call{value: b.currentBest }("");
            require(sentBiddingMoneyToPreviousBuyer, "the prev buyer was not payed");
        }
        (bool sentBiddingMoneyToOwner,) = _getOwnerFromAssetId(getBidFromId(_bid_id).token_id).call{value: money-b.currentBest }("");
        require(sentBiddingMoneyToOwner, "the contract was not payed");
        _makeBid(_bid_id,money);
        emit HigherBidder(_bid_id,money);
    }
    
    function terminateBid(uint _bid_id) internal{
        require(msg.sender == getBidFromId(_bid_id).buyer, "you cannot terminate this bid");
        require(_bid_id >= 0 && _bid_id < getNumberOfBids() );
        require(getBidFromId(_bid_id).isSold == false, "the item was already sold");
        uint current_time = block.timestamp;
        Bid memory b = getBidFromId(_bid_id);
        require(b.start_time  + b.duration < current_time);
        setBidIsSold(_bid_id, true);
        transferAsset(_getOwnerFromAssetId(getBidFromId(_bid_id).token_id), getBidFromId(_bid_id).buyer, getBidFromId(_bid_id).token_id);
        
    }
    
    function transferAsset(address _from, address _to, uint _tokenId) internal{
        require(_tokenId >= 0 && _tokenId < getTotalNumberOfAssets() );
        require (_getOwnerFromAssetId(_tokenId) == _from, "from address is not owner of tokenId");
        require (asset_list[_tokenId].forSale == false, "the token is not for sale");
        require (asset_list[_tokenId].forBid == true, "the token is not for bid");
        require (_from != _to, "cannot transfer from == to");
        _changeOwnerForAsset(_tokenId, _from, _to);
        asset_list[_tokenId].forBid = false;
    }
    
    function isOwnerOfAsset(uint _tokenId) view external returns(bool){
        if(msg.sender == _getOwnerFromAssetId(_tokenId)){
            return true;
        }
        return false;
    }
    
}