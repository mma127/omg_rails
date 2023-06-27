import { upgradeImageMapping as americanUpgradeImageMapping } from "./americans";
import { upgradeImageMapping as britishUpgradeImageMapping } from "./british";
import { upgradeImageMapping as wehrmachtUpgradeImageMapping } from "./wehrmacht";
import { upgradeImageMapping as peUpgradeImageMapping } from "./panzer_elite";

export const upgradeImageMapping = {
  ...americanUpgradeImageMapping,
  ...britishUpgradeImageMapping,
  ...wehrmachtUpgradeImageMapping,
  ...peUpgradeImageMapping,
}
