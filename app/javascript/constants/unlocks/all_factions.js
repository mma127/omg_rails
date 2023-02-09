import { unlockImageMapping as americanUnlockImageMapping } from "./americans";
import { unlockImageMapping as britishUnlockImageMapping } from "./british";
import { unlockImageMapping as wehrmachtUnlockImageMapping } from "./wehrmacht";
import { unlockImageMapping as panzerEliteUnlockImageMapping } from "./panzer_elite";

// Since it's possible to have unlocks of any kind in a doctrine, let's construct a mapping of all unlock images
// This is acceptable as unlock names are unique
export const unlockImageMapping = {
  ...americanUnlockImageMapping,
  ...britishUnlockImageMapping,
  ...wehrmachtUnlockImageMapping,
  ...panzerEliteUnlockImageMapping
}
