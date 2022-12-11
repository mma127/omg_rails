import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanyById } from "../companies/companiesSlice";
import { addSquad, clearCompanyManager, removeSquad, upsertSquads } from "./squadsSlice";
import {
  EMPLACEMENT,
  INFANTRY,
  LIGHT_VEHICLE,
  SUPPORT_TEAM,
  TANK,
  unitTypes
} from "../../constants/units/all_factions";

const availableUnitsAdapter = createEntityAdapter()

const initialState = availableUnitsAdapter.getInitialState({
  [INFANTRY]: [],
  [SUPPORT_TEAM]: [],
  [LIGHT_VEHICLE]: [],
  [TANK]: [],
  [EMPLACEMENT]: [],
  availableUnitsStatus: "idle",
  loadingAvailableUnitsError: null,
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null
})

const renormalizeAvailableUnits = (availableUnits) => {
  /**
   * More useful to key available units by unit id
   */
  return availableUnits.map(au => ({
    ...au,
    id: au.unitId,
    availableUnitId: au.id
  }))
}

const getSortedUnitsForType = (availableUnits, unitType) => {
  return availableUnits.filter(au => au.unitType === unitType)
    .sort((a, b) => a.unitDisplayName.localeCompare(b.unitDisplayName))
}

const setStateForUnitTypes = (availableUnits, state) => {
  unitTypes.forEach(unitType => {
    state[unitType] = getSortedUnitsForType(availableUnits, unitType)
  })
}

const availableUnitsSlice = createSlice({
  name: "availableUnits",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanyById.pending, (state, action) => {
        state.availableUnitsStatus = "pending"
        state.loadingAvailableUnitsError = null
      })
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        const renormalized_available_units = renormalizeAvailableUnits(action.payload.availableUnits)
        availableUnitsAdapter.setAll(state, renormalized_available_units)
        setStateForUnitTypes(renormalized_available_units, state)
        state.availableUnitsStatus = "idle"
      })
      .addCase(fetchCompanyById.rejected, (state, action) => {
        state.availableUnitsStatus = "idle"
        state.loadingAvailableUnitsError = action.payload.error
      })
      .addCase(addSquad, (state, action) => {
        const { unitId } = action.payload
        const availableUnitEntity = state.entities[unitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === unitId)
        availableUnitEntity.available -= 1
        availableUnitTable.available -= 1
        console.log(`${availableUnitEntity.unitName} availability reduced by 1 to ${availableUnitEntity.available}`)
      })
      .addCase(removeSquad, (state, action) => {
        const { unitId } = action.payload
        const availableUnitEntity = state.entities[unitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === unitId)
        availableUnitEntity.available += 1
        availableUnitTable.available += 1
        console.log(`${availableUnitEntity.unitName} availability increased by 1 to ${availableUnitEntity.available}`)
      })

      .addCase(upsertSquads.fulfilled, (state, action) => {
        const renormalized_available_units = renormalizeAvailableUnits(action.payload.availableUnits)
        availableUnitsAdapter.setAll(state, renormalized_available_units)
        setStateForUnitTypes(renormalized_available_units, state)
      })
      .addCase(clearCompanyManager, (state, action) => {
        return initialState
      })
  }
})

export default availableUnitsSlice.reducer

export const {
  selectAll: selectAllAvailableUnits,
  selectById: selectAvailableUnitByUnitId
} = availableUnitsAdapter.getSelectors(state => state.availableUnits)

export const selectInfantryAvailableUnits = state => state.availableUnits[INFANTRY]
export const selectSupportTeamAvailableUnits = state => state.availableUnits[SUPPORT_TEAM]
export const selectLightVehicleAvailableUnits = state => state.availableUnits[LIGHT_VEHICLE]
export const selectTankAvailableUnits = state => state.availableUnits[TANK]
export const selectEmplacementAvailableUnits = state => state.availableUnits[EMPLACEMENT]

export const selectAvailableUnitsStatus = state => state.availableUnits.availableUnitsStatus
