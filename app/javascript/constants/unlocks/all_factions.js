import { unlockImageMapping as americanUnlockImageMapping } from "./americans";

// Since it's possible to have unlocks of any kind in a doctrine, let's construct a mapping of all unlock images
// This is acceptable as unlock names are unique
export const unlockImageMapping = {
  ...americanUnlockImageMapping
}
