import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const unitsAdapter = createEntityAdapter()

const initialState = unitsAdapter.getInitialState({})

export const fetchUnitsByDoctrineId = createAsyncThunk("units/fetchUnitsByDoctrineId", async ({doctrineId}) => {
  const response = await axios.get(`/doctrines/${doctrineId}/units`)
  return response.data
})

const unitsSlice = createSlice({
  name: "units",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchUnitsByDoctrineId.fulfilled, (state, action) => {
        unitsAdapter.upsertMany(state, action.payload)
      })
  }
})

export default unitsSlice.reducer

export const {
  selectAll: selectAllUnits,
  selectById: selectUnitById
} = unitsAdapter.getSelectors(state => state.units)
