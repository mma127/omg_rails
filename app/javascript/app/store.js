import { configureStore } from '@reduxjs/toolkit'
import playerSlice from "../features/player/playerSlice";
import companiesSlice from "../features/companies/companiesSlice";
import doctrinesSlice from "../features/doctrines/doctrinesSlice";
import unitsSlice from "../features/units/unitsSlice";
import availableUnitsSlice from "../features/units/availableUnitsSlice";
import squadsSlice from "../features/units/squadsSlice";
import lobbySlice from "../features/lobby/lobbySlice";
import companyUnlocksSlice from "../features/companies/manage/unlocks/companyUnlocksSlice";


export default configureStore({
  reducer: {
    player: playerSlice,
    companies: companiesSlice,
    companyUnlocks: companyUnlocksSlice,
    doctrines: doctrinesSlice,
    units: unitsSlice,
    availableUnits: availableUnitsSlice,
    squads: squadsSlice,
    lobby: lobbySlice
  },
})
