
contract Bidding{
    
    event NewBidding(uint token_id,uint start_time,uint duration,uint starting_price);
    event HigherBidder(uint bid_id,uint newBest);
    
    struct Bid{
        uint token_id;
        uint start_time;
        uint duration;
        uint currentBest;
        address buyer;
        bool isSold;
    }
    
    
    
    Bid[] biddings;
    
        
    function createBid(uint _token_id,uint duration , uint starting_price) internal {
        //  require msg.sender == ownerOf(_token_id)  comunicare cu contractul service
        uint i;
        uint current_time = block.timestamp;
        for(i=0; i <biddings.length ;++i)
                if( biddings[i].token_id == _token_id)
                    require(biddings[i].start_time + duration < current_time && biddings[i].isSold == true);
        
        biddings.push( Bid(_token_id, current_time ,duration,starting_price,address(0),false));
        emit NewBidding(_token_id, current_time , duration , starting_price );
    }
    
    
    function makeBid(uint _bid_id, uint money) internal {
        //require(  _bid_id >= 0 && _bid_id < biddings.length );
        // require( msg.sender != ownerOf(biddings[_bid_id].token_id) )
        //uint current_time = block.timestamp;
        //require(  biddings[_bid_id].start_time  + biddings[_bid_id].duration >= current_time );
        //require( biddings[_bid_id].currentBest < money );
        // require are bani sa plateasca
        // sa faca cumva lock la banuti
        
        biddings[_bid_id].buyer = msg.sender;
        biddings[_bid_id].currentBest = money;
        emit HigherBidder(_bid_id,money);
    }
}   