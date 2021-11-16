pragma solidity ^0.8.0;

contract campaignFactory {
    Campaign[] public deployedCampaigns;
    
    function createCampaign(uint minimium) public {
        Campaign newCampaign = new Campaign(minimium);
        deployedCampaigns.push(newCampaign);
    }
}

contract Campaign {
    
    address public manager;
    uint public minimiumContribuition;
    uint public approvalCount;
    uint public approversCount;
    uint public  numRequests;
    
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvalss;
    
    }
    
    constructor(uint _minimiumContribuition) {
        minimiumContribuition = _minimiumContribuition;
        manager = msg.sender;
    }
    
    modifier onlyManager() {
        require(manager == msg.sender, "signer must be the manager");
        _;
    }
    
    mapping(uint => Request)public approvals;
    mapping(address =>bool) approveRequest;
    
    function contribute() public payable {
        require(msg.value >= minimiumContribuition, "ether amount not enough motherfoca");
        approveRequest[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest( string memory _obj, uint _value, address payable _recipient) public onlyManager {
      Request storage r = approvals[numRequests++];
            r.description =  _obj;
            r.value = _value;
            r.recipient = _recipient;
            r.complete = false;
            r.approvalCount = 0;
    }
    function approveReq(uint index) public onlyManager {
        require(approveRequest[msg.sender]);
        require(!approvals[index].approvalss[msg.sender]);
        approvals[index].approvalss[msg.sender];
        approvals[index].approvalCount++;
    }
    function finalizeRequest(uint index) public onlyManager {
         require(!approvals[index].complete);
         require(approvals[index].approvalCount > (approversCount/2));
         approvals[index].recipient.transfer(address(this).balance);
         approvals[index].complete;
    }
}