// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Sensors {
    mapping(address => bool) public canVote;

    struct Vote {
        uint256 totalVotes;
        uint256 AcceptTotal;
        address[] addressArray;
        mapping(address => bool) votes;
    }

    mapping(address => Vote) public openVotes;

    struct Sensor {
        bool initialized;
        bool state;
    }

    mapping(address => Sensor) public sensors;
    
    uint256 public voters;
    address public owner;
    uint256 public createdAt;

    constructor() {
        owner = msg.sender;
        createdAt = block.timestamp;
    }

    function registerSensor(address _sensorAddress) public onlyOwner {
        require(sensors[_sensorAddress].initialized == false, "Already initialized");
        
        Sensor memory newSensor = Sensor({
            initialized: true,
            state:false
        });
        sensors[_sensorAddress] = newSensor;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addVoter(address _voter) public onlyOwner {
        require(canVote[_voter] == false, "Already registered");
        canVote[_voter] = true;
        voters++;
    }
    
    function openVote(address _sensor) public {
        require(openVotes[_sensor].totalVotes == 0, "Already open voting");
        require(openVotes[_sensor].votes[msg.sender] == false, "Already said yes");
        openVotes[_sensor].totalVotes = voters;
    }

    function changeSensorState(address _sensor) private  {
        // change the sensor status
        sensors[_sensor].state = !sensors[_sensor].state;

        //clear the vote
        openVotes[_sensor].totalVotes = 0;
        openVotes[_sensor].AcceptTotal = 0;
        for (uint256 i = 0; i < openVotes[_sensor].addressArray.length; i++) {
            openVotes[_sensor].votes[openVotes[_sensor].addressArray[i]] = false;
        }
        delete openVotes[_sensor].addressArray;
    }

    function vote(address _sensor) public{
        
        require(openVotes[_sensor].totalVotes > 0, "Opened voting");
        require(openVotes[_sensor].votes[msg.sender] == false, "Already voted");
        openVotes[_sensor].votes[msg.sender] = true;
        openVotes[_sensor].addressArray.push(msg.sender);
        openVotes[_sensor].AcceptTotal++;

        if (openVotes[_sensor].AcceptTotal > (openVotes[_sensor].totalVotes / 2)) {
            changeSensorState(_sensor);
        }
    }
}