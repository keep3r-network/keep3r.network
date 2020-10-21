# Governance

KPR governance by design has a low overhead, it is not meant to be protocol intensive. The focus is simply on reviewing and approving jobs, and if absolutely required mitigate disputes or blacklist keepers.

## Participants

Only bonded Keepers may participate in governance. To participate in governance a keeper must first ```bond``` KPR, once bonded they can ```delegate``` voting rights to either themselves or another party.

## Managing Jobs

The core function of governance is to approve and include jobs, when liquidity is provided for a job, a proposal is automatically created to include them for review. Bonded keepers will review the contracts and decide if they should be included. It is important that jobs code defensively, assume keepers will only include your job to maximize their returns, as such maximum payment thresholds have been implemented.

```
/**
 * @notice Allows governance to add new job systems
 * @param job address of the contract for which work should be performed
 */
function addJob(address job) external
```

```
/**
 * @notice Allows governance to remove a job from the systems
 * @param job address of the contract for which work should be performed
 */
function removeJob(address job) external
```

## Managing Keepers

As a last resort, governance has certain rights over managing Keepers, these include lodging disputes, slashing, revoking access, and resolving disputes.

### Dispute Management

```
/**
 * @notice allows governance to create a dispute for a given keeper
 * @param keeper the address in dispute
 */
function dispute(address keeper) external
```

```
/**
 * @notice allows governance to resolve a dispute on a keeper
 * @param keeper the address cleared
 */
function resolve(address keeper) external
```

### Slashing

```
/**
 * @notice allows governance to slash a keeper based on a dispute
 * @param bonded the asset being slashed
 * @param keeper the address being slashed
 * @param amount the amount being slashed
 */
function slash(address bonded, address keeper, uint amount) public
```

### Blacklist

```
/**
 * @notice blacklists a keeper from participating in the network
 * @param keeper the address being slashed
 */
function revoke(address keeper) external
```
