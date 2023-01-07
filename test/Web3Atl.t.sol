// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Web3Atl.sol";
import "solmate/utils/MerkleProofLib.sol";

contract Web3AtlTest is Test {
    Web3Atl public web3atl;
    string public baseURI = "http://www.google.com";
    
    bytes32 merkleRootHacker = 0xb4fbf216f54d8076e21c170049082954cc613623e76fb5aab2acce1daeae683a;
    bytes32 merkleRootGeneral = 0x4d3fcb52d31462529df063f8a5bd68dcca0642f9eb1c686676c8f79b8f3b2e81;
    bytes32 merkleRootTeam = 0x1fa1b44ca84213104080ce844322b0ed53acb13304413773f6f3b23d34fbd434;
    bytes32 merkleRootSpeaker = 0x91b8f47511578845af7aa2a841fa49dfefe81f5fa7180a9579af282f94610d44;

    function setUp() public {
        web3atl = new Web3Atl('Web3Atl Attendees','W3ATL', baseURI, merkleRootHacker, merkleRootGeneral, merkleRootTeam, merkleRootSpeaker);
    }

    function testBaseURIAfterSetUp() public {
        assertEq(web3atl.baseURI(), baseURI);
    }

    function testSetBaseURI(string memory newBaseURI) public {
        web3atl.setBaseURI(newBaseURI);
        assertEq(web3atl.baseURI(), newBaseURI);
    }

    function testSetBaseURINotOwner(address addr, string memory newBaseURI) public {
        vm.prank(addr);
        vm.expectRevert();
        web3atl.setBaseURI(newBaseURI);
    }

    function testHackerMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);
        
        assertEq(web3atl.tokenOwner(tokenID), hackerAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.HACKER);
        assert(web3atl.hackerClaimed(hackerAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testHackerCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);
        
        vm.prank(hackerAddress);
        vm.expectRevert();
        web3atl.hackerMint(proof);
    }

    function testHackerMintInvalidAddressAndProof(bytes32[] memory proof) public {
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        vm.expectRevert();
        web3atl.hackerMint(proof);
    }

    function testGeneralMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x3aa681f45a864d97845dc2341b9aa2ca3ad6f4c512b6a324caf7625fe6e17ba4;
        proof[1] = 0x3c2715b13dbf00e2e7599f4db973e15c5f22ccde8b5fbb56363b47b7b3c19307;
        proof[2] = 0xde127622dbe22a3b21641fc6d27aaa4d4cae7cc5dd5287a81f2352d272b28d60;
        proof[3] = 0x3361b6655670e8cd9453722e2beb88101d9f6f821620e0f051aa5fed75273aa1;
        
        address generalAddress = 0x4A5f78Ebe62CcCbA6698BED7D878846ad947A513;
        vm.prank(generalAddress);
        web3atl.generalMint(proof);
        
        assertEq(web3atl.tokenOwner(tokenID), generalAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.GENERAL);
        assert(web3atl.generalClaimed(generalAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testGeneralCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x3aa681f45a864d97845dc2341b9aa2ca3ad6f4c512b6a324caf7625fe6e17ba4;
        proof[1] = 0x3c2715b13dbf00e2e7599f4db973e15c5f22ccde8b5fbb56363b47b7b3c19307;
        proof[2] = 0xde127622dbe22a3b21641fc6d27aaa4d4cae7cc5dd5287a81f2352d272b28d60;
        proof[3] = 0x3361b6655670e8cd9453722e2beb88101d9f6f821620e0f051aa5fed75273aa1;
        
        address generalAddress = 0x4A5f78Ebe62CcCbA6698BED7D878846ad947A513;
        vm.prank(generalAddress);
        web3atl.generalMint(proof);
        
        vm.prank(generalAddress);
        vm.expectRevert();
        web3atl.generalMint(proof);
    }

    function testGeneralMintInvalidAddressAndProof(bytes32[] memory proof) public {
        address generalAddress = 0x4A5f78Ebe62CcCbA6698BED7D878846ad947A513;
        vm.prank(generalAddress);
        vm.expectRevert();
        web3atl.generalMint(proof);
    }
    
    function testTeamMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0xad8c33e774d72922c432a84b04cd50002dc4fd8132f2c15026badc9af139a78a;
        proof[1] = 0x51e301f9a1a65b6bfdc6dde3abf457c998378a4c171654b8f6f4a52d921e6ba5;
        proof[2] = 0x258f6d28136116795a2538071df3d61c3d291eb705e4cf54b559f08980a93c44;
        proof[3] = 0x28572302ba5c6b91c6ef2a49e675f5648b0e83483903863cf7fd9f4202d0e384;
        
        address teamAddress = 0xF3dD322E9548C48717Cf2c2C0DED600e4663AC64;
        vm.prank(teamAddress);
        web3atl.teamMint(proof);
        
        assertEq(web3atl.tokenOwner(tokenID), teamAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.TEAM);
        assert(web3atl.teamClaimed(teamAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testTeamCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0xad8c33e774d72922c432a84b04cd50002dc4fd8132f2c15026badc9af139a78a;
        proof[1] = 0x51e301f9a1a65b6bfdc6dde3abf457c998378a4c171654b8f6f4a52d921e6ba5;
        proof[2] = 0x258f6d28136116795a2538071df3d61c3d291eb705e4cf54b559f08980a93c44;
        proof[3] = 0x28572302ba5c6b91c6ef2a49e675f5648b0e83483903863cf7fd9f4202d0e384;
        
        address teamAddress = 0xF3dD322E9548C48717Cf2c2C0DED600e4663AC64;
        vm.prank(teamAddress);
        web3atl.teamMint(proof);
        
        vm.prank(teamAddress);
        vm.expectRevert();
        web3atl.teamMint(proof);
    }

    function testTeamMintInvalidAddressAndProof(bytes32[] memory proof) public {
        address teamAddress = 0xF3dD322E9548C48717Cf2c2C0DED600e4663AC64;
        vm.prank(teamAddress);
        vm.expectRevert();
        web3atl.teamMint(proof);
    }

    function testSpeakerMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0xbc4604c224b8f02a5cb121b11860cac16d460942971558d99c3b28151ff6195c;
        proof[1] = 0x7a03abb19f5b606aeabe37c940010ed150ce0c9d1080c847bcba06652be93d20;
        proof[2] = 0x4c3840bc5d26b526b7859a60563e28bbeb901d087803855af0aaf00556744838;
        proof[3] = 0x948c4f23df5e9ed19debfbb6f9493ba7a2b8cf747862149cbb4334cebb735b35;
        
        address speakerAddress = 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf;
        vm.prank(speakerAddress);
        web3atl.speakerMint(proof);
        
        assertEq(web3atl.tokenOwner(tokenID), speakerAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.SPEAKER);
        assert(web3atl.speakerClaimed(speakerAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testSpeakerCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0xbc4604c224b8f02a5cb121b11860cac16d460942971558d99c3b28151ff6195c;
        proof[1] = 0x7a03abb19f5b606aeabe37c940010ed150ce0c9d1080c847bcba06652be93d20;
        proof[2] = 0x4c3840bc5d26b526b7859a60563e28bbeb901d087803855af0aaf00556744838;
        proof[3] = 0x948c4f23df5e9ed19debfbb6f9493ba7a2b8cf747862149cbb4334cebb735b35;
        
        address speakerAddress = 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf;
        vm.prank(speakerAddress);
        web3atl.speakerMint(proof);
        
        vm.prank(speakerAddress);
        vm.expectRevert();
        web3atl.speakerMint(proof);
    }

    function testSpeakerMintInvalidAddressAndProof(bytes32[] memory proof) public {
        address speakerAddress = 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf;
        vm.prank(speakerAddress);
        vm.expectRevert();
        web3atl.speakerMint(proof);
    }

    function testSetMerkleRoot(bytes32 newMerkleRootHacker, bytes32 newMerkleRootGeneral, bytes32 newMerkleRootTeam, bytes32 newMerkleRootSpeaker) public {
        web3atl.setMerkleRoots(newMerkleRootHacker, newMerkleRootGeneral, newMerkleRootTeam, newMerkleRootSpeaker);

        assertEq(web3atl.hackerMerkleRoot(), newMerkleRootHacker);
        assertEq(web3atl.generalMerkleRoot(), newMerkleRootGeneral);
        assertEq(web3atl.teamMerkleRoot(), newMerkleRootTeam);
        assertEq(web3atl.speakerMerkleRoot(), newMerkleRootSpeaker);
    }

    function testSetMerkleRootNotOwner(address addr, bytes32 newMerkleRootHacker, bytes32 newMerkleRootGeneral, bytes32 newMerkleRootTeam, bytes32 newMerkleRootSpeaker) public {
        vm.prank(addr);
        vm.expectRevert();
        web3atl.setMerkleRoots(newMerkleRootHacker, newMerkleRootGeneral, newMerkleRootTeam, newMerkleRootSpeaker);
    }

    function testTokenURI() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);
        
        assertEq(web3atl.tokenURI(tokenID), string.concat(
                baseURI,
                "/",
                Strings.toString(uint256(web3atl.tokenType(tokenID))),
                ".json"
            ));
    }

    function testTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);

        vm.expectRevert();
        web3atl.transferFrom(hackerAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);

        vm.expectRevert();
        web3atl.safeTransferFrom(hackerAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFromWithCallData(bytes calldata data) public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](4);
        proof[0] = 0x352f9bffc6f7900ed10f105a5e8532b7d1cd1170b7b0ef8a5947abe23d0b5c80;
        proof[1] = 0xac9dd2bb6d49a1329e0ae183b4ab51347054955da9284b22cabde012aa8ddcfa;
        proof[2] = 0xbd8808a2894ea6811d9770eb3da1727152d2c5276d614fc3e0236e5003f3fa0f;
        proof[3] = 0xafb35ccfcadbf2156d58ae963db52d7da26e5be560c0f08e3cefba3aa93ce6f6;
        
        address hackerAddress = 0x8C45d5DFA32B48806902cb0608Fc85C63E02F9b2;
        vm.prank(hackerAddress);
        web3atl.hackerMint(proof);

        vm.expectRevert();
        web3atl.safeTransferFrom(hackerAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID, data);
    }
}
