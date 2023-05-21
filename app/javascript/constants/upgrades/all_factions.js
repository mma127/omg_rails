import { upgradeImageMapping as americanUpgradeImageMapping } from "./americans";
import { upgradeImageMapping as britishUpgradeImageMapping } from "./british";

export const upgradeImageMapping = {
  ...americanUpgradeImageMapping,
  ...britishUpgradeImageMapping,
}
