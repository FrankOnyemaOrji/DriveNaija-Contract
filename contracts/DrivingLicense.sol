// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrivingLicense {
    // Struct to store license details
    struct License {
        string firstName;
        string lastName;
        string nationality;
        string credentialID; // Unique identifier for the license
        uint256 dateOfBirth; // Stored as a Unix timestamp
        uint256 issueDate;
        uint256 expiryDate;
    }

    // Mapping of Credential ID to License details
    // mapping(string => License) private licenses;
    mapping(string => License) internal  licenses;

    // Event to log license issuance
    event LicenseIssued(
        string credentialID,
        string firstName,
        string lastName,
        string nationality,
        uint256 dateOfBirth,
        uint256 issueDate,
        uint256 expiryDate
    );

    // Event to log license renewal
    event LicenseRenewed(string credentialID, uint256 newExpiryDate);

    // Issue a new driver's license
    function issueLicense(
        string memory credentialID,
        string memory firstName,
        string memory lastName,
        string memory nationality,
        uint256 dateOfBirth // Ensure this is a valid Unix timestamp
    ) public {
        require(
            licenses[credentialID].issueDate == 0,
            "License already exists for this Credential ID"
        );

        // Ensure the dateOfBirth is in the past
        require(
            dateOfBirth < block.timestamp,
            "Date of birth cannot be in the future"
        );

        // Ensure the applicant is at least 18 years old
        uint256 ageInSeconds = block.timestamp - dateOfBirth;
        require(
            ageInSeconds >= 18 * 365 days,
            "Applicant must be at least 18 years old"
        );

        uint256 issueDate = block.timestamp; // Current timestamp
        uint256 expiryDate = issueDate + 730 days; // 2 years in seconds

        licenses[credentialID] = License({
            firstName: firstName,
            lastName: lastName,
            nationality: nationality,
            dateOfBirth: dateOfBirth,
            credentialID: credentialID,
            issueDate: issueDate,
            expiryDate: expiryDate
        });

        emit LicenseIssued(
            credentialID,
            firstName,
            lastName,
            nationality,
            dateOfBirth,
            issueDate,
            expiryDate
        );
    }

    // Validate a driver's license
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
    {
        License memory license = licenses[credentialID];
        require(license.issueDate != 0, "License not found");

        bool valid = (block.timestamp <= license.expiryDate);

        return (
            license.firstName,
            license.lastName,
            license.nationality,
            license.credentialID,
            license.dateOfBirth,
            license.issueDate,
            license.expiryDate,
            valid
        );
    }

    // Renew a driver's license
    function renewLicense(string memory credentialID) public {
        License storage license = licenses[credentialID];
        require(license.issueDate != 0, "License not found");
        require(
            block.timestamp > license.expiryDate - 30 days,
            "License renewal not yet allowed"
        ); // Renew only within 30 days of expiry

        uint256 newExpiryDate = block.timestamp + 730 days; // Add 2 years
        license.expiryDate = newExpiryDate;

        emit LicenseRenewed(credentialID, newExpiryDate);
    }
}
