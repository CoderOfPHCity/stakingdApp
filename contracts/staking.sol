// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract stake{

    struct Stake{
        uint stateCounter;
        uint amount;
        uint stakedDuration;
        uint reward;
    } 
    address public owner;

    Stake[] public allstake;

    modifier onlyOwner{
        require(msg.sender == owner, "only owner can call this function");
        _;

    }

    constructor() {
        owner = msg.sender;
    }
  
    mapping (address => Stake) public staker;
     mapping(address => uint256) public balances;

    function calculateReward(uint _amount, uint _stakeTime) private view returns(uint){
         require(block.timestamp > _stakeTime);
         uint totalTime = block.timestamp - _stakeTime;
         uint totalSec = totalTime / (1 days);
         uint rewards = totalSec * RewardAlgo(_amount);
         return rewards;

    } 
    
    function s_stake(uint _amount, uint _duration) public {
        require(balances[msg.sender] > _amount, "insufficient balance");
        staker[msg.sender].amount += _amount;
        staker[msg.sender].stateCounter++;

        uint bonusPercent = _duration / (1 days);
        uint bonusAmount = (bonusPercent * _amount) / (1 days);
        staker[msg.sender].reward += bonusAmount;


        balances[msg.sender] -= _amount;

    }
    function withdraw(address user, uint _amount) public{
        uint amountStaked = balances[user];
        require(amountStaked > 0, "You have no staked amount");

        balances[user] -= _amount;

    }

    function addNewstaker(
        uint stateCounter,
        uint amount,
        uint stakedDuration,
        uint reward
    ) public{
        Stake memory newstake = Stake({
            stateCounter: stateCounter,
            amount: amount,
            stakedDuration: stakedDuration,
            reward: reward
        });

        allstake.push(newstake);

    }


   function RewardAlgo(uint _addr) internal pure returns (uint) {
    uint releaseAmount = (_addr * 5) / 100; // Calculate 5% of the balance
    return releaseAmount; 

}

}