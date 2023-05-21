import { configureStore } from '@reduxjs/toolkit'
import playerSlice from "../features/player/playerSlice";
import companiesSlice from "../features/companies/companiesSlice";
import doctrinesSlice from "../features/doctrines/doctrinesSlice";
import unitsSlice from "../features/companies/manage/units/unitsSlice";
import availableUnitsSlice from "../features/companies/manage/available_units/availableUnitsSlice";
import squadsSlice from "../features/companies/manage/units/squadsSlice";
import lobbySlice from "../features/lobby/lobbySlice";
import companyUnlocksSlice from "../features/companies/manage/unlocks/companyUnlocksSlice";
import availableOffmapsSlice from "../features/companies/manage/available_offmaps/availableOffmapsSlice";
import companyOffmapsSlice from "../features/companies/manage/company_offmaps/companyOffmapsSlice";
import availableUpgradesSlice from "../features/companies/manage/available_upgrades/availableUpgradesSlice";
import upgradesSlice from "../features/companies/manage/upgrades/upgradesSlice";

export default configureStore({
  reducer: {
    player: playerSlice,
    companies: companiesSlice,
    companyUnlocks: companyUnlocksSlice,
    doctrines: doctrinesSlice,
    units: unitsSlice,
    availableUnits: availableUnitsSlice,
    availableOffmaps: availableOffmapsSlice,
    squads: squadsSlice,
    companyOffmaps: companyOffmapsSlice,
    lobby: lobbySlice,
    availableUpgrades: availableUpgradesSlice,
    upgrades: upgradesSlice
  },
})
