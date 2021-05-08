(async () => {
try {

const contractAddress = '0x95361cCfCD754BB6e9B088a28c796353D54f4699';
const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'browser/contracts/artifacts/Assets.json'));

let contract = new web3.eth.Contract(metadata.abi,contractAddress);

 contract.methods.showMessage().call().then(console.log);
console.log("merge?");



} catch (e) {
console.log(e.message);
}

 })()