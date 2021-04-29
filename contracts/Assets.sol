// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Asset is Ownable{
   
   struct Asset{
       string name;
       string id;
       string game;
       string type;
   }
   
   Asset[] public assets;
   
   mapping (uint => address) public assetToOwner;
   mapping (address => uint) ownerAssetCount;
   
   function _createAsset(string memory _name, uint id, string memory game, string memory type) internal {
        uint id = assets.push(Asset(_name,id,_game,_type));
        assetToOwner[asset.id] = msg.sender;
        ownerAssetCount[msg.sender]++;
        emit NewAsset(_name,id,_game,_type);
    }

    // function _generateRandomDna(string memory _str) private view returns (uint) {
    //     uint rand = uint(keccak256(abi.encodePacked(_str)));
    //     return rand % dnaModulus;
    // }

    // function createRandomA(string memory _name) public {
    //     require(ownerZombieCount[msg.sender] == 0);
    //     uint randDna = _generateRandomDna(_name);
    //     randDna = randDna - randDna % 100;
    //     _createZombie(_name, randDna);
    // }
}
