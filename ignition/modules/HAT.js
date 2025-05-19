const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("HealthAccessTokenModule", (m) => {
  const recipient = m.getParameter("recipient");
  const defaultAdmin = m.getParameter("defaultAdmin");

  const healthAccessToken = m.contract("HealthAccessToken", [], {
  });

  m.call(healthAccessToken, "initialize", [recipient, defaultAdmin]);

  return { healthAccessToken };
});
