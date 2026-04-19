// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BundleAuctioneer {
    struct Auction {
        bytes bundleData;
        uint256 startPrice;
        uint256 reservePrice;
        uint256 duration;
        address highestBidder;
        uint256 highestBid;
        uint256 endTime;
    }
    
    mapping(uint256 => Auction) public auctions;
    uint256 public auctionCount;
    
    function createMEVAuction(
        bytes calldata bundleData,
        uint256 startPrice,
        uint256 reservePrice,
        uint256 duration
    ) external returns (uint256 auctionId) {
        auctionId = auctionCount++;
        auctions[auctionId] = Auction({
            bundleData: bundleData,
            startPrice: startPrice,
            reservePrice: reservePrice,
            duration: duration,
            highestBidder: address(0),
            highestBid: 0,
            endTime: block.timestamp + duration
        });
    }
    
    function bid(uint256 auctionId) external payable {
        Auction storage auction = auctions[auctionId];
        require(block.timestamp < auction.endTime, "auction ended");
        
        uint256 currentPrice = _dutchAuctionPrice(auction);
        require(msg.value >= currentPrice, "bid too low");
        
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }
        
        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
}
