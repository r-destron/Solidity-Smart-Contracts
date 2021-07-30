pragma solidity ^0.5.3;

contract Voting{
    
    adress public contractOwner; //the owner who deployed the contractOwner
    adress[] public candidatesList; //a dynamic array of all candidates who will get votes
    
    mapping (adress => uint8) public votesReceived; 
    
    address public winner;
    uint public winnerVotes;
    
    enum votingStatus {NotStarted, Running, Completed}
    votingStatus public status;
    
    constructor() public{
        contractOwner = msg.sender;
    }
    
    modifier onlyOwner{
        if(msg.sender == contractOwner){
            _;
        }
    }
    
    function setStatus() onlyOwner public{
        if(status != votingStatus.Completed){
            status = votingStatus.Running;
        }
        else{
            status = votingStatus.Completed;
        }
    }
    
    function registerCandidate(address _candidate) onlyOwner public{
        candidatesList.push(_candidate);
    }
    
    function validateCandidate(address _candidate) view public returns(bool){
        for(uint i=0;i<candidatesList.length;i++){
            if(candidatesList[i]==_candidate)
                return true;
        }
        return false;
    }
    
    function vote(address _candidate) public{
        require(validateCandidate(__candidate),"Not a valid candidate");
        votesReceived[_candidate] += 1;
    }
    
    function votesCount (address _candidate) public view return(uint){
        require(validateCandidate(__candidate),"Not a valid candidate");
        return votesReceived[_candidate];
    }
    
    function result() public{
        require(status==votingStatus.Completed, "Votng is not Completed, result can't be declared.");
        for(uint i=0;i<candidatesList.length;i++){
            if(votesReceived[candidatesList[i]] > winnerVotes){
                winnerVotes = votesReceived[candidatesList[i]];
                winner = candidatesList[i];
            }
        }
    }
}
