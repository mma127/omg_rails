import { createAsyncThunk, createEntityAdapter, createSelector, createSlice } from "@reduxjs/toolkit";
import { fetchStatsUnit } from "../units/statsUnitsSlice";
import axios from "axios";

const statsWeaponsAdapter = createEntityAdapter({
  selectId: entity => entity.reference
})

const initialState = statsWeaponsAdapter.getInitialState({
  errorMessage: null
})

export const fetchStatsWeapon = createAsyncThunk(
  "statsWeapons/fetchStatsWeapon",
  async ({rulesetId, reference}, {_, rejectWithValue}) => {
    try {
      const response = await axios.get("/stats/weapons", { params: { ruleset_id: rulesetId, reference: reference } })
      return response.data
    } catch(err) {
      return rejectWithValue(err.response.data)
    }
  })

const statsWeaponsSlice = createSlice({
  name: "statsWeapons",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchStatsWeapon.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchStatsWeapon.fulfilled, (state, action) => {
        state.errorMessage = null
        statsWeaponsAdapter.addOne(state, action.payload);
      })
      .addCase(fetchStatsWeapon.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })

      .addCase(fetchStatsUnit.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchStatsUnit.fulfilled, (state, action) => {
        state.errorMessage = null
        statsWeaponsAdapter.addMany(state, action.payload.statsWeapons);
      })
      .addCase(fetchStatsUnit.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })
  }
})

export default statsWeaponsSlice.reducer

export const {} = statsWeaponsSlice.actions

export const {
  selectAll: selectAllStatsWeapons,
  selectById: selectStatsWeaponByReference
} = statsWeaponsAdapter.getSelectors(state => state.statsWeapons)

// Since this returns a new Object, memoize it to avoid unnecessary re-renders
export const selectStatsWeaponsByReference = createSelector(
  [
    (state) => state.statsWeapons,
    (state, references) => references
  ],
  (state, references) => {
    const result = {}
    if (references) {
      references.forEach(r => {
        result[r] = state.entities[r]
      })
    }
    return result
  }
)