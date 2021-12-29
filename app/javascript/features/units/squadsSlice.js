import { createAsyncThunk, createEntityAdapter, createSlice, nanoid } from "@reduxjs/toolkit";
import axios from "axios"
import _ from "lodash"
import { ANTI_ARMOUR, ARMOUR, ASSAULT, CATEGORIES, CORE, INFANTRY, SUPPORT } from "../../constants/company";
import { fetchCompanyById } from "../companies/companiesSlice";
import { createSquad } from "./squad";
import { unitImageMapping } from "../../constants/units/all_factions";

const squadsAdapter = createEntityAdapter()

const initialState = squadsAdapter.getInitialState({
  squadsStatus: "idle",
  squadsError: null,
  pop: 0,
  man: 0,
  mun: 0,
  fuel: 0,
  [CORE]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ASSAULT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [INFANTRY]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ANTI_ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [SUPPORT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} }
})

export const fetchCompanySquads = createAsyncThunk("squads/fetchCompanySquads", async ({ companyId }) => {
  const response = await axios.get(`/companies/${companyId}/squads`)
  return response.data
})

export const upsertSquads = createAsyncThunk("squads/upsertSquads", async ({ companyId }, { getState }) => {
  const squads = selectCurrentSquads(getState())
  const response = await axios.post(`/companies/${companyId}/squads`, { squads })
  return response.data
})

const buildNewSquadTabs = (squads) => {
  const tabs = {
    [CORE]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ASSAULT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [INFANTRY]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ANTI_ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [SUPPORT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} }
  }

  squads.forEach(squad => {
    const platoon = tabs[squad.tab][squad.index]
    const uuid = nanoid()
    const image = unitImageMapping[squad.unitName]
    platoon[uuid] = createSquad(uuid, squad.id, squad.unitId, squad.unitName, squad.pop, squad.man, squad.mun,
      squad.fuel, image, squad.index, squad.tab)
  })
  return tabs
}

const squadsSlice = createSlice({
  name: "squads",
  initialState,
  reducers: {
    addSquad(state, action) {
      const { uuid, index, tab } = action.payload
      const platoon = state[tab][index]
      if (!Object.keys(platoon).includes(uuid)) {
        platoon[uuid] = action.payload
      }
    },
    removeSquad(state, action) {
      const { uuid, index, tab } = action.payload
      const platoon = state[tab][index]
      if (Object.keys(platoon).includes(uuid)) {
        delete platoon[uuid]
      }
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanyById.pending, (state, action) => {
        state.squadsStatus = "pending"
        state.squadsError = null
      })
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        squadsAdapter.setAll(state, action.payload.squads)
        // TODO populate tabs

        state.squadsStatus = "idle"
      })
      .addCase(fetchCompanyById.rejected, (state, action) => {
        state.squadsStatus = "idle"
        state.squadsError = action.error.message
      })

      .addCase(upsertSquads.pending, (state, action) => {
        state.squadsStatus = "pending"
        state.squadsError = null
      })
      .addCase(upsertSquads.fulfilled, (state, action) => {
        // action.payload.squads & action.payload.availableUnits
        squadsAdapter.setAll(state, action.payload.squads)
        const newTabs = buildNewSquadTabs(action.payload.squads)
        for (const tabName of CATEGORIES) {
          state[tabName] = newTabs[tabName]
        }
        state.squadsStatus = "idle"
      })
      .addCase(upsertSquads.rejected, (state, action) => {
        state.squadsStatus = "idle"
        state.squadsError = action.error.message
      })
  }
})

export default squadsSlice.reducer

export const { addSquad, removeSquad } = squadsSlice.actions

export const {
  selectAll: selectAllSquads,
  selectById: selectSquadById
} = squadsAdapter.getSelectors(state => state.squads)

export const selectCoreSquads = state => state.squads[CORE]
export const selectAssaultSquads = state => state.squads[ASSAULT]
export const selectInfantrySquads = state => state.squads[INFANTRY]
export const selectArmourSquads = state => state.squads[ARMOUR]
export const selectAntiArmourSquads = state => state.squads[ANTI_ARMOUR]
export const selectSupportSquads = state => state.squads[SUPPORT]

export const selectCurrentSquads = state => {
  let squads = []
  CATEGORIES.forEach(category => {
    const squadsForCat = state.squads[category]
    Object.values(squadsForCat).filter(indexSquads => !_.isEmpty(indexSquads)).forEach(indexSquads => {
      squads = squads.concat(Object.values(indexSquads))
    })
  })
  return squads
}
