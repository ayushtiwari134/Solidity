// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Amazon {
    // initiates the owner's address.
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // modifier to check that the person calling a particular function is the owner himself
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // item struct to store the created item
    struct Item {
        uint id;
        string name;
        string category;
        string imgUrl;
        uint cost;
        uint stock;
        string rating;
    }

    // struct to store the items ordered by a buyer
    struct Orders {
        uint quantity;
        Item item;
    }

    // mapping to map id to Item struct
    mapping(uint => Item) public items;
    // mapping to map buyer's address to Orders struct
    mapping(address => Orders) public orders;

    // function to create item and store on blockchain
    function createItem(
        uint _id,
        string memory _name,
        string memory _category,
        string memory _imgUrl,
        uint _cost,
        uint _stock,
        string memory _rating
    ) public onlyOwner {
        Item memory item = Item(
            _id,
            _name,
            _category,
            _imgUrl,
            _cost,
            _stock,
            _rating
        );
        items[_id] = item;
    }

    // function to buy item, i.e. create an order
    function buyItem(uint _id, uint _quantity) public payable {
        Item memory item = items[_id];
        require(msg.value == item.cost * _quantity);
        items[_id].stock -= _quantity;
        Orders memory order = Orders(_quantity, items[_id]);
        orders[msg.sender] = order;
    }

    // function to send the balance to the owner
    function withdrawFunds() public onlyOwner {
        // method to transfer funds
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}
