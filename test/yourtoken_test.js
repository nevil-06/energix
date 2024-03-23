const YourToken = artifacts.require("./YourToken.sol");

contract('YourToken', (accounts) => {
    let tokenInstance;

    it('initializes the contract with the correct values', async () => {
        tokenInstance = await YourToken.deployed();
        const name = await tokenInstance.name();
        assert.equal(name, 'YourTokenName', 'has the correct name');

        const symbol = await tokenInstance.symbol();
        assert.equal(symbol, 'YTN', 'has the correct symbol');

        const standard = await tokenInstance.standard();
        assert.equal(standard, 'YourToken v1.0', 'has the correct standard');
    });

    it('allocates the initial supply upon deployment', async () => {
        tokenInstance = await YourToken.deployed();
        const totalSupply = await tokenInstance.totalSupply();
        assert.equal(totalSupply.toNumber(), 1000000, 'sets the total supply to 1,000,000');

        const adminBalance = await tokenInstance.balanceOf(accounts[0]);
        assert.equal(adminBalance.toNumber(), 1000000, 'it allocates the initial supply to the admin account');
    });

    it('transfers token ownership', async () => {
        tokenInstance = await YourToken.deployed();
        // Test `require` statement first by transferring something larger than the sender's balance
        try {
            await tokenInstance.transfer.call(accounts[1], 99999999999999999999);
        } catch (error) {
            assert(error.message.indexOf('revert') >= 0, 'error message must contain revert');
        }

        // Test the return value of the transfer function
        const success = await tokenInstance.transfer.call(accounts[1], 250000, { from: accounts[0] });
        assert.equal(success, true, 'it returns true');

        const receipt = await tokenInstance.transfer(accounts[1], 250000, { from: accounts[0] });
        assert.equal(receipt.logs.length, 1, 'triggers one event');
        assert.equal(receipt.logs[0].event, 'Transfer', 'should be the "Transfer" event');
        assert.equal(receipt.logs[0].args._from, accounts[0], 'logs the account the tokens are transferred from');
        assert.equal(receipt.logs[0].args._to, accounts[1], 'logs the account the tokens are transferred to');
        assert.equal(receipt.logs[0].args._value.toNumber(), 250000, 'logs the transfer amount');

        const balanceAfterTransfer = await tokenInstance.balanceOf(accounts[1]);
        assert.equal(balanceAfterTransfer.toNumber(), 250000, 'adds the amount to the receiving account');

        const balanceAfterTransferSender = await tokenInstance.balanceOf(accounts[0]);
        assert.equal(balanceAfterTransferSender.toNumber(), 750000, 'deducts the amount from the sending account');
    });

    // Add more tests as needed for your token's functionality
});
