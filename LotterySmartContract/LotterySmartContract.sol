pragma solidity ^0.5.3;

contract Lottery{
    
    address public organizerAddress;            //the address of the organizer
    address payable [] public candidates;       //the list of players who are taking part in lottery
    
    constructor() public{
        organizerAddress = msg.sender;          //assign adrees with which contract is deployed to organizerAddress
    }
    
    modifier OrganizerOnly{
        if(msg.sender == organizerAddress){     //only organizer is allowed to pick winner and reset the list of candidates
            _;
        }
    }
    
    function deposit() public payable{
        require(msg.value >= 1 ether);          //the value must be greater than or equal to 1 ether in order to take part in lottery
        candidates.push(msg.sender);            //if eligible then add to candidates' list
    }
    
    function GenerateRandomNumber() private view returns(uint) {                            
        return uint(keccak256(abi.encodePacked(now,block.difficulty,candidates.length)));   //generate a random hash value and convert it into integer
    }
    
    function pickWinner() OrganizerOnly public{
        uint randomNumber = GenerateRandomNumber();
        uint index = randomNumber % candidates.length;
        
        address payable winner;
        winner = candidates[index];     //the winner's address is picked
        
        winner.transfer(address(this).balance);     //the ethers are transferred to the winner's account
        
        //reset the candidates array after the winner is chosen and ether is transferred
        candidates = new address payable [](0); 
    }
    
}