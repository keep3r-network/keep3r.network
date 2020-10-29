# Keepers

Keepers are bots, scripts, other contracts, or simply EOA accounts that trigger events. This can be submitting a signed TX on behalf of a third party, calling a transaction at a specific time, or more complex functionality.  

Each time you execute such a function, you are rewarded in either ETH, tokens, or the systems native token KPR. The maximum amount of KPR receivable is gasUsed + premium (configured by governance).  

Jobs might require keepers that have a minimum amount of bonded tokens, have earned a minimum amount of fees, or have been in the system longer than a certain period of time.  

At the most simple level, they simply require a keeper to be registered in the system.  

## Becoming a Keeper

To become a keeper, you simply need to call ```bond(address,uint)```, no funds are required to become a keeper, however certain jobs might require a minimum amount of funds.

```
/**
 * @notice begin the bonding process for a new keeper
 * @param bonding the asset being bound
 * @param amount the amount of bonding asset being bound
 */
function bond(address bonding, uint amount) external
```

After waiting ```BOND``` days (default 3 days) and you can activate as a keeper;

```
/**
 * @notice allows a keeper to activate/register themselves after bonding
 * @param bonding the asset being activated as bond collateral
 */
function activate(address bonding) external
```

## Removing a Keeper

If you no longer wish to participate you can unbond to deactivate.

```
/**
 * @notice begin the unbonding process to stop being a keeper
 * @param bonding the asset being unbound
 * @param amount allows for partial unbonding
 */
function unbond(address bonding, uint amount) external
```

After waiting ```UNBOND``` days (default 14 days) you can withdraw any bonded assets

```
/**
 * @notice withdraw funds after unbonding has finished
 * @param bonding the asset to withdraw from the bonding pool
 */
function withdraw(address bonding) external
```

## Additional Requirements

Some jobs might have additional requirements such as minimum bonded protocol tokens (for example SNX). In such cases you would need to bond a minimum amount of SNX before you may qualify for the job.
