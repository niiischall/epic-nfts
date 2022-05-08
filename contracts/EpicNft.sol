// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract EpicNft is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Bulbasaur",
        "Charmander",
        "Squirtle",
        "Pikachu",
        "Wigglytuff",
        "Snorlax"
    ];
    string[] secondWords = [
        "Amanpreet",
        "Bhaskar",
        "Dalbir",
        "Girish",
        "Madhav",
        "Navjot"
    ];
    string[] thirdWords = [
        "Tiramisu",
        "Cheesecake",
        "Mousse",
        "Pie",
        "Tart",
        "Pudding"
    ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("EpicNft smart constructor");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function randomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 randomFirst = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        randomFirst = randomFirst % firstWords.length;
        return firstWords[randomFirst];
    }

    function randomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 randomSecond = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        randomSecond = randomSecond % secondWords.length;
        return secondWords[randomSecond];
    }

    function randomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 randomThird = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        randomThird = randomThird % thirdWords.length;
        return thirdWords[randomThird];
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = randomFirstWord(newItemId);
        string memory second = randomSecondWord(newItemId);
        string memory third = randomThirdWord(newItemId);

        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "An NFT with ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        _tokenIds.increment();
    }
}
