// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Condominium {
    address public manager; //Ownable
    mapping(uint16 => bool) public residences; //unidade => true
    mapping(address => uint16) public residents; //wallet => unidade (1101) (2505)
    mapping(address => bool) public counselors; //conselheiro => true

    constructor() {
        manager = msg.sender;

        for (uint8 i = 1; i <= 2; i++) {
            //os blocos
            for (uint8 j = 1; j <= 5; j++) {
                //os andares
                for (uint8 k = 1; k <= 5; k++) {
                    unchecked {
                        //as unidades
                        residences[(i * 1000) + (j + 100) + k] = true;
                    }
                }
            }
        }
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can do this");
        _;
    }

    modifier onlyCouncil() {
        require(msg.sender == manager || counselors[msg.sender], "Only manager or council can do this");
        _;
    }

    modifier onlyResidents() {
        require(msg.sender == manager || isResident(msg.sender), "Only manager or resident can do this");
        _;
    }

    function residenceExists(uint16 residenceId) public view returns (bool) {
        return residences[residenceId];
    }

    function isResident(address resident) public view returns (bool) {
        return residents[resident] > 0;
    }

    function addResident(address resident, uint16 residenceId) external onlyCouncil {
        require(residenceExists(residenceId), "Residence does not exist");
        residents[resident] = residenceId;
    }

    function removeResident(address resident) external onlyManager {
        require(!counselors[resident], "A counselor cannot be removed");
        delete residents[resident];
    }
}
