import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import {
  addNonTransportedSquad,
  addTransportedSquad,
  copySquad,
  fetchCompanySquads,
  fetchSnapshotCompanySquads,
  removeSquad,
  removeTransportedSquad,
  upsertSquads
} from "../units/squadsSlice";
import {
  EMPLACEMENT,
  GLIDER,
  INFANTRY,
  LIGHT_VEHICLE,
  SUPPORT_TEAM,
  TANK,
  unitTypes
} from "../../../../constants/units/all_factions";
import axios from "axios";

const availableUnitsAdapter = createEntityAdapter()
const initialState = availableUnitsAdapter.getInitialState({
  [INFANTRY]: [],
  [SUPPORT_TEAM]: [],
  [LIGHT_VEHICLE]: [],
  [TANK]: [],
  [EMPLACEMENT]: [],
  [GLIDER]: [],
  availableUnitsStatus: "idle",
  loadingAvailableUnitsError: null,
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null,
  selectedAvailableUnitId: null
})

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
  reducers: {
    resetAvailableUnitState: () => initialState,
    setSelectedAvailableUnitId: (state, action) => {
      state.selectedAvailableUnitId = action.payload
    },
    clearSelectedAvailableUnitId: state => {
      state.selectedAvailableUnitId = null
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        availableUnitsAdapter.setAll(state, action.payload.availableUnits)
        setStateForUnitTypes(action.payload.availableUnits, state)
        state.availableUnitsStatus = "idle"
      })
      .addCase(fetchSnapshotCompanySquads.fulfilled, (state, action) => {
        availableUnitsAdapter.setAll(state, action.payload.availableUnits)
        setStateForUnitTypes(action.payload.availableUnits, state)
        state.availableUnitsStatus = "idle"
      })

      .addCase(addNonTransportedSquad, (state, action) => {
        const { availableUnitId } = action.payload
        const availableUnitEntity = state.entities[availableUnitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === availableUnitId)
        availableUnitEntity.available -= 1
        availableUnitTable.available -= 1
        console.log(`${availableUnitEntity.unitName} availability reduced by 1 to ${availableUnitEntity.available}`)
      })
      .addCase(addTransportedSquad, (state, action) => {
        const { newSquad: { availableUnitId }, _ } = action.payload
        const availableUnitEntity = state.entities[availableUnitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === availableUnitId)
        availableUnitEntity.available -= 1
        availableUnitTable.available -= 1
        console.log(`${availableUnitEntity.unitName} availability reduced by 1 to ${availableUnitEntity.available}`)
      })
      .addCase(copySquad, (state, action) => {
        const { squad: { availableUnitId } } = action.payload
        const availableUnitEntity = state.entities[availableUnitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === availableUnitId)
        availableUnitEntity.available -= 1
        availableUnitTable.available -= 1
        console.log(`${availableUnitEntity.unitName} availability reduced by 1 to ${availableUnitEntity.available}`)
      })
      .addCase(removeSquad, (state, action) => {
        const { availableUnitId } = action.payload
        const availableUnitEntity = state.entities[availableUnitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === availableUnitId)
        availableUnitEntity.available += 1
        availableUnitTable.available += 1
        console.log(`${availableUnitEntity.unitName} availability increased by 1 to ${availableUnitEntity.available}`)
      })
      .addCase(removeTransportedSquad, (state, action) => {
        const { squad } = action.payload
        const availableUnitEntity = state.entities[squad.availableUnitId]
        const availableUnitTable = state[availableUnitEntity.unitType].find(e => e.id === squad.availableUnitId)
        availableUnitEntity.available += 1
        availableUnitTable.available += 1
        console.log(`${availableUnitEntity.unitName} availability increased by 1 to ${availableUnitEntity.available}`)
      })

      .addCase(upsertSquads.fulfilled, (state, action) => {
        availableUnitsAdapter.setAll(state, action.payload.availableUnits)
        setStateForUnitTypes(action.payload.availableUnits, state)
      })
  }
})

export default availableUnitsSlice.reducer

export const {
  resetAvailableUnitState,
  setSelectedAvailableUnitId,
  clearSelectedAvailableUnitId
} = availableUnitsSlice.actions

export const {
  selectAll: selectAllAvailableUnits,
  selectById: selectAvailableUnitById
} = availableUnitsAdapter.getSelectors(state => state.availableUnits)

export const selectInfantryAvailableUnits = state => state.availableUnits[INFANTRY]
export const selectSupportTeamAvailableUnits = state => state.availableUnits[SUPPORT_TEAM]
export const selectLightVehicleAvailableUnits = state => state.availableUnits[LIGHT_VEHICLE]
export const selectTankAvailableUnits = state => state.availableUnits[TANK]
export const selectEmplacementAvailableUnits = state => state.availableUnits[EMPLACEMENT]
export const selectGliderAvailableUnits = state => state.availableUnits[GLIDER]

export const selectAvailableUnitsStatus = state => state.availableUnits.availableUnitsStatus

export const selectSelectedAvailableUnitId = state => state.availableUnits.selectedAvailableUnitId
