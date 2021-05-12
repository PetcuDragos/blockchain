var address = "0xCE1b702bC1238Bb33954638D6C189118E895df95";
var contract = null;
var number_of_assets;


function connect() {
     return new Promise(done=>$.getJSON("abi.json", function (abi) {
        web3 = new Web3(web3.currentProvider);
        contract = new web3.eth.Contract(abi, address);
        console.log(contract.methods);
        contract.methods.getTotalNumberOfAssets().call().then(function (res) {
            //$("#total_number_of_assets").html("There are " + res + " assets registered.");
            //console.log("numer of assets is " + res);
            number_of_assets = res;
            done();
        });
    }));
}


function create_asset(){
    var name = $("#asset_name").val();
    var game = $("#asset_game").val();
    var type = $("#asset_type").val();
    var price = $("#asset_price").val();
    web3.eth.requestAccounts().then(function(acc){
        return contract.methods.createAsset(name, game, type, price).send({from: acc[0], gas: 3000000, value: 1}).then(function(res){console.log(res)}).catch(function(res){console.log(res)});
    })
}

function addAssetForSale(obj){
    console.log("add");
}

function removeAssetFromSale(obj) {
    console.log("remove");
}

function buyAsset(obj){
    var tds = $(obj).parents("tr").children("td");
    var name = tds[0].innerText;
    var game = tds[1].innerText;
    var type = tds[2].innerText;
    var price = tds[3].innerText;
    var id = $(obj).val();
    //contract.methods.getAddFee() I am hardcoding the fee to 1
     web3.eth.requestAccounts().then(function(acc){
         return contract.methods.buyAsset(id).send({from: acc[0], gas: 3000000, value: 1 + price}).then(function(res){console.log(res)}).catch(function(res){console.log(res)});
     })
}
