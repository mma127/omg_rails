import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, fetchSnapshotCompanySquads, upsertSquads } from "../units/squadsSlice";
import {
  addNewCompanyOffmap,
  removeExistingCompanyOffmap,
  removeNewCompanyOffmap
} from "../company_offmaps/companyOffmapsSlice";

const availableOffmapsAdapter = createEntityAdapter()
const initialState = availableOffmapsAdapter.getInitialState({})

const availableOffmapsSlice = createSlice({
  name: "availableOffmaps",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        availableOffmapsAdapter.setAll(state, action.payload.availableOffmaps)
      })
      .addCase(fetchSnapshotCompanySquads.fulfilled, (state, action) => {
        availableOffmapsAdapter.setAll(state, action.payload.availableOffmaps)
      })
      .addCase(upsertSquads.fulfilled, (state, action) => {
        availableOffmapsAdapter.setAll(state, action.payload.availableOffmaps)
      })
      .addCase(addNewCompanyOffmap, (state, action) => {
        const { newCompanyOffmap } = action.payload
        const availableOffmapId = newCompanyOffmap.availableOffmapId
        const availableOffmapEntity = state.entities[availableOffmapId]
        availableOffmapEntity.available -= 1
      })
      .addCase(removeNewCompanyOffmap, (state, action) => {
        const { availableOffmapId } = action.payload
        const availableOffmapEntity = state.entities[availableOffmapId]
        availableOffmapEntity.available += 1
      })
      .addCase(removeExistingCompanyOffmap, (state, action) => {
        const { availableOffmapId } = action.payload
        const availableOffmapEntity = state.entities[availableOffmapId]
        availableOffmapEntity.available += 1
      })
  }
})

export default availableOffmapsSlice.reducer
export const {
  selectAll: selectAllAvailableOffmaps,
  selectById: selectAvailableOffmapById
} = availableOffmapsAdapter.getSelectors(state => state.availableOffmaps)
