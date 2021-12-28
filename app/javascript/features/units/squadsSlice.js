import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { ANTI_ARMOUR, ARMOUR, ASSAULT, CORE, INFANTRY, SUPPORT } from "../../constants/company";
import { fetchCompanyById } from "../companies/companiesSlice";

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

export const fetchCompanySquads = createAsyncThunk("companies/fetchCompanySquads", async ({ companyId }) => {
  const response = await axios.get(`/companies/${companyId}/squads`)
  return response.data
})

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
