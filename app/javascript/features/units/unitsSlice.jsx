import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { fetchCompanyAvailableUnits } from "./availableUnitsSlice";

const unitsAdapter = createEntityAdapter()

const initialState = unitsAdapter.getInitialState({})

export const fetchUnitById = createAsyncThunk(
  "units/fetchUnitById",
  async ({ unitId }) => {
    try {
      const response = await axios.get(`/units/${unitId}`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

const unitsSlice = createSlice({
  name: "units",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchUnitById.fulfilled, (state, action) => {
        unitsAdapter.upsertOne(state, action.payload)
      })
      .addCase(fetchCompanyAvailableUnits.fulfilled, (state, action) => {
        for (const au of action.payload)
          unitsAdapter.upsertOne(state, au.unit)
      })
  }
})

export default unitsSlice.reducer

export const {
  selectAll: selectAllUnits,
  selectById: selectUnitById
} = unitsAdapter.getSelectors(state => state.units)
