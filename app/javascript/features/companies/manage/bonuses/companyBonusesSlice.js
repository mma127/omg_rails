import {createAsyncThunk, createEntityAdapter, createSlice} from "@reduxjs/toolkit";
import axios from "axios"
import {fetchCompanyById} from "../../companiesSlice";
import { fetchCompanySquads } from "../units/squadsSlice";

const companyBonusesAdapter = createEntityAdapter()

const initialState = companyBonusesAdapter.getInitialState({
  activeCompanyId: null,
  manResourceBonus: null, // Potential for the resource bonus amounts to differ by company (ruleset)
  munResourceBonus: null,
  fuelResourceBonus: null,
  manBonusCount: 0,
  munBonusCount: 0,
  fuelBonusCount: 0,
  currentMan: 0,
  currentMun: 0,
  currentFuel: 0,
  maxResourceBonuses: null,
  isChanged: false,
  isSaving: false,
  notifySnackbar: false,
  errorMessage: null
})

export const fetchCompanyBonuses = createAsyncThunk(
  "companyBonuses/fetchCompanyBonuses",
  async ({companyId}, {getState, rejectWithValue}) => {
    try {
      const response = await axios.get(`/companies/${companyId}/bonuses`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const purchaseCompanyResourceBonus = createAsyncThunk(
  "companyBonuses/purchaseCompanyResourceBonus",
  async ({resource}, {getState, rejectWithValue}) => {
    try {
      const companyId = selectActiveCompanyId(getState())
      const response = await axios.post(`/companies/${companyId}/bonuses/purchase`, {resource})
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)


export const refundCompanyResourceBonus = createAsyncThunk(
  "companyBonuses/refundCompanyResourceBonus",
  async ({resource}, {getState, rejectWithValue}) => {
    try {
      const companyId = selectActiveCompanyId(getState())
      const response = await axios.post(`/companies/${companyId}/bonuses/refund`, {resource})
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const companyBonusesSlice = createSlice({
  name: "companyBonuses",
  initialState,
  reducers: {
    resetCompanyBonusesState: () => initialState
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        state.activeCompanyId = action.payload.id
        state.isChanged = false
      })
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        state.isChanged = false
      })

      .addCase(fetchCompanyBonuses.fulfilled, (state, action) => {
        state.manResourceBonus = action.payload.manResourceBonus
        state.munResourceBonus = action.payload.munResourceBonus
        state.fuelResourceBonus = action.payload.fuelResourceBonus
        state.manBonusCount = action.payload.manBonusCount
        state.munBonusCount = action.payload.munBonusCount
        state.fuelBonusCount = action.payload.fuelBonusCount
        state.currentMan = action.payload.currentMan
        state.currentMun = action.payload.currentMun
        state.currentFuel = action.payload.currentFuel
        state.maxResourceBonuses = action.payload.maxResourceBonuses
      })
      .addCase(purchaseCompanyResourceBonus.pending, (state) => {
        state.notifySnackbar = false
        state.errorMessage = null
        state.isSaving = true
      })
      .addCase(purchaseCompanyResourceBonus.fulfilled, (state, action) => {
        state.manResourceBonus = action.payload.manResourceBonus
        state.munResourceBonus = action.payload.munResourceBonus
        state.fuelResourceBonus = action.payload.fuelResourceBonus
        state.manBonusCount = action.payload.manBonusCount
        state.munBonusCount = action.payload.munBonusCount
        state.fuelBonusCount = action.payload.fuelBonusCount
        state.currentMan = action.payload.currentMan
        state.currentMun = action.payload.currentMun
        state.currentFuel = action.payload.currentFuel
        state.isChanged = true
        state.isSaving = false
      })
      .addCase(purchaseCompanyResourceBonus.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.notifySnackbar = true
        state.isSaving = false
      })

      .addCase(refundCompanyResourceBonus.pending, (state) => {
        state.notifySnackbar = false
        state.errorMessage = null
        state.isSaving = true
      })
      .addCase(refundCompanyResourceBonus.fulfilled, (state, action) => {
        state.manResourceBonus = action.payload.manResourceBonus
        state.munResourceBonus = action.payload.munResourceBonus
        state.fuelResourceBonus = action.payload.fuelResourceBonus
        state.manBonusCount = action.payload.manBonusCount
        state.munBonusCount = action.payload.munBonusCount
        state.fuelBonusCount = action.payload.fuelBonusCount
        state.currentMan = action.payload.currentMan
        state.currentMun = action.payload.currentMun
        state.currentFuel = action.payload.currentFuel
        state.isChanged = true
        state.isSaving = false
      })
      .addCase(refundCompanyResourceBonus.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.notifySnackbar = true
        state.isSaving = false
      })
  }
})

export default companyBonusesSlice.reducer

export const selectActiveCompanyId = state => state.companyUnlocks.activeCompanyId
export const selectCompanyBonuses = state => {
  return {
    manResourceBonus: state.companyBonuses.manResourceBonus,
    munResourceBonus: state.companyBonuses.munResourceBonus,
    fuelResourceBonus: state.companyBonuses.fuelResourceBonus,
    manBonusCount: state.companyBonuses.manBonusCount,
    munBonusCount: state.companyBonuses.munBonusCount,
    fuelBonusCount: state.companyBonuses.fuelBonusCount,
    manCurrent: state.companyBonuses.currentMan,
    munCurrent: state.companyBonuses.currentMun,
    fuelCurrent: state.companyBonuses.currentFuel,
    maxResourceBonuses: state.companyBonuses.maxResourceBonuses
  }
}

export const selectAvailableRBs = state => {
  const usedRB = state.companyBonuses.manBonusCount + state.companyBonuses.munBonusCount + state.companyBonuses.fuelBonusCount
  return Math.max(state.companyBonuses.maxResourceBonuses - usedRB, 0)
}

export const selectIsCompanyBonusesChanged = state => {
  return state.companyBonuses.isChanged
}
