// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Web3Atl.sol";
import "solmate/utils/MerkleProofLib.sol";


contract Web3AtlTest is Test {
    Web3Atl public web3atl;
    string public baseURI = "http://www.google.com";
    
    address someAddress = 0x0e77381EAeCd47696438EABaB9aF8859261837F3;
    
    bytes32 merkleRootHacker = 0xe209c98de34f562fcf6a03ad0eb3f404b05809e14cb40261e346b6a07c4fb58c;
    bytes32 merkleRootGeneral = 0x4c9934a0450e77aecb9246dbaad7703bfd8ab5f79715f88f71a7c144493da07b;
    bytes32 merkleRootTeam = 0x9d729cb5a147ad988999e56cdcf4c12130cb46a0f9fb243bfe274361ea78a365;
    bytes32 merkleRootSpeaker = 0x5ba534e523999b0c7db02b8196c7c03629d9e09a711b150dd8465c8d473eec45;

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

    // function testSetBaseURINotOwner(address addr, string memory newBaseURI) public {
    //     vm.prank(addr);
    //     vm.expectRevert();
    //     web3atl.setBaseURI(newBaseURI);
    // }

    function testHackerMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;


        string memory hackerEmail = "pruitt.martin@gmail.com";
        bytes32 leaf = keccak256(abi.encodePacked(hackerEmail));
        assert(leaf == 0xb4e264b10f980d54c79001657cd61f1e7744801313470b14c12d68a93b0a740b);
    

        vm.prank(someAddress);
        console.logBytes32(web3atl.hackerMerkleRoot());
        web3atl.hackerMint(proof, hackerEmail);
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.HACKER);
        assert(web3atl.hackerClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testHackerCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;
        
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.hackerMint(proof, hackerEmail);
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.hackerMint(proof, hackerEmail);
    }

    function testHackerMintInvalidAddressAndProof(bytes32[] memory proof) public {
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);        
        vm.expectRevert();
        web3atl.hackerMint(proof, hackerEmail);
    }

    function testGeneralMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](8);
        proof[0] = 0xec647c6f58891e15912d549678bd5e3578652f7f28b9ca0fd4804ea811ed65c3;
        proof[1] = 0xe080df37675267b4cf18786aa81d276d79f48fbd27f7de60930fd5c4de131b14;
        proof[2] = 0x0db3cfa0a39ede66a98d6e98bd7d6229383e3b2e7d0df56fe8b0c35605c1e679;
        proof[3] = 0x55135d1b80d3ea504dfbb70ca163de7e24a15c7cf6955a67c6ddfe238036d960;
        proof[4] = 0xd75b7739b503840872fb1a8f61b54d0acf776fd7488306faadad3423c1a55bae;
        proof[5] = 0x83532ef296538b0d2af36fc328f3321cd83a1a25327ee7fa272388c218182a12;
        proof[6] = 0x0e4cc3d1ac5877f547959733b4ffb33bfaaf31708a29f566c18b5bf5ad73e30f;
        proof[7] = 0x4ce7d45d3e8ac381a6bac7fb9acd0c61b5aba0f7addaa8ea8fc74cb4ad2bfed1;
        
        string memory generalEmail = "jasmine.guerra@ubs.com";
        vm.prank(someAddress);
        web3atl.generalMint(proof, generalEmail);
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.GENERAL);
        assert(web3atl.generalClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testGeneralCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](8);
        proof[0] = 0xec647c6f58891e15912d549678bd5e3578652f7f28b9ca0fd4804ea811ed65c3;
        proof[1] = 0xe080df37675267b4cf18786aa81d276d79f48fbd27f7de60930fd5c4de131b14;
        proof[2] = 0x0db3cfa0a39ede66a98d6e98bd7d6229383e3b2e7d0df56fe8b0c35605c1e679;
        proof[3] = 0x55135d1b80d3ea504dfbb70ca163de7e24a15c7cf6955a67c6ddfe238036d960;
        proof[4] = 0xd75b7739b503840872fb1a8f61b54d0acf776fd7488306faadad3423c1a55bae;
        proof[5] = 0x83532ef296538b0d2af36fc328f3321cd83a1a25327ee7fa272388c218182a12;
        proof[6] = 0x0e4cc3d1ac5877f547959733b4ffb33bfaaf31708a29f566c18b5bf5ad73e30f;
        proof[7] = 0x4ce7d45d3e8ac381a6bac7fb9acd0c61b5aba0f7addaa8ea8fc74cb4ad2bfed1;
        
        string memory generalEmail = "jasmine.guerra@ubs.com";
        vm.prank(someAddress);
        web3atl.generalMint(proof, generalEmail);
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.generalMint(proof, generalEmail);
    }

    function testGeneralMintInvalidAddressAndProof(bytes32[] memory proof) public {
        string memory generalEmail = "jasmine.guerra@ubs.com";
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.generalMint(proof, generalEmail);
    }
    
    function testTeamMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](3);
        proof[0] = 0x5aabd4a8d08d4325db0087c090bb6a9e235f32bf6f3d725e3008c0a4639f1dda;
        proof[1] = 0x3db4422081cf99995f0bac04e406f29e08345654baa19135edda091795452730;
        proof[2] = 0x6c9ebcfed10b1d113b5a2e40790d353761a69df06a3abcb7dcd3afb609f841ff;
        
        string memory teamEmail = "rschleusner@gatech.edu";
        vm.prank(someAddress);
        web3atl.teamMint(proof, teamEmail);
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.TEAM);
        assert(web3atl.teamClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testTeamCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](3);
        proof[0] = 0x7edf1ec327977661b7c80286118e1333269b1b1e554167c3e804bdcb271f399b;
        proof[1] = 0xa5a89c345e719f1ac6d052e9413caed0d43994fd902943cddadfa53e7125c0d8;
        proof[2] = 0xd462a467848c4c38e78b641ca7ce46badb7534a3d592371ae4c406decd197b49;
        
        string memory teamEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.teamMint(proof, teamEmail);
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.teamMint(proof, teamEmail);
    }

    function testTeamMintInvalidAddressAndProof(bytes32[] memory proof) public {
        string memory teamEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.teamMint(proof, teamEmail);
    }

    function testSpeakerMintValidAddressAndProof() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x6d8095ce3f59631e92f67a00730529fe5a197c39f218cb515b123e79eecd501e;
        proof[1] = 0xbd0396b2641ecc6bca35cde841f72c5a26c5dc54df377363e8fe81e31204ef83;
        proof[2] = 0xb0ebff90280b9b8a8bbfcb465695e56adff6ee89733883d04cbc258cb5e508a1;
        proof[3] = 0xd3e1cf1f3e618fd680b486f8c39a31d1771e4fbce33d8c1843b15bc5b724b37e;
        proof[4] = 0x8af70561a7d6576c294ef70b523547c27256fd62a7863e99fbb9e952f5019e77;
        
        string memory speakerEmail = "avery.bartlett@avalabs.org";
        vm.prank(someAddress);
        web3atl.speakerMint(proof, speakerEmail);
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.SPEAKER);
        assert(web3atl.speakerClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testSpeakerCannotMintTwice() public {
        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x6d8095ce3f59631e92f67a00730529fe5a197c39f218cb515b123e79eecd501e;
        proof[1] = 0xbd0396b2641ecc6bca35cde841f72c5a26c5dc54df377363e8fe81e31204ef83;
        proof[2] = 0xb0ebff90280b9b8a8bbfcb465695e56adff6ee89733883d04cbc258cb5e508a1;
        proof[3] = 0xd3e1cf1f3e618fd680b486f8c39a31d1771e4fbce33d8c1843b15bc5b724b37e;
        proof[4] = 0x8af70561a7d6576c294ef70b523547c27256fd62a7863e99fbb9e952f5019e77;
        
        string memory speakerEmail = "avery.bartlett@avalabs.org";
        vm.prank(someAddress);
        web3atl.speakerMint(proof, speakerEmail);
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.speakerMint(proof, speakerEmail);
    }

    function testSpeakerMintInvalidAddressAndProof(bytes32[] memory proof) public {
        string memory speakerEmail = "avery.bartlett@avalabs.org";
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.speakerMint(proof, speakerEmail);
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

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;
        
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.hackerMint(proof, hackerEmail);
        
        assertEq(web3atl.tokenURI(tokenID), string.concat(
                baseURI,
                "/",
                Strings.toString(uint256(web3atl.tokenType(tokenID))),
                ".json"
            ));
    }

    function testTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;
        
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.hackerMint(proof, hackerEmail);

        vm.expectRevert();
        web3atl.transferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;
        
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.hackerMint(proof, hackerEmail);

        vm.expectRevert();
        web3atl.safeTransferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFromWithCallData(bytes calldata data) public {
        uint256 tokenID = web3atl.tokenID();

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x50369893b33d1ad37b6e4a41be5f647a503359518db68cb8e6deaa02e43f2fe0;
        proof[1] = 0xf30ebc7cb7cdcd4468f114f867f8f0c1c06d7e7dc172e81ce4ae6eec22d63b3a;
        proof[2] = 0xec1f40956f5e1b66547f2464364e01413313e2c8ad828efbca161bf7345155fa;
        proof[3] = 0x3378a238ae1e143c6969099cc332304451a081a15a9cc7c0d9c11e705132e925;
        proof[4] = 0xc0e295859558218b2cc02b52ac49d0c599e689753b0f123bb6355b76095a854f;
        
        string memory hackerEmail = "pruitt.martin@gmail.com";
        vm.prank(someAddress);
        web3atl.hackerMint(proof, hackerEmail);

        vm.expectRevert();
        web3atl.safeTransferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID, data);
    }
}
