import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const warLogAdapter = createEntityAdapter()
// Don't need to use entities as this is display only. Sort should be server side

const initialState = warLogAdapter.getInitialState({
  battles: [],
  errorMessage: null
})

export const fetchBattlesHistory = createAsyncThunk(
  "warLog/fetchBattlesHistory",
  async ({ ruleset_id }, { rejectWithValue }) => {
    try {
      const response = await axios.get("/leaderboard/battles_history", { params: { ruleset_id } })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const warLogSlice = createSlice({
  name: "warLog",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchBattlesHistory.pending, (state) => {
        state.battles = []
        state.errorMessage = null
      })
      .addCase(fetchBattlesHistory.fulfilled, (state, action) => {
        state.battles = action.payload
      })
      .addCase(fetchBattlesHistory.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })
  }
})

export default warLogSlice.reducer

export const {} = warLogSlice.actions

export const selectBattlesHistory = (state) => state.warLog.battles
