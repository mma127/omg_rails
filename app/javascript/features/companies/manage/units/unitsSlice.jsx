import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { fetchCompanyAvailability } from "../available_units/availableUnitsSlice";
import { fetchCompanySquads } from "./squadsSlice";

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
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        for (const au of action.payload.availableUnits)
          unitsAdapter.upsertOne(state, au.unit)
      })
  }
})

export default unitsSlice.reducer

export const {
  selectAll: selectAllUnits,
  selectById: selectUnitById
} = unitsAdapter.getSelectors(state => state.units)
