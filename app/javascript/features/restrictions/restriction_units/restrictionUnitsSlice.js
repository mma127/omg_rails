import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const restrictionUnitsAdapter = createEntityAdapter()
// Don't need to use entities as this is display only. Sort should be server side

const initialState = restrictionUnitsAdapter.getInitialState({
  restrictionUnits: [],
  errorMessage: null
})

export const fetchRestrictionUnits = createAsyncThunk(
  "restrictionUnits/fetchRestrictionUnits",
  async ({ rulesetId, factionId, doctrineId }, { _, rejectWithValue }) => {
    try {
      const response = await axios.get("/restrictions/units", { params: { rulesetId, factionId, doctrineId } })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

const restrictionUnitsSlice = createSlice({
  name: "restrictionUnits",
  initialState,
  reducers: {
    clearRestrictionUnits(state) {
      state.restrictionUnits = [];
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchRestrictionUnits.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchRestrictionUnits.fulfilled, (state, action) => {
        state.errorMessage = null
        state.restrictionUnits = action.payload;
      })
      .addCase(fetchRestrictionUnits.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })

  }
})

export default restrictionUnitsSlice.reducer

export const { clearRestrictionUnits } = restrictionUnitsSlice.actions

export const selectRestrictionUnits = state => state.restrictionUnits.restrictionUnits
