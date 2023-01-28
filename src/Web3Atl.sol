// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "solmate/utils/Bytes32AddressLib.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/access/Ownable.sol";
import "solmate/utils/MerkleProofLib.sol";

contract Web3Atl is ERC721, Ownable {
    uint256 public tokenID;
    string public baseURI;

    enum AttendeeTypes {
        HACKER,
        GENERAL,
        TEAM,
        SPEAKER
    }

    // instantiate attendee type for a tokenID. Used to set uri's.
    mapping(uint256 => AttendeeTypes) public tokenType;

    // instantiate owner for a tokenID
    mapping(uint256 => address) public tokenOwner;

    // instantiate token claimed by address
    mapping(address => bool) public hackerClaimed;
    mapping(address => bool) public generalClaimed;
    mapping(address => bool) public teamClaimed;
    mapping(address => bool) public speakerClaimed;

    constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) {
        tokenID = 0;
        baseURI = _baseURI;
    }

    /// @notice mint function for hackathon participants
    function hackerMint() public {
        require(!hackerClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.HACKER;
        hackerClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for general participants
    function generalMint() public {
        require(!generalClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.GENERAL;
        generalClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for team
    function teamMint() public {
        require(!teamClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.TEAM;
        teamClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for speakers
    function speakerMint() public {
        require(!speakerClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.SPEAKER;
        speakerClaimed[msg.sender] = true;
        tokenID++;
    }

    ///////////////////////////////////////////////////////////////////////////
    ///////////////// URI AND METADATA ///////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    /// @notice sets the base uri
    /// @param _uri new string with the format ipfs://gateaway
    function setBaseURI(string memory _uri) external onlyOwner {
        baseURI = _uri;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return
            string.concat(
                baseURI,
                "/",
                Strings.toString(uint256(tokenType[id])),
                ".json"
            );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///////////////////// OVERRIDE TRANSFERS ///////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public override {
        revert("This token cant be transfered");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public override {
        revert("This token cant be transfered");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) public override {
        revert("This token cant be transfered");
    }
}
