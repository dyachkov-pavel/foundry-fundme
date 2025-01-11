// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    FundFundMe fundFundMe;
    WithdrawFundMe withdrawFundMe;
    address USER = makeAddr("Pushpa");
    uint256 constant FUND_AMOUNT = 0.2 ether;
    uint256 constant STARTING_VALUE = 10 ether;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_VALUE);
        fundFundMe = new FundFundMe();
        withdrawFundMe = new WithdrawFundMe();
        vm.deal(address(fundFundMe), STARTING_VALUE);
    }

    function testUserCanFundInteractions() public {
        // idk this cyfrin test, doesnt work, mb makeAddr("user") is default vm address in 2021 idk
        fundFundMe.fundFundMe(address(fundMe));
        address funder = fundMe.getFunder(0);
        uint256 amountFunded = fundMe.getAddressToAmountFunded(
            address(fundFundMe)
        );
        assertEq(funder, address(fundFundMe));
        assertEq(amountFunded, fundFundMe.SEND_VALUE());
    }

    function testUserCanWithdrawInteractions() public {
        // FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        // WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
