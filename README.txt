# DrivingLicense Smart Contract

A Solidity smart contract for managing digital driving licenses on the blockchain. This contract enables the issuance, validation, and renewal of driving licenses with secure record-keeping and event logging.

## Features

- Issue new driving licenses with personal information
- Validate existing licenses and check their status
- Renew licenses within 30 days of expiration
- Automatic age verification (minimum 18 years)
- Event logging for license issuance and renewals
- Two-year validity period for all licenses

## Contract Details

- License: MIT
- Solidity Version: ^0.8.0

## Data Structures

### License Struct

The contract uses a `License` struct to store individual license information:

- `firstName`: First name of the license holder
- `lastName`: Last name of the license holder
- `nationality`: Nationality of the license holder
- `credentialID`: Unique identifier for the license
- `dateOfBirth`: Unix timestamp of the holder's birth date
- `issueDate`: Unix timestamp when the license was issued
- `expiryDate`: Unix timestamp when the license expires

## Main Functions

### issueLicense

```solidity
function issueLicense(
    string memory credentialID,
    string memory firstName,
    string memory lastName,
    string memory nationality,
    uint256 dateOfBirth
) public
```

Issues a new driving license with the following checks:
- Ensures the credential ID is not already in use
- Verifies the date of birth is in the past
- Confirms the applicant is at least 18 years old
- Sets a two-year validity period from the issue date

### validateLicense

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

Validates an existing license and returns:
- All stored license details
- Current validity status based on expiration date

### renewLicense

```solidity
function renewLicense(string memory credentialID) public
```

Renews an existing license with the following conditions:
- License must exist in the system
- Renewal is only possible within 30 days of expiration
- Extends validity for two years from the renewal date

## Events

The contract emits the following events:

### LicenseIssued
Triggered when a new license is issued, including all license details:
- Credential ID
- Personal information
- Issue and expiry dates

### LicenseRenewed
Triggered when a license is renewed, including:
- Credential ID
- New expiry date

## Usage Examples

### Issuing a New License

```solidity
contract.issueLicense(
    "DL123456",
    "John",
    "Doe",
    "US",
    1672531200 // Unix timestamp for date of birth
);
```

### Validating a License

```solidity
(
    string memory firstName,
    string memory lastName,
    string memory nationality,
    string memory id,
    uint256 dateOfBirth,
    uint256 issueDate,
    uint256 expiryDate,
    bool isValid
) = contract.validateLicense("DL123456");
```

### Renewing a License

```solidity
contract.renewLicense("DL123456");
```

## Security Considerations

1. The contract uses internal storage for the licenses mapping, which means derived contracts can access the data
2. All dates are handled using Unix timestamps to ensure consistency
3. Age verification is built into the license issuance process
4. License existence is verified before any operations
5. Renewal window is restricted to prevent early renewals
