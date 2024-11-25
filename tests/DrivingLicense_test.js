const { expect } = require("chai");

describe("DrivingLicense Smart Contract Tests", function () {
  let DrivingLicense;
  let drivingLicense;

  before(async function () {
    // Get the contract factory and deploy the contract
    DrivingLicense = await ethers.getContractFactory("DrivingLicense");
    drivingLicense = await DrivingLicense.deploy();
    await drivingLicense.deployed();
  });

  it("Should issue a new driver's license", async function () {
    const credentialID = "DL12345";
    const firstName = "John";
    const lastName = "Doe";
    const nationality = "Nigerian";
    const dateOfBirth = "1990-01-01";

    // Call issueLicense
    const tx = await drivingLicense.issueLicense(
      credentialID,
      firstName,
      lastName,
      nationality,
      dateOfBirth
    );
    await tx.wait();

    // Validate the license was issued correctly
    const license = await drivingLicense.validateLicense(credentialID);
    expect(license.firstName).to.equal(firstName);
    expect(license.lastName).to.equal(lastName);
    expect(license.nationality).to.equal(nationality);
    expect(license.dateOfBirth).to.equal(dateOfBirth);
  });

  it("Should validate an existing driver's license", async function () {
    const credentialID = "DL12345";

    const license = await drivingLicense.validateLicense(credentialID);
    expect(license.isValid).to.equal(true);
  });

  it("Should renew a driver's license", async function () {
    const credentialID = "DL12345";

    // Renew the license
    const tx = await drivingLicense.renewLicense(credentialID);
    await tx.wait();

    // Validate new expiry date
    const license = await drivingLicense.validateLicense(credentialID);
    const currentTimestamp = Math.floor(Date.now() / 1000); // Current time in seconds
    const expectedExpiryDate = currentTimestamp + 730 * 24 * 60 * 60; // 2 years
    expect(license.expiryDate).to.be.greaterThan(currentTimestamp);
    expect(license.expiryDate).to.be.closeTo(expectedExpiryDate, 100); // Allow 100 seconds buffer
  });

  it("Should prevent issuing a duplicate license", async function () {
    const credentialID = "DL12345";

    // Attempt to issue the same credential ID
    await expect(
      drivingLicense.issueLicense(
        credentialID,
        "Jane",
        "Smith",
        "Ghanaian",
        "1992-05-12"
      )
    ).to.be.revertedWith("License already exists for this Credential ID");
  });
});
