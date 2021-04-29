(async () => {
try {

const contractAddress = '0xb7E5E1e8A72E94038fB16A710B960BFD58d8bb37';
const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'browser/contracts/artifacts/Assets.json'));

let contract = new web3.eth.Contract(metadata.abi,contractAddress);

 contract.methods.showMessage().call().then(console.log);
console.log("merge?");



} catch (e) {
console.log(e.message);
}

 })()