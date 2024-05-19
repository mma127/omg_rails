import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const statsUnitsAdapter = createEntityAdapter({
  selectId: entity => entity.constName
})

const initialState = statsUnitsAdapter.getInitialState({
  errorMessage: null
})

export const fetchStatsUnit = createAsyncThunk(
  "statsUnits/fetchStatsUnit",
  async ({rulesetId, constName}, {_, rejectWithValue}) => {
    try {
      const response = await axios.get("/stats/units", { params: { ruleset_id: rulesetId, const_name: constName } })
      return response.data
    } catch(err) {
      return rejectWithValue(err.response.data)
    }
  })

const statsUnitsSlice = createSlice({
  name: "statsUnits",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchStatsUnit.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchStatsUnit.fulfilled, (state, action) => {
        state.errorMessage = null
        statsUnitsAdapter.addOne(state, action.payload.statsUnit);
      })
      .addCase(fetchStatsUnit.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })
  }
})

export default statsUnitsSlice.reducer

export const { } = statsUnitsSlice.actions

export const {
  selectAll: selectAllStatsUnits,
  selectById: selectStatsUnitByConstName
} = statsUnitsAdapter.getSelectors(state => state.statsUnits)
