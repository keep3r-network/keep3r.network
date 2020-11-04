// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface IKeep3rV1 {
    function isKeeper(address) external returns (bool);
    function worked(address keeper) external;
}

interface IBZx {

    /// @dev liquidates unhealty loans
    /// @param loanId id of the loan
    /// @param receiver address receiving liquidated loan collateral
    /// @param closeAmount amount to close denominated in loanToken
    /// @return loanCloseAmount amount of the collateral token of the loan
    /// @return seizedAmount sezied amount in the collateral token
    /// @return seizedToken loan token address
    function liquidate(
        bytes32 loanId,
        address receiver,
        uint256 closeAmount)
        external
        payable
        returns (
            uint256 loanCloseAmount,
            uint256 seizedAmount,
            address seizedToken);

    /// @dev get current active loans in the system
    /// @param start of the index
    /// @param count number of loans to return
    /// @param unsafeOnly boolean if true return unsafe loan only (open for liquidation)
    function getActiveLoans(
        uint256 start,
        uint256 count,
        bool unsafeOnly)
        external
        view
        returns (LoanReturnData[] memory loansData);

    function getActiveLoansCount()
        external
        view
        returns (uint256);

    /// @dev gets existing loan
    /// @param loanId id of existing loan
    /// @return loanData array of loans
    function getLoan(
        bytes32 loanId)
        external
        view
        returns (LoanReturnData memory loanData);

    struct LoanReturnData {
        bytes32 loanId; // id of the loan
        uint96 endTimestamp; // loan end timestamp
        address loanToken; // loan token address
        address collateralToken; // collateral token address
        uint256 principal; // principal amount of the loan
        uint256 collateral; // collateral amount of the loan
        uint256 interestOwedPerDay; // interest owned per day
        uint256 interestDepositRemaining; // remaining unspent interest
        uint256 startRate; // collateralToLoanRate
        uint256 startMargin; // margin with which loan was open
        uint256 maintenanceMargin; // maintenance margin
        uint256 currentMargin; // current margin
        uint256 maxLoanTerm; // maximum term of the loan
        uint256 maxLiquidatable; // is the collateral you can get liquidating
        uint256 maxSeizable; // is the loan you available for liquidation
        uint256 depositValue; // value of loan opening deposit
        uint256 withdrawalValue; // value of loan closing withdrawal
    }
}

contract BzxLiquidate {

    IKeep3rV1 public constant KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    IBZx public constant BZX = IBZx(address(0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f));
    // address public constant  PROFIT = 0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f; // TODO


    modifier upkeep() {
        require(KP3R.isKeeper(msg.sender), "::isKeeper: keeper is not registered");
        _;
        KP3R.worked(msg.sender);
    }


    function liquidate(bytes32 loanId) external upkeep {
        
        IBZx.LoanReturnData memory loan = BZX.getLoan(loanId);

        IERC20(loan.collateralToken).transferFrom(msg.sender, address(this), loan.maxLiquidatable);
        IERC20(loan.collateralToken).approve(address(BZX), loan.maxLiquidatable);

        BZX.liquidate(loanId, address(this), uint(-1));
        
        IERC20(loan.collateralToken).approve(address(BZX), 0);

        uint256 _liquidated = IERC20(loan.collateralToken).balanceOf(address(this));
        require(_liquidated > 0, "Failed to liquidate");

        IERC20(loan.collateralToken).transfer(msg.sender, IERC20(loan.collateralToken).balanceOf(address(this)));
        IERC20(loan.loanToken).transfer(msg.sender, IERC20(loan.loanToken).balanceOf(address(this)));

    }
}
