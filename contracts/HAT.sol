// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";

contract HealthAccessToken is
    Initializable,
    ERC20Upgradeable, 
    ERC20BurnableUpgradeable, 
    ERC20PausableUpgradeable, 
    AccessControlUpgradeable, 
    UUPSUpgradeable
{
    bytes32 public constant ADMIN_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public constant MITRA_ROLE = keccak256("MITRA_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    constructor() {
        _disableInitializers();
    }

    function initialize(address recipient, address defaultAdmin) public initializer {
        __ERC20_init("HealthAccessToken", "HAT");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(ADMIN_ROLE, defaultAdmin);
        _mint(defaultAdmin, 100000 * 10 ** decimals());
        
        _grantRole(USER_ROLE, recipient);
        _mint(recipient, 1 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(ADMIN_ROLE){}

    function pause() public onlyRole(ADMIN_ROLE){
        _pause();
    }
    
    function unpause() public onlyRole(ADMIN_ROLE){
        _unpause();
    }

    function _update(address from, address to, uint256 value) internal override (ERC20Upgradeable, ERC20PausableUpgradeable){
        super._update(from,to,value);
    }

    function mint(address to, uint256 amount) public onlyRole(ADMIN_ROLE) {
        _mint(to, amount);
        emit TokenMinted(to, amount);
    }
    
    function burn(address from, uint256 amount) public onlyRole(ADMIN_ROLE){
        _burn(from, amount);
        emit TokenBurned(from, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        address sender = _msgSender();

        if(hasRole(ADMIN_ROLE, sender) || hasRole(MITRA_ROLE, sender)){
            bool status = super.transfer(to, amount);
            if (status) emit TokenTransferred(sender, to, amount);
            return status; 
        }

        if(hasRole(USER_ROLE, sender) && (hasRole(ADMIN_ROLE, to) || hasRole(MITRA_ROLE, to))){
            bool status = super.transfer(to, amount);
            if (status) emit TokenTransferred(sender, to, amount);
            return status; 
        }

        revert('TRANSFER_NOT_ALLOWED');
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if(hasRole(ADMIN_ROLE, from) || hasRole(MITRA_ROLE, from)){
            bool status = super.transferFrom(from, to, amount);
            if (status) emit TokenTransferred(from, to, amount);
            return status; 
        }

        if(hasRole(ADMIN_ROLE, to) || hasRole(MITRA_ROLE, to)){
            bool status = super.transferFrom(from, to, amount);
            if (status) emit TokenTransferred(from, to, amount);
            return status; 
        }

        revert('TRANSFER_NOT_ALLOWED');
    }

    function hasMitraRole(address account) public view returns (bool) {
        return hasRole(MITRA_ROLE, account);
    }

    function hasUserRole(address account) public view returns (bool) {
        return hasRole(USER_ROLE, account);
    }

    function grantRole(bytes32 role, address account) public override onlyRole(ADMIN_ROLE){
        super.grantRole(role, account);
        emit RoleGranted(role, account, _msgSender());
    }

    function revokeRole(bytes32 role, address account) public override onlyRole(ADMIN_ROLE){
        super.revokeRole(role, account);
        emit RoleRevoked(role, account, _msgSender());
    }

    event TokenMinted(address indexed to, uint256 amount);
    event TokenBurned(address indexed from, uint256 amount);
    event TokenTransferred(address indexed from, address indexed to, uint256 amount);
}