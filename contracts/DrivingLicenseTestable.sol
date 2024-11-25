// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DrivingLicense.sol";

contract DrivingLicenseTestable is DrivingLicense {
    // Mock function to issue a license with custom dates
    function issueLicenseWithCustomDates(
        string memory credentialID,
        string memory firstName,
        string memory lastName,
        string memory nationality,
        uint256 dateOfBirth,
        uint256 customIssueDate,
        uint256 customExpiryDate
    ) public {
        require(
            licenses[credentialID].issueDate == 0,
            "License already exists for this Credential ID"
        );

        licenses[credentialID] = License({
            firstName: firstName,
            lastName: lastName,
            nationality: nationality,
            dateOfBirth: dateOfBirth,
            credentialID: credentialID,
            issueDate: customIssueDate,
            expiryDate: customExpiryDate
        });

        emit LicenseIssued(
            credentialID,
            firstName,
            lastName,
            nationality,
            dateOfBirth,
            customIssueDate,
            customExpiryDate
        );
    }
}
