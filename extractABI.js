const fs = require('fs');
const contractJSON = require('./build/contracts/Token.json'); // Update the path to where the JSON file is located

const abi = JSON.stringify(contractJSON.abi);

fs.writeFileSync('YourContractABI.json', abi); // Writes the ABI to a new file
console.log('ABI extracted:', abi);
