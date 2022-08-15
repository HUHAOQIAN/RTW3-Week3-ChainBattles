// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct Characters {
        uint256 levels;
        uint256 hp;
        uint256 strength;
        uint256 speed;
    }
    mapping(uint256 => Characters) public tokenIdToCharacters;

    //track levels
    //track hp
    //track strength
    //track speed

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevel(tokenId),
            "Hp:",
            getHp(tokenId),
            "Strength:",
            getStrength(tokenId),
            "speed:",
            getSpeed(tokenId),
            "</text>",
            "</svg>"
        );
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getCharacters(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        Characters memory characters = tokenIdToCharacters[tokenId];
        uint256 levels = characters.levels;
        uint256 hp = characters.hp;
        uint256 strength = characters.strength;
        uint256 speed = characters.speed;
        return (levels, hp, strength, speed);
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        (uint256 levels, , , ) = getCharacters(tokenId);
        return levels.toString();
    }

    function getHp(uint256 tokenId) public view returns (string memory) {
        (, uint256 hp, , ) = getCharacters(tokenId);
        return hp.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        (, , uint256 strength, ) = getCharacters(tokenId);
        return strength.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        (, , , uint256 speed) = getCharacters(tokenId);
        return speed.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToCharacters[newItemId] = Characters(0, 100, 200, 300);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function rand(uint256 _length) internal view returns (uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
        return random % _length;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        Characters memory currentCharacter = tokenIdToCharacters[tokenId];
        tokenIdToCharacters[tokenId].levels = currentCharacter.levels + 1;
        tokenIdToCharacters[tokenId].hp = currentCharacter.hp + rand(100);
        tokenIdToCharacters[tokenId].strength = currentCharacter.strength + rand(50);
        tokenIdToCharacters[tokenId].speed = currentCharacter.speed + rand(80);

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
