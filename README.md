# Health Access Token (HAT)

A smart contract built with Solidity & Hardhat, powering tokenized access control for healthcare financing. Designed to support **decentralized access**, **partner integrations**, and **fraud-resistant transactions** using role-based token transfers.

---

## 🚀 Features

- 🔐 **Role-Based Access**  
  Roles like `ADMIN`, `MITRA`, and `USER` define how tokens can move and who can call what.

- 💸 **Controlled Transfers**  
  Only specific role combinations can transfer tokens, preventing misuse.

- 🛠️ **Upgradeable**  
  Built using OpenZeppelin's **UUPS** proxy for future-proof upgradability.

- ⛔ **Pausable**  
  Token transfers can be paused during emergencies.

- 🔥 **Mint & Burn**  
  Admins can create or destroy tokens as needed.

---

## 📦 Stack

- [Solidity ^0.8.27](https://docs.soliditylang.org/)
- [Hardhat](https://hardhat.org/)
- [Hardhat Ignition](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ignition)
- [OpenZeppelin Contracts Upgradeable](https://docs.openzeppelin.com/contracts/5.x/upgradeable)

---
