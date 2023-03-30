import { offmapImageMapping as americanOffmapImageMapping } from "./americans"
import { offmapImageMapping as britishOffmapImageMapping } from "./british"
import { offmapImageMapping as wehrmachtOffmapImageMapping } from "./wehrmacht"
import { offmapImageMapping as panzerEliteOffmapImageMapping } from "./panzer_elite"

export const offmapImageMapping = {
  ...americanOffmapImageMapping,
  ...britishOffmapImageMapping,
  ...wehrmachtOffmapImageMapping,
  ...panzerEliteOffmapImageMapping,
}