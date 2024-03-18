import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const warStatsAdapter = createEntityAdapter()
// Don't need to use entities as this is display only. Sort should be server side

const initialState = warStatsAdapter.getInitialState({
  doctrines: [],
  factions: [],
  alliedWins: 0,
  axisWins: 0,
  generatedAt: null,
  errorMessage: null
})

export const fetchWarStats = createAsyncThunk(
  "warStats/fetchWarStats",
  async ({ ruleset_id }, { rejectWithValue }) => {
    try {
      const response = await axios.get("/leaderboard/war_stats", { params: { ruleset_id } })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const warStatsSlice = createSlice({
  name: "warStats",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchWarStats.pending, (state) => {
        state.battles = []
        state.errorMessage = null
      })
      .addCase(fetchWarStats.fulfilled, (state, action) => {
        state.doctrines = action.payload.doctrines
        state.factions = action.payload.factions
        state.alliedWins = action.payload.alliedWins
        state.axisWins = action.payload.axisWins
        state.generatedAt = action.payload.generatedAt
      })
      .addCase(fetchWarStats.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })
  }
})

export default warStatsSlice.reducer

export const {} = warStatsSlice.actions

export const selectDoctrinesWarStats = state => state.warStats.doctrines
export const selectFactionsWarStats = state => state.warStats.factions
export const selectWarStatsAlliedAxisWins = state => [state.warStats.alliedWins, state.warStats.axisWins]
export const selectWarStatsGeneratedAt = state => state.warStats.generatedAt
