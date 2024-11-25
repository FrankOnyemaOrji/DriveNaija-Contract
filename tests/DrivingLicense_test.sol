// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

// Import Remix testing utilities
import "remix_tests.sol";
import "../contracts/DrivingLicenseTestable.sol"; // Import the DrivingLicense contract

contract DrivingLicenseTest {
    DrivingLicense private drivingLicense;

    /// #sender: account-0
    function beforeAll() public {
        // Deploy a fresh instance of the DrivingLicense contract before all tests
        drivingLicense = new DrivingLicense();
    }

    /// Test issuing a new driver's license
    function testIssueLicense() public {
        string memory credentialID = "DL12345";
        string memory firstName = "John";
        string memory lastName = "Doe";
        string memory nationality = "Nigerian";
        uint256 dateOfBirth = 946684800; // Unix timestamp for 1990-01-01

        // Call issueLicense function
        drivingLicense.issueLicense(
            credentialID,
            firstName,
            lastName,
            nationality,
            dateOfBirth
        );

        // Validate the issued license
        (
            string memory fetchedFirstName,
            string memory fetchedLastName,
            string memory fetchedNationality,
            string memory fetchedCredentialID,
            uint256 fetchedDateOfBirth,
            uint256 issueDate,
            uint256 expiryDate,
            bool isValid
        ) = drivingLicense.validateLicense(credentialID);

        // Assertions
        Assert.equal(fetchedFirstName, firstName, "First name does not match");
        Assert.equal(fetchedLastName, lastName, "Last name does not match");
        Assert.equal(
            fetchedNationality,
            nationality,
            "Nationality does not match"
        );
        Assert.equal(
            fetchedCredentialID,
            credentialID,
            "Credential ID does not match"
        );
        Assert.equal(
            fetchedDateOfBirth,
            dateOfBirth,
            "Date of birth does not match"
        );
        Assert.equal(isValid, true, "License should be valid");
    }

    /// Test validating an existing license
    function testValidateLicense() public {
        string memory credentialID = "DL12345";

        (
            string memory fetchedFirstName,
            string memory fetchedLastName,
            string memory fetchedNationality,
            string memory fetchedCredentialID,
            uint256 fetchedDateOfBirth,
            uint256 issueDate,
            uint256 expiryDate,
            bool isValid
        ) = drivingLicense.validateLicense(credentialID);

        Assert.equal(
            fetchedCredentialID,
            credentialID,
            "Credential ID does not match"
        );
        Assert.ok(isValid, "License should be valid");
    }

    /// Test license renewal
    function testRenewLicense() public {
        DrivingLicenseTestable testable = new DrivingLicenseTestable();

        string memory credentialID = "DL12345";
        string memory firstName = "John";
        string memory lastName = "Doe";
        string memory nationality = "Nigerian";
        uint256 dateOfBirth = 946684800; // Unix timestamp for 1990-01-01

        // Set custom issue and expiry dates
        uint256 customIssueDate = block.timestamp - (730 days - 29 days); // Issued 729 days ago
        uint256 customExpiryDate = customIssueDate + 730 days; // Expires in 1 day

        // Issue license with custom dates
        testable.issueLicenseWithCustomDates(
            credentialID,
            firstName,
            lastName,
            nationality,
            dateOfBirth,
            customIssueDate,
            customExpiryDate
        );

        // Attempt renewal
        try testable.renewLicense(credentialID) {
            Assert.ok(true, "License renewed successfully");
        } catch Error(string memory reason) {
            Assert.ok(false, reason); // Simulates test failure
        }

        // Validate the renewed license
        (, , , , , , uint256 newExpiryDate, ) = testable.validateLicense(
            credentialID
        );
        Assert.ok(
            newExpiryDate > customExpiryDate,
            "License expiry date should be extended"
        );
    }

    /// Test duplicate license issuance
    function testDuplicateLicense() public {
        string memory credentialID = "DL12345";
        string memory firstName = "Jane";
        string memory lastName = "Smith";
        string memory nationality = "Ghanaian";
        uint256 dateOfBirth = 704217600; // Unix timestamp for 1992-05-12

        // Attempt to issue a license with the same credential ID
        try
            drivingLicense.issueLicense(
                credentialID,
                firstName,
                lastName,
                nationality,
                dateOfBirth
            )
        {
            Assert.ok(false, "Duplicate license issuance should fail");
        } catch Error(string memory reason) {
            Assert.equal(
                reason,
                "License already exists for this Credential ID",
                "Unexpected error message"
            );
        }
    }
}
