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

    // instantiate merkle roots for all attendee types
    bytes32 public hackerMerkleRoot;
    bytes32 public generalMerkleRoot;
    bytes32 public teamMerkleRoot;
    bytes32 public speakerMerkleRoot;

    // instantiate attendee type for a tokenID. Used to set uri's.
    mapping(uint256 => AttendeeTypes) tokenType;

    // instantiate owner for a tokenID
    mapping(uint256 => address) public tokenOwner;

    // instantiate token claimed by address
    mapping(address => bool) public hackerClaimed;
    mapping(address => bool) public generalClaimed;
    mapping(address => bool) public teamClaimed;
    mapping(address => bool) public speakerClaimed;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        bytes32 _hackerMerkleRoot,
        bytes32 _generalMerkleRoot,
        bytes32 _teamMerkleRoot,
        bytes32 _speakerMerkleRoot
    ) ERC721(_name, _symbol) {
        tokenID = 0;
        baseURI = _baseURI;
        _setMerkleRoots(_hackerMerkleRoot, _generalMerkleRoot, _teamMerkleRoot, _speakerMerkleRoot);
    }

    /// @notice mint function for hackathon participants
    /// @param _hackerProof merkle tree proof
    function hackerMint(bytes32[] calldata _hackerProof) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProofLib.verify(_hackerProof, leaf, hackerMerkleRoot),
            "You are not a hacker"
        );
        require(!hackerClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.HACKER;
        hackerClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for general participants
    /// @param _generalProof merkle tree proof
    function generalMint(bytes32[] calldata _generalProof) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProofLib.verify(_generalProof, leaf, generalMerkleRoot),
            "You are not a general attendee"
        );
        require(!generalClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.GENERAL;
        generalClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for team
    /// @param _teamProof merkle tree proof
    function teamMint(bytes32[] calldata _teamProof) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProofLib.verify(_teamProof, leaf, teamMerkleRoot),
            "You are not a team member"
        );
        require(!teamClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.TEAM;
        teamClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice mint function for speakers
    /// @param _speakerProof merkle tree proof
    function speakerMint(bytes32[] calldata _speakerProof) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProofLib.verify(_speakerProof, leaf, speakerMerkleRoot),
            "You are not a speaker"
        );
        require(!speakerClaimed[msg.sender], "You already claimed your token");
        _mint(msg.sender, tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenType[tokenID] = AttendeeTypes.SPEAKER;
        speakerClaimed[msg.sender] = true;
        tokenID++;
    }

    /// @notice sets the merkle roots for all attendee types
    function _setMerkleRoots(
        bytes32 _hackerMerkleRoot,
        bytes32 _generalMerkleRoot,
        bytes32 _teamMerkleRoot,
        bytes32 _speakerMerkleRoot
    ) private {
        hackerMerkleRoot = _hackerMerkleRoot;
        generalMerkleRoot = _generalMerkleRoot;
        teamMerkleRoot = _teamMerkleRoot;
        speakerMerkleRoot = _speakerMerkleRoot;
    }

    /// @notice sets the merkle roots for all attendee types
    function setMerkleRoots(
        bytes32 _hackerMerkleRoot,
        bytes32 _generalMerkleRoot,
        bytes32 _teamMerkleRoot,
        bytes32 _speakerMerkleRoot
    ) external onlyOwner {
        _setMerkleRoots(_hackerMerkleRoot, _generalMerkleRoot, _teamMerkleRoot, _speakerMerkleRoot);
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
                "/",
                Strings.toString(id),
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
