// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Bidding{
    
    struct Bid{
        uint token_id;
        uint start_time;
        uint duration;
        uint starting_price;
        uint currentBest;
        address buyer;
        bool isSold;
    }
    
    Bid[] biddings;
    
        
    function _createBid(uint _token_id, uint current_time, uint duration , uint starting_price) internal {
        biddings.push(Bid(_token_id, current_time ,duration,starting_price,0,address(0),false));
    }
    
    function _makeBid(uint _bid_id, uint money) internal {
        biddings[_bid_id].buyer = msg.sender;
        biddings[_bid_id].currentBest = money;
    }
    
    function getNumberOfBids() view internal returns (uint){
        return biddings.length;
    }
    
    function setBidIsSold(uint bid_id, bool value) internal{
        biddings[bid_id].isSold = value;
    }
    
    function setBidCurrentBest(uint bid_id, uint value) internal{
        biddings[bid_id].currentBest = value;
    }
    
    function setBidBuyer(uint bid_id, address new_buyer) internal{
        biddings[bid_id].buyer = new_buyer;
    }
    
    function getBidFromId(uint bid_id) view internal returns(Bid memory){
        return biddings[bid_id];
    }
}