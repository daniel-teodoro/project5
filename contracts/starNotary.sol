pragma solidity ^0.4.23;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {

    struct Star {
        string name;
        string symbol;
    }

// Add a name and a symbol for your starNotary tokens
    string public name = "Awesome Star!";
    string public symbol = "AWE";

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => address) public _tokenOwner;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, string _symbol, uint256 _tokenId) public {
        Star memory newStar = Star(_name, _symbol);
        tokenIdToStarInfo[_tokenId] = newStar;
        _tokenOwner[_tokenId] = msg.sender;
        _mint(msg.sender, _tokenId);
    }

// Add a function lookUptokenIdToStarInfo, that looks up the stars using the Token ID, and then returns the name of the star.
    function lookUptokenIdToStarInfo(uint256 _tokenId) public view returns (string Name, string Symbol, address Owner) {
        Star memory star = tokenIdToStarInfo[_tokenId];
        return (star.name, star.symbol, _tokenOwner[_tokenId]);
    }    
//

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
        starsForSale[_tokenId] = 0;
      }

// Add a function called exchangeStars, so 2 users can exchange their star tokens...
//Do not worry about the price, just write code to exchange stars between users.
    function exchangeStars(uint256 _tokenIdSend, uint256 _tokenIdReceive) public payable {

        require(ownerOf(_tokenIdSend) == msg.sender);

        _removeTokenFrom(_tokenOwner[_tokenIdSend], _tokenIdSend);
        _removeTokenFrom(_tokenOwner[_tokenIdReceive], _tokenIdReceive);
        
        _addTokenTo(_tokenOwner[_tokenIdReceive], _tokenIdSend);
        _addTokenTo(_tokenOwner[_tokenIdSend], _tokenIdReceive);

        starsForSale[_tokenIdSend] = 0;
        starsForSale[_tokenIdReceive] = 0;

    }
    
//

// Write a function to Transfer a Star. The function should transfer a star from the address of the caller.
// The function should accept 2 arguments, the address to transfer the star to, and the token ID of the star.
//
  function transferStar(uint256 _tokenId, address _toAddress) public  {

        require(ownerOf(_tokenId) == msg.sender);

        _removeTokenFrom(_tokenOwner[_tokenId], _tokenId);
        _addTokenTo(_toAddress, _tokenId);

        _tokenOwner[_tokenId] = _toAddress;

    }

}
