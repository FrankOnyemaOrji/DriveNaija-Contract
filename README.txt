# DrivingLicense Smart Contract 🚗

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.0-lightgrey)](https://soliditylang.org/)

A Solidity smart contract for managing digital driving licenses on the blockchain. This contract enables the issuance, validation, and renewal of driving licenses with secure record-keeping and event logging.

## Table of Contents

- [Features](#features)
- [Contract Details](#contract-details)
- [Data Structures](#data-structures)
- [Main Functions](#main-functions)
- [Events](#events)
- [Usage Examples](#usage-examples)
- [Security Considerations](#security-considerations)
- [License](#license)

## Features

✨ Here's what you can do with this contract:

- Issue new driving licenses with personal information
- Validate existing licenses and check their status
- Renew licenses within 30 days of expiration
- Automatic age verification (minimum 18 years)
- Event logging for license issuance and renewals
- Two-year validity period for all licenses

## Contract Details

- **License**: MIT
- **Solidity Version**: ^0.8.0

## Data Structures

### License Struct

The contract uses a `License` struct to store individual license information:

| Field | Type | Description |
|-------|------|-------------|
| `firstName` | `string` | First name of the license holder |
| `lastName` | `string` | Last name of the license holder |
| `nationality` | `string` | Nationality of the license holder |
| `credentialID` | `string` | Unique identifier for the license |
| `dateOfBirth` | `uint256` | Unix timestamp of the holder's birth date |
| `issueDate` | `uint256` | Unix timestamp when the license was issued |
| `expiryDate` | `uint256` | Unix timestamp when the license expires |

## Main Functions

### issueLicense

Issues a new driving license.

```solidity
function issueLicense(
    string memory credentialID,
    string memory firstName,
    string memory lastName,
    string memory nationality,
    uint256 dateOfBirth
) public
```

**Checks performed:**
- Ensures the credential ID is not already in use
- Verifies the date of birth is in the past
- Confirms the applicant is at least 18 years old
- Sets a two-year validity period from the issue date

### validateLicense

Validates an existing license.

```solidity
function validateLicense(string memory credentialID)
    public
    view
    returns (
        string memory firstName,
        string memory lastName,
        string memory nationality,
        string memory id,
        uint256 dateOfBirth,
        uint256 issueDate,
        uint256 expiryDate,
        bool isValid
    )
```

**Returns:**
- All stored license details
- Current validity status based on expiration date

### renewLicense

Renews an existing license.

```solidity
function renewLicense(string memory credentialID) public
```

**Conditions:**
- License must exist in the system
- Renewal is only possible within 30 days of expiration
- Extends validity for two years from the renewal date

## Events

### LicenseIssued

Triggered when a new license is issued:

```solidity
event LicenseIssued(
    string credentialID,
    string firstName,
    string lastName,
    string nationality,
    uint256 dateOfBirth,
    uint256 issueDate,
    uint256 expiryDate
);
```

### LicenseRenewed

Triggered when a license is renewed:

```solidity
event LicenseRenewed(
    string credentialID, 
    uint256 newExpiryDate
);
```

## Usage Examples

### Issuing a New License

```javascript
// Using web3.js or ethers.js
const tx = await contract.issueLicense(
    "DL123456",
    "John",
    "Doe",
    "US",
    1672531200 // Unix timestamp for date of birth
);
await tx.wait();
```

### Validating a License

```javascript
const licenseDetails = await contract.validateLicense("DL123456");
const {
    firstName,
    lastName,
    nationality,
    id,
    dateOfBirth,
    issueDate,
    expiryDate,
    isValid
} = licenseDetails;
```

### Renewing a License

```javascript
const tx = await contract.renewLicense("DL123456");
await tx.wait();
```

## Security Considerations

1. **Storage Access**: The contract uses internal storage for the licenses mapping, which means derived contracts can access the data
2. **Date Handling**: All dates are handled using Unix timestamps to ensure consistency
3. **Age Verification**: Built into the license issuance process
4. **Existence Checks**: License existence is verified before any operations
5. **Renewal Restrictions**: Renewal window is restricted to prevent early renewals

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ for the blockchain community.
