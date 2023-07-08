// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    // Creating a struct to store the information of every single campaign.
    struct Campaign {
        address owner; // address of the person who started campaign.
        string title; // title of campaign.
        string description; // description of the campaign.
        uint256 target; // target price required for the campaign.
        uint256 deadline; // time and date before which people can donate.
        uint256 amountCollected; // total amount collected.
        string image; // url of the image with the campaign.
        address[] donators; // array which stores the addresses of donators.
        uint256[] donations; // array which stores the amount donated by each donator.
    }

    // Create a mapping which creates something essentially like an array.
    mapping(uint256 => Campaign) public campaigns;

    uint256 campaignNumber; // to keep track of the number of campaigns.

    // function to create a campaign in the form of a struct.
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _imageURL
    ) public returns (uint256) {
        // creates a Campaign object to populate a particular campaign => [{},{}] any one is 'campaign'
        Campaign storage campaign = campaigns[campaignNumber];

        // this is like an if-else statement which needs to always be true to proceed.
        require(campaign.deadline < block.timestamp);

        //populating the campaign with values received from the front-end.
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.deadline = _deadline;
        campaign.description = _description;
        campaign.target = _target;
        campaign.image = _imageURL;

        campaignNumber++; // increment the number of campaigns
        return campaignNumber - 1; // returns the index of the latest campaign.
    }

    // function to pay amount to the campaign owner's wallet address.
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value; // amount donated by the donor; to be sent to the owner.
        address sender = msg.sender; // address of the donor's wallet.

        Campaign storage campaign = campaigns[_id]; // campaign object initiation.
        campaign.donators.push(sender); // populating the donator's array by pushing the address.
        campaign.donations.push(amount); // populating the donations array by pushing the donations by each donor.

        (bool sent, ) = payable(campaign.owner).call{value: amount}(""); // to check if the transaction was successful.
        if (sent) {
            campaign.amountCollected += amount; // to append the total amount collected if donation is successful.
        }
    }

    // function to view the list of the addresses of donors.
    function getDonors(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations); // returns the lists 'donators' and 'donations'.
    }

    // function to get a list of all the campaigns which are in the form of structs. this function returns an array of structs. [{},{},{},..].
    function getCampaigns() public view returns (Campaign[] memory) {
        // to create an empty array of structs which will be populated later
        Campaign[] memory allCampaigns = new Campaign[](campaignNumber);

        // for loop to iterate through all the structs and store them in the array created.
        for (uint256 i = 0; i < campaignNumber; i++) {
            Campaign storage item = campaigns[i]; // campaign object created called item.
            allCampaigns[i] = item; // each struct is pushed into the array created.
        }
        return (allCampaigns);
    }
}
