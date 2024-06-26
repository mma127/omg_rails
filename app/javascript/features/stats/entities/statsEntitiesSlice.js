import { createEntityAdapter, createSelector, createSlice } from "@reduxjs/toolkit";
import { fetchStatsUnit } from "../units/statsUnitsSlice";

const statsEntitiesAdapter = createEntityAdapter({
  selectId: entity => entity.reference
})

const initialState = statsEntitiesAdapter.getInitialState({
  errorMessage: null
})

const statsEntitiesSlice = createSlice({
  name: "statsEntities",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchStatsUnit.pending, (state) => {
        state.errorMessage = null
      })
      .addCase(fetchStatsUnit.fulfilled, (state, action) => {
        state.errorMessage = null
        statsEntitiesAdapter.addMany(state, action.payload.statsEntities);
      })
      .addCase(fetchStatsUnit.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })
  }
})

export default statsEntitiesSlice.reducer

export const {} = statsEntitiesSlice.actions

export const {
  selectAll: selectAllStatsEntities,
  selectById: selectStatsEntityByReference
} = statsEntitiesAdapter.getSelectors(state => state.statsEntities)

// Since this returns a new Object, memoize it to avoid unnecessary re-renders
export const selectStatsEntitiesByReference = createSelector(
  [
    (state) => state.statsEntities,
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

// Since this returns a new Array, memoize it to avoid unnecessary re-renders
export const selectWeaponsForStatsEntitiesByReference = createSelector(
  [
    (state) => state.statsEntities,
    (state, references) => references
  ],
  (state, references) => {
    const result = new Set()
    if (references) {
      references.forEach(r => {
        const entity = state.entities[r].data
        if (Object.keys(entity).includes("weapons")) {
          const weapons = entity.weapons
          weapons.forEach(w => result.add(w))
        }
      })
    }
    return result
  }
)
