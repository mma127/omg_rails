import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const factionsAdapter = createEntityAdapter()

const initialState = factionsAdapter.getInitialState()

export const fetchFactions = createAsyncThunk("factions/fetchFactions", async () => {
  const response = await axios.get("/factions")
  return response.data
})

const factionsSlice = createSlice({
  name: "factions",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchFactions.fulfilled, (state, action) => {
        factionsAdapter.setAll(state, action.payload)
      })
  }
})

export default factionsSlice.reducer

export const {
  selectAll: selectAllFactions,
  selectById: selectFactionById
} = factionsAdapter.getSelectors(state => state.factions)
