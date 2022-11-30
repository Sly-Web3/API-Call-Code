import './App.css';
import Button from 'react-bootstrap/Button';
import 'bootstrap/dist/css/bootstrap.min.css';
import Web3 from 'web3';
import axios from 'axios'; //Install with npm i axios
import React, { Component } from 'react'; //we need component to process the class we configured


const ADDRESS = "0x0aA3dB8776B75e16628ec5Ac4330FA65b5376FF2"; //address of the contract
const apikey = "DT8UXSTKEW62WFSXDMI8II9IWJRNXKMYPY"; //API key from etherscan 
const endpoint = "https://api-goerli.etherscan.io/api" //etherscan endpoint URL (simply search Etherscan endpoint URL's) (we add api to the end)

async function connectwallet() { 
      if (window.ethereum) { 
      var web3 = new Web3(window.ethereum); 
      await window.ethereum.send('eth_requestAccounts'); 
      var accounts = await web3.eth.getAccounts(); 
      account = accounts[0]; 
      document.getElementById('wallet-address').textContent = account; 
      contract = new web3.eth.Contract(ABI, ADDRESS);
      }
}
async function mint() {
      if (window.ethereum) { 
        var _mintAmount = Number(document.querySelector("[name=amount]").value); 
        var mintRate = Number(await contract.methods.cost().call()); 
        var totalAmount = mintRate * _mintAmount; 
      contract.methods.mint(account, _mintAmount).send({ from: account, value: String(totalAmount) }); 
      }
    } 

class App extends Component { //we make a class out of App.
	constructor() { 
		super();
		this.state = { 
			balance: [], //in this code we are calling the balance 
		};
	}

	async componentDidMount() {
		const etherscan = await axios.get(endpoint + `?module=stats&action=tokensupply&contractaddress=${ADDRESS}&apikey=${apikey}`); //this is the line where we actually make the API call. the ?module=stats... is the second part of the URL when you click test 2 
//endpoint will be the endpoint URL we put above. tokensupply is speicifc to this API call as this is what we are looking for. Everything can be found in the API call documentation.
//we make this information equal to the constant etherscan.
		let { result } = etherscan.data; //
		this.setState({
		 balance: result,
		});
  }
  render() {
	const {balance} = this.state;

  return (
    <div className="App">
 <div className='container'>
<div className='row'>
  <form class="gradient col-lg-5 mt-5" style={{borderRadius:"25px",boxShadow:"1px 1px 15px #000000"}}>
    <h4 style={{color:"#FFFFFF"}}>Mint Portal</h4>
    <h5 style={{color:"#FFFFFF"}}>Please connect your wallet</h5>
    <Button onClick={connectwallet} style={{marginBottom:"5px",color:"#FFFFFF"}}>Connect Wallet</Button>
    <div class="card" id='wallet-address' style={{marginTop:"3px",boxShadow:"1px 1px 4px #000000"}}>
      <label for="floatingInput">Wallet Address</label>
      </div>
      <div class="card" style={{marginTop:"3px",boxShadow:"1px 1px 4px #000000"}}>
      <input type="number" name="amount" defaultValue="1" min="1" max="5"/>
      <label >Please select the amount of NFTs to mint.</label>
      <Button onClick={mint}>Buy/Mint!</Button>
      </div>
    <label style={{color:"#FFFFFF"}}>Price 0.05 ETH each mint.</label>
	<h2> Tokens Minted so far= {balance}/1000</h2> //this is putting the balance as text on our website
  </form>
	</div>
 	</div>
    </div>
  			);
	};
}

export default App;


