import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import {
  TOP_AVG_KILLS, TOP_AVG_LOSSES,
  TOP_EXP_COMPANIES, TOP_EXP_SQUADS,
  TOP_INF_KILLERS, TOP_INF_LOSERS,
  TOP_UNIT_KILLERS, TOP_UNIT_LOSERS, TOP_VEH_KILLERS, TOP_VEH_LOSERS,
  TOP_WIN_STREAK,
  TOP_WINS
} from "../../constants/leaderboard";

const companyLeaderboardAdapter = createEntityAdapter()
// Don't need to use entities as this is display only. Sort should be server side

const initialState = companyLeaderboardAdapter.getInitialState({
  [TOP_EXP_COMPANIES]: [],
  [TOP_WINS]: [],
  [TOP_WIN_STREAK]: [],
  [TOP_UNIT_KILLERS]: [],
  [TOP_INF_KILLERS]: [],
  [TOP_VEH_KILLERS]: [],
  [TOP_UNIT_LOSERS]: [],
  [TOP_INF_LOSERS]: [],
  [TOP_VEH_LOSERS]: [],
  [TOP_AVG_KILLS]: [],
  [TOP_AVG_LOSSES]: [],
  [TOP_EXP_SQUADS]: [],

  errorMessage: null
})

export const fetchCompanyLeaderboard = createAsyncThunk(
  "companyLeaderboard/fetchCompanyLeaderboard",
  async ({ limit }, { _, rejectWithValue }) => {
    try {
      const response = await axios.get("/leaderboard", { params: { limit } })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

const companyLeaderboardSlice = createSlice({
  name: "companyLeaderboard",
  initialState,
  reducers: {  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanyLeaderboard.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchCompanyLeaderboard.fulfilled, (state, action) => {
        state.errorMessage = null
        state[TOP_EXP_COMPANIES] = action.payload[TOP_EXP_COMPANIES];
        state[TOP_WINS] = action.payload[TOP_WINS];
        state[TOP_WIN_STREAK] = action.payload[TOP_WIN_STREAK];
        state[TOP_UNIT_KILLERS] = action.payload[TOP_UNIT_KILLERS];
        state[TOP_INF_KILLERS] = action.payload[TOP_INF_KILLERS];
        state[TOP_VEH_KILLERS] = action.payload[TOP_VEH_KILLERS];
        state[TOP_UNIT_LOSERS] = action.payload[TOP_UNIT_LOSERS];
        state[TOP_INF_LOSERS] = action.payload[TOP_INF_LOSERS];
        state[TOP_VEH_LOSERS] = action.payload[TOP_VEH_LOSERS];
        state[TOP_AVG_KILLS] = action.payload[TOP_AVG_KILLS];
        state[TOP_AVG_LOSSES] = action.payload[TOP_AVG_LOSSES];
        state[TOP_EXP_SQUADS] = action.payload[TOP_EXP_SQUADS];
      })
      .addCase(fetchCompanyLeaderboard.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })

  }
})

export default companyLeaderboardSlice.reducer

export const {  } = companyLeaderboardSlice.actions

export const selectCompanyLeaderboardStat = (state, type) => state.companyLeaderboard[type]